import LocalAuthentication
import Nimble
import Quick

@testable import SimpleKeychain

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let KeychainService = "com.auth0.simplekeychain.tests"

class SimpleKeychainSpec: QuickSpec {
    override func spec() {
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
                }

                it("should init with custom values") {
                    sut = SimpleKeychain(service: KeychainService,
                                         accessGroup: "Group",
                                         accessibility: .whenUnlocked,
                                         accessControlFlags: .userPresence,
                                         synchronizable: true)
                    expect(sut.accessGroup) == "Group"
                    expect(sut.service) == KeychainService
                    expect(sut.accessibility) == Accessibility.whenUnlocked
                    expect(sut.accessControlFlags) == .userPresence
                    expect(sut.isSynchronizable) == true
                }

                #if canImport(LocalAuthentication)
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
                        expect(try sut.set("value", forKey: key)).toNot(throwError())
                    }

                    it("should store a string item under an existing key") {
                        try sut.set("value1", forKey: key)
                        expect(try sut.set("value2", forKey: key)).toNot(throwError())
                    }

                    it("should store a string item with the default accessibility value") {
                        var accessible: String?
                        sut = SimpleKeychain(service: KeychainService)
                        sut.store = { query, _ in
                            let key = kSecAttrAccessible as String
                            accessible = (query as NSDictionary).value(forKey: key) as? String
                            return errSecSuccess
                        }
                        try sut.set("value", forKey: key)
                        expect(accessible).toEventually(equal(kSecAttrAccessibleAfterFirstUnlock as String))
                    }

                    it("should store a string item with a custom accessibility value") {
                        var accessible: String?
                        sut = SimpleKeychain(service: KeychainService, accessibility: .whenUnlocked)
                        sut.store = { query, _ in
                            let key = kSecAttrAccessible as String
                            accessible = (query as NSDictionary).value(forKey: key) as? String
                            return errSecSuccess
                        }
                        try sut.set("value", forKey: key)
                        expect(accessible).toEventually(equal(kSecAttrAccessibleWhenUnlocked as String))
                    }

                    it("should store a string item with access control") {
                        var accessControl: AnyObject?
                        sut = SimpleKeychain(service: KeychainService, accessControlFlags: .privateKeyUsage)
                        sut.store = { query, _ in
                            let key = kSecAttrAccessControl as String
                            accessControl = (query as NSDictionary).value(forKey: key) as AnyObject
                            return errSecSuccess
                        }
                        try sut.set("value", forKey: key)
                        expect(accessControl).toEventuallyNot(beNil())
                    }

                    it("should store a non-synchronizable string item by default") {
                        var synchronizable: Bool? = false
                        sut = SimpleKeychain(service: KeychainService)
                        sut.store = { query, _ in
                            let key = kSecAttrSynchronizable as String
                            synchronizable = (query as NSDictionary).value(forKey: key) as? Bool
                            return errSecSuccess
                        }
                        try sut.set("value", forKey: key)
                        expect(synchronizable).toEventually(beNil())
                    }

                    it("should store a synchronizable string item") {
                        var synchronizable: Bool?
                        sut = SimpleKeychain(service: KeychainService, synchronizable: true)
                        sut.store = { query, _ in
                            let key = kSecAttrSynchronizable as String
                            synchronizable = (query as NSDictionary).value(forKey: key) as? Bool
                            return errSecSuccess
                        }
                        try sut.set("value", forKey: key)
                        expect(synchronizable).toEventually(equal(true))
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

                    it("should store a data item with the default accessibility value") {
                        var accessible: String?
                        sut = SimpleKeychain(service: KeychainService)
                        sut.store = { query, _ in
                            let key = kSecAttrAccessible as String
                            accessible = (query as NSDictionary).value(forKey: key) as? String
                            return errSecSuccess
                        }
                        try sut.set(Data(), forKey: key)
                        expect(accessible).toEventually(equal(kSecAttrAccessibleAfterFirstUnlock as String))
                    }

                    it("should store a string item with a custom accessibility value") {
                        sut = SimpleKeychain(service: KeychainService, accessibility: .whenUnlocked)
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }

                    it("should store a data item with access control") {
                        let key = kSecAttrAccessControl as String
                        var accessControl: AnyObject?
                        sut = SimpleKeychain(service: KeychainService, accessControlFlags: .privateKeyUsage)
                        sut.store = { query, _ in
                            accessControl = (query as NSDictionary).value(forKey: key) as AnyObject
                            return errSecSuccess
                        }
                        try sut.set(Data(), forKey: key)
                        expect(accessControl).toEventuallyNot(beNil())
                    }

                    it("should store a non-synchronizable data item by default") {
                        var synchronizable: Bool? = false
                        sut = SimpleKeychain(service: KeychainService)
                        sut.store = { query, _ in
                            let key = kSecAttrSynchronizable as String
                            synchronizable = (query as NSDictionary).value(forKey: key) as? Bool
                            return errSecSuccess
                        }
                        try sut.set(Data(), forKey: key)
                        expect(synchronizable).toEventually(beNil())
                    }

                    it("should store a synchronizable data item") {
                        var synchronizable: Bool?
                        sut = SimpleKeychain(service: KeychainService, synchronizable: true)
                        sut.store = { query, _ in
                            let key = kSecAttrSynchronizable as String
                            synchronizable = (query as NSDictionary).value(forKey: key) as? Bool
                            return errSecSuccess
                        }
                        try sut.set(Data(), forKey: key)
                        expect(synchronizable).toEventually(equal(true))
                    }
                }
            }

            describe("removing items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                    try! sut.set("value1", forKey: key)
                }

                it("should delete item") {
                    expect(try sut.deleteItem(forKey: key)).toNot(throwError())
                }

                it("should throw an error when deleting an item with a non-existing key") {
                    expect(try sut.deleteItem(forKey: "SHOULDNOTEXIST")).to(throwError())
                }

                it("should clear all items") {
                    try sut.deleteAll()
                    expect(try sut.string(forKey: key)).to(throwError(SimpleKeychainError.itemNotFound))
                }
            }

            describe("retrieving items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: KeychainService)
                    key = UUID().uuidString
                    try! sut.set("value1", forKey: key)
                }

                it("should retrieve string item") {
                    expect(try sut.string(forKey: key)) == "value1"
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
                    try! sut.set("value1", forKey: key)
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
                        try! sut.set("value\(i)", forKey: key)
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
        }
    }
}
