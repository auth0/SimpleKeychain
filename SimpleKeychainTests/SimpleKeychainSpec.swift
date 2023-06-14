import LocalAuthentication
import Nimble
import Quick

@testable import SimpleKeychain

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let KeychainService = "com.auth0.simplekeychain.tests"

class SimpleKeychainSpec: AsyncSpec {
    override class func spec() {
        describe("SimpleKeychain") {
            var sut: SimpleKeychain!

            afterEach {
                try? sut.deleteAll()
            }

            describe("initialization") {
                it("should init with default values") {
                    sut = SimpleKeychain()
                    expect(sut.accessGroup).to(beNil())
                    expect(sut.service) == Bundle.main.bundleIdentifier
                    expect(sut.accessibility) == Accessibility.afterFirstUnlock
                    expect(sut.accessControlFlags).to(beNil())
                    expect(sut.isSynchronizable) == false
                    expect(sut.attributes).to(beEmpty())
                }

                it("should init with custom values") {
                    sut = SimpleKeychain(service: KeychainService,
                                         accessGroup: "Group",
                                         accessibility: .whenUnlocked,
                                         accessControlFlags: .userPresence,
                                         synchronizable: true,
                                         attributes: ["foo": "bar"])
                    expect(sut.accessGroup) == "Group"
                    expect(sut.service) == KeychainService
                    expect(sut.accessibility) == Accessibility.whenUnlocked
                    expect(sut.accessControlFlags) == .userPresence
                    expect(sut.isSynchronizable) == true
                    expect(sut.attributes.count) == 1
                    expect(sut.attributes["foo"] as? String) == "bar"
                }

                #if canImport(LocalAuthentication) && !os(tvOS)
                it("should init with custom local authentication context") {
                    let context = LAContext()
                    sut = SimpleKeychain(context: context)
                    expect(sut.context).to(be(context))
                }
                #endif
            }

            describe("storing items") {
                var key: String!

                beforeEach({
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                })

                context("string items") {
                    it("should store a string item under a new key") {
                        expect(try sut.set("foo", forKey: key)).toNot(throwError())
                    }

                    it("should store a string item under an existing key") {
                        try sut.set("foo", forKey: key)
                        expect(try sut.set("bar", forKey: key)).toNot(throwError())
                    }
                }

                context("data items") {
                    it("should store a data item under a new key") {
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }

                    it("should store a data item under an existing key") {
                        try sut.set( Data(), forKey: key)
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }
                }
            }

            describe("removing items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                    try! sut.set("foo", forKey: key)
                }

                it("should delete item") {
                    expect(try sut.deleteItem(forKey: key)).toNot(throwError())
                }

                it("should throw an error when deleting an item with a non-existing key") {
                    expect(try sut.deleteItem(forKey: "SHOULDNOTEXIST")).to(throwError())
                }

                it("should delete all items") {
                    try sut.deleteAll()
                    expect(try sut.string(forKey: key)).to(throwError(SimpleKeychainError.itemNotFound))
                }

                #if os(macOS)
                it("should include limit all attribute when deleting all items") {
                    var limit: String?
                    sut.remove = { query in
                        let key = kSecMatchLimit as String
                        limit = (query as NSDictionary).value(forKey: key) as? String
                        return errSecSuccess
                    }
                    try sut.deleteAll()
                    expect(limit).toEventually(equal(kSecMatchLimitAll as String))
                }
                #else
                it("should not include limit all attribute when deleting all items") {
                    var limit: String? = ""
                    sut.remove = { query in
                        let key = kSecMatchLimit as String
                        limit = (query as NSDictionary).value(forKey: key) as? String
                        return errSecSuccess
                    }
                    try sut.deleteAll()
                    await expect(limit).toEventually(beNil())
                }
                #endif
            }

            describe("retrieving items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                    try! sut.set("foo", forKey: key)
                }

                it("should retrieve string item") {
                    expect(try sut.string(forKey: key)) == "foo"
                }

                it("should retrieve data item") {
                    expect(try sut.data(forKey: key)).notTo(beNil())
                }

                it("should throw error when retrieving a string item with non-existing key") {
                    let expectedError = SimpleKeychainError.itemNotFound
                    expect(try sut.string(forKey: "SHOULDNOTEXIST")).to(throwError(expectedError))
                }

                it("should throw error when retrieving a data item with non-existing key") {
                    let expectedError = SimpleKeychainError.itemNotFound
                    expect(try sut.data(forKey: "SHOULDNOTEXIST")).to(throwError(expectedError))
                }

                it("should throw an error when retrieving a string item that cannot be decoded") {
                    let message = "Unable to convert the retrieved item to a String value"
                    let expectedError = SimpleKeychainError(code: .unknown(message: message))
                    sut.retrieve = { _, result in
                        result?.pointee = .some(NSData(data: withUnsafeBytes(of: Date()) { Data($0) }))
                        return errSecSuccess
                    }
                    expect(try sut.string(forKey: key)).to(throwError(expectedError))
                }

                it("should throw an error when retrieving an invalid data item") {
                    let message = "Unable to cast the retrieved item to a Data value"
                    let expectedError = SimpleKeychainError(code: .unknown(message: message))
                    sut.retrieve = { _, result in
                        result?.pointee = .some(NSDate())
                        return errSecSuccess
                    }
                    expect(try sut.string(forKey: key)).to(throwError(expectedError))
                }
            }

            describe("checking items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                    try! sut.set("foo", forKey: key)
                }

                it("should return true when the item is stored") {
                    expect(try sut.hasItem(forKey: key)) == true
                }

                it("should return false when the item is not stored") {
                    expect(try sut.hasItem(forKey: "SHOULDNOTEXIST")) == false
                }
            }

            describe("retrieving keys") {
                var keys: [String] = []

                beforeEach {
                    try! sut.deleteAll()
                    sut = SimpleKeychain(service: KeychainService)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)
                    for (i, key) in keys.enumerated() {
                        try! sut.set("foo\(i)", forKey: key)
                    }
                }

                it("should return all the keys") {
                    expect(try sut.keys()) == keys
                }

                it("should return an empty array when there are no keys") {
                    for key in keys {
                        expect(try sut.data(forKey: key)).notTo(beNil())
                    }
                    expect(try sut.keys().count) == keys.count
                    try sut.deleteAll()
                    let expectedError = SimpleKeychainError.itemNotFound
                    for key in keys {
                        expect(try sut.data(forKey: key)).to(throwError(expectedError))
                    }
                    expect(try sut.keys().count) == 0
                }

                it("should throw an error when retrieving invalid attributes") {
                    let message = "Unable to cast the retrieved items to a [[String: Any]] value"
                    let expectedError = SimpleKeychainError(code: .unknown(message: message))
                    sut.retrieve = { _, result in
                        result?.pointee = .some(NSDate())
                        return errSecSuccess
                    }
                    expect(try sut.keys()).to(throwError(expectedError))
                }
            }

            describe("queries") {
                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                }

                context("base query") {
                    it("should contain default attributes") {
                        let query = sut.baseQuery()
                        expect((query[kSecClass as String] as? String)) == kSecClassGenericPassword as String
                        expect((query[kSecAttrService as String] as? String)) == sut.service
                        expect((query[kSecAttrAccount as String] as? String)).to(beNil())
                        expect((query[kSecValueData as String] as? Data)).to(beNil())
                        expect((query[kSecAttrAccessGroup as String] as? String)).to(beNil())
                        expect((query[kSecAttrSynchronizable as String] as? Bool)).to(beNil())
                        #if canImport(LocalAuthentication) && !os(tvOS)
                        expect((query[kSecUseAuthenticationContext as String] as? LAContext)).to(beNil())
                        #endif
                    }

                    it("should include additional attributes") {
                        let key = "foo"
                        let value = "bar"
                        sut = SimpleKeychain(attributes: [key: value])
                        let query = sut.baseQuery()
                        expect((query[key] as? String)) == value
                    }

                    it("should supersede additional attributes") {
                        let key = kSecAttrService as String
                        let value = "foo"
                        sut = SimpleKeychain(attributes: [key: value])
                        let query = sut.baseQuery()
                        expect((query[key] as? String)) == sut.service
                    }

                    it("should include account attribute") {
                        let key = "foo"
                        let query = sut.baseQuery(withKey: key)
                        expect((query[kSecAttrAccount as String] as? String)) == key
                    }

                    it("should include data attribute") {
                        let data = Data()
                        let query = sut.baseQuery(data: data)
                        expect((query[kSecValueData as String] as? Data)) == data
                    }

                    it("should include access group attribute") {
                        sut = SimpleKeychain(accessGroup: "foo")
                        let query = sut.baseQuery()
                        expect((query[kSecAttrAccessGroup as String] as? String)) == sut.accessGroup
                    }

                    it("should include synchronizable attribute") {
                        sut = SimpleKeychain(synchronizable: true)
                        let query = sut.baseQuery()
                        expect((query[kSecAttrSynchronizable as String] as? Bool)) == sut.isSynchronizable
                    }

                    #if canImport(LocalAuthentication) && !os(tvOS)
                    it("should include context attribute") {
                        sut = SimpleKeychain(context: LAContext())
                        let query = sut.baseQuery()
                        expect((query[kSecUseAuthenticationContext as String] as? LAContext)) == sut.context
                    }
                    #endif
                }

                context("get all query") {
                    it("should contain the base query") {
                        expect(sut.getAllQuery).to(containBaseQuery(sut.baseQuery()))
                    }

                    it("should contain return attribute") {
                        let query = sut.getAllQuery
                        expect((query[kSecReturnAttributes as String] as? Bool)) == true
                    }

                    it("should contain limit attribute") {
                        let query = sut.getAllQuery
                        expect((query[kSecMatchLimit as String] as? String)) == kSecMatchLimitAll as String
                    }
                }

                context("get one query") {
                    it("should contain the base query") {
                        let key = "foo"
                        expect(sut.getOneQuery(byKey: key)).to(containBaseQuery(sut.baseQuery(withKey: key)))
                    }

                    it("should contain data attribute") {
                        let query = sut.getOneQuery(byKey: "foo")
                        expect((query[kSecReturnData as String] as? Bool)) == true
                    }

                    it("should contain limit attribute") {
                        let query = sut.getOneQuery(byKey: "foo")
                        expect((query[kSecMatchLimit as String] as? String)) == kSecMatchLimitOne as String
                    }
                }

                context("set query") {
                    it("should contain the base query") {
                        let key = "foo"
                        let data = Data()
                        let query = sut.setQuery(forKey: key, data: data)
                        let baseQuery = sut.baseQuery(withKey: key, data: data)
                        expect(query).to(containBaseQuery(baseQuery))
                    }

                    it("should include access control attribute") {
                        sut = SimpleKeychain(accessControlFlags: .userPresence)
                        let query = sut.setQuery(forKey: "foo", data: Data())
                        expect(query[kSecAttrAccessControl as String]).toNot(beNil())
                    }

                    #if os(macOS)
                    it("should not include accessibility attribute by default") {
                        let query = sut.setQuery(forKey: "foo", data: Data())
                        expect((query[kSecAttrAccessible as String] as? String)).to(beNil())
                    }

                    it("should include accessibility attribute when iCloud sharing is enabled") {
                        sut = SimpleKeychain(synchronizable: true)
                        let query = sut.setQuery(forKey: "foo", data: Data())
                        let expectedAccessibility = sut.accessibility.rawValue as String
                        expect((query[kSecAttrAccessible as String] as? String)) == expectedAccessibility
                    }

                    it("should include accessibility attribute when data protection is enabled") {
                        let attributes = [kSecUseDataProtectionKeychain as String: kCFBooleanTrue as Any]
                        sut = SimpleKeychain(attributes: attributes)
                        let query = sut.setQuery(forKey: "foo", data: Data())
                        let expectedAccessibility = sut.accessibility.rawValue as String
                        expect((query[kSecAttrAccessible as String] as? String)) == expectedAccessibility
                    }
                    #else
                    it("should include accessibility attribute") {
                        let query = sut.setQuery(forKey: "foo", data: Data())
                        let expectedAccessibility = sut.accessibility.rawValue as String
                        expect((query[kSecAttrAccessible as String] as? String)) == expectedAccessibility
                    }
                    #endif
                }
            }
        }
    }
}

public func containBaseQuery(_ baseQuery: [String: Any]) -> Predicate<[String: Any]> {
    return Predicate<[String: Any]>.define("contains base query <\(baseQuery)>") { expression, failureMessage in
        guard let actual = try expression.evaluate() else {
            return PredicateResult(status: .doesNotMatch, message: failureMessage)
        }
        let filtered = actual.filter { element in
            return baseQuery.keys.contains(element.key)
        }
        return PredicateResult(bool: filtered == baseQuery, message: failureMessage)
    }
}

public func ==(lhs: [String: Any], rhs: [String: Any]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
