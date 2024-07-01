import XCTest
import LocalAuthentication

@testable import SimpleKeychain

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let KeychainService = "com.auth0.simplekeychain.tests"

class SimpleKeychainTests: XCTestCase {
    var sut: SimpleKeychain!
    
    override func setUp() {
        super.setUp()
        sut = SimpleKeychain()
    }
    
    override func tearDown() {
        try? sut.deleteAll()
        sut = nil
        super.tearDown()
    }
    
    func testInitializationWithDefaultValues() {
        XCTAssertEqual(sut.accessGroup, nil)
        XCTAssertEqual(sut.service, Bundle.main.bundleIdentifier)
        XCTAssertEqual(sut.accessibility, Accessibility.afterFirstUnlock)
        XCTAssertEqual(sut.accessControlFlags, nil)
        XCTAssertEqual(sut.isSynchronizable, false)
        XCTAssertTrue(sut.attributes.isEmpty)
    }
    
    func testInitializationWithCustomValues() {
        sut = SimpleKeychain(service: KeychainService,
                             accessGroup: "Group",
                             accessibility: .whenUnlocked,
                             accessControlFlags: .userPresence,
                             synchronizable: true,
                             attributes: ["foo": "bar"])
        
        XCTAssertEqual(sut.accessGroup, "Group")
        XCTAssertEqual(sut.service, KeychainService)
        XCTAssertEqual(sut.accessibility, Accessibility.whenUnlocked)
        XCTAssertEqual(sut.accessControlFlags, .userPresence)
        XCTAssertEqual(sut.isSynchronizable, true)
        XCTAssertEqual(sut.attributes.count, 1)
        XCTAssertEqual(sut.attributes["foo"] as? String, "bar")
    }
    
    #if canImport(LocalAuthentication) && !os(tvOS)
    func testInitializationWithCustomLocalAuthenticationContext() {
        let context = LAContext()
        sut = SimpleKeychain(context: context)
        XCTAssertEqual(sut.context, context)
    }
    #endif
    
    func testStoringStringItemUnderNewKey() {
        let key = UUID().uuidString
        XCTAssertNoThrow(try sut.set("foo", forKey: key))
    }
    
    func testStoringStringItemUnderExistingKey() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        XCTAssertNoThrow(try sut.set("bar", forKey: key))
    }
    
    func testStoringDataItemUnderNewKey() {
        let key = UUID().uuidString
        XCTAssertNoThrow(try sut.set(Data(), forKey: key))
    }
    
    func testStoringDataItemUnderExistingKey() {
        let key = UUID().uuidString
        try? sut.set(Data(), forKey: key)
        XCTAssertNoThrow(try sut.set(Data(), forKey: key))
    }
    
    func testDeletingItem() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        XCTAssertNoThrow(try sut.deleteItem(forKey: key))
    }
    
    func testDeletingNonExistingItem() {
        XCTAssertThrowsError(try sut.deleteItem(forKey: "SHOULDNOTEXIST"))
    }
    
    func testDeletingAllItems() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        try? sut.deleteAll()
        XCTAssertThrowsError(try sut.string(forKey: key))
    }
    
    #if os(macOS)
    func testIncludingLimitAllAttributeWhenDeletingAllItems() {
        var limit: String?
        sut.remove = { query in
            let key = kSecMatchLimit as String
            limit = (query as NSDictionary).value(forKey: key) as? String
            return errSecSuccess
        }
        try? sut.deleteAll()
        XCTAssertEqual(limit, kSecMatchLimitAll as String)
    }
    #else
    func testNotIncludingLimitAllAttributeWhenDeletingAllItems() {
        var limit: String? = ""
        sut.remove = { query in
            let key = kSecMatchLimit as String
            limit = (query as NSDictionary).value(forKey: key) as? String
            return errSecSuccess
        }
        try? sut.deleteAll()
        XCTAssertNil(limit)
    }
    #endif
    
    func testRetrievingStringItem() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        XCTAssertEqual(try? sut.string(forKey: key), "foo")
    }
    
    func testRetrievingDataItem() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        XCTAssertNotNil(try? sut.data(forKey: key))
    }
    
    func testRetrievingNonExistingStringItem() {
        XCTAssertThrowsError(try sut.string(forKey: "SHOULDNOTEXIST")) { error in
            XCTAssertEqual(error as? SimpleKeychainError, .itemNotFound)
        }
    }
    
    func testRetrievingNonExistingDataItem() {
        XCTAssertThrowsError(try sut.data(forKey: "SHOULDNOTEXIST")) { error in
            XCTAssertEqual(error as? SimpleKeychainError, .itemNotFound)
        }
    }
    
    func testRetrievingStringItemThatCannotBeDecoded() {
        let key = UUID().uuidString
        let message = "Unable to convert the retrieved item to a String value"
        let expectedError = SimpleKeychainError(code: .unknown(message: message))
        sut.retrieve = { _, result in
            result?.pointee = .some(NSData(data: withUnsafeBytes(of: Date()) { Data($0) }))
            return errSecSuccess
        }
        XCTAssertThrowsError(try sut.string(forKey: key)) { error in
            XCTAssertEqual(error as? SimpleKeychainError, expectedError)
        }
    }
    
    func testRetrievingInvalidDataItem() {
        let key = UUID().uuidString
        let message = "Unable to cast the retrieved item to a Data value"
        let expectedError = SimpleKeychainError(code: .unknown(message: message))
        sut.retrieve = { _, result in
            result?.pointee = .some(NSDate())
            return errSecSuccess
        }
        XCTAssertThrowsError(try sut.string(forKey: key)) { error in
            XCTAssertEqual(error as? SimpleKeychainError, expectedError)
        }
    }
    
    func testCheckingStoredItem() {
        let key = UUID().uuidString
        try? sut.set("foo", forKey: key)
        XCTAssertTrue(try sut.hasItem(forKey: key))
    }
    
    func testCheckingNonExistingItem() {
        XCTAssertFalse(try sut.hasItem(forKey: "SHOULDNOTEXIST"))
    }
    
    func testRetrievingKeys() {
        var keys: [String] = []
        try? sut.deleteAll()
        keys.append(UUID().uuidString)
        keys.append(UUID().uuidString)
        keys.append(UUID().uuidString)
        for (i, key) in keys.enumerated() {
            try? sut.set("foo\(i)", forKey: key)
        }
        XCTAssertEqual(try sut.keys(), keys)
    }
    
    func testRetrievingEmptyKeys() {
        var keys: [String] = []
        try? sut.deleteAll()
        keys.append(UUID().uuidString)
        keys.append(UUID().uuidString)
        keys.append(UUID().uuidString)
        for (i, key) in keys.enumerated() {
            try? sut.set("foo\(i)", forKey: key)
        }
        for key in keys {
            XCTAssertNotNil(try? sut.data(forKey: key))
        }
        XCTAssertEqual(try sut.keys().count, keys.count)
        try? sut.deleteAll()
        let expectedError = SimpleKeychainError.itemNotFound
        for key in keys {
            XCTAssertThrowsError(try sut.data(forKey: key)) { error in
                XCTAssertEqual(error as? SimpleKeychainError, expectedError)
            }
        }
        XCTAssertEqual(try sut.keys().count, 0)
    }
    
    func testRetrievingInvalidAttributes() {
        let message = "Unable to cast the retrieved items to a [[String: Any]] value"
        let expectedError = SimpleKeychainError(code: .unknown(message: message))
        sut.retrieve = { _, result in
            result?.pointee = .some(NSDate())
            return errSecSuccess
        }
        XCTAssertThrowsError(try sut.keys()) { error in
            XCTAssertEqual(error as? SimpleKeychainError, expectedError)
        }
    }
    
    func testBaseQueryContainsDefaultAttributes() {
        let query = sut.baseQuery()
        XCTAssertEqual(query[kSecClass as String] as? String, kSecClassGenericPassword as String)
        XCTAssertEqual(query[kSecAttrService as String] as? String, sut.service)
        XCTAssertNil(query[kSecAttrAccount as String] as? String)
        XCTAssertNil(query[kSecValueData as String] as? Data)
        XCTAssertNil(query[kSecAttrAccessGroup as String] as? String)
        XCTAssertNil(query[kSecAttrSynchronizable as String] as? Bool)
        #if canImport(LocalAuthentication) && !os(tvOS)
        XCTAssertNil(query[kSecUseAuthenticationContext as String] as? LAContext)
        #endif
    }
    
    func testBaseQueryIncludesAdditionalAttributes() {
        let key = "foo"
        let value = "bar"
        sut = SimpleKeychain(attributes: [key: value])
        let query = sut.baseQuery()
        XCTAssertEqual(query[key] as? String, value)
    }
    
    func testBaseQuerySupersedesAdditionalAttributes() {
        let key = kSecAttrService as String
        let value = "foo"
        sut = SimpleKeychain(attributes: [key: value])
        let query = sut.baseQuery()
        XCTAssertEqual(query[key] as? String, sut.service)
    }
    
    func testBaseQueryIncludesAccountAttribute() {
        let key = "foo"
        let query = sut.baseQuery(withKey: key)
        XCTAssertEqual(query[kSecAttrAccount as String] as? String, key)
    }
    
    func testBaseQueryIncludesDataAttribute() {
        let data = Data()
        let query = sut.baseQuery(data: data)
        XCTAssertEqual(query[kSecValueData as String] as? Data, data)
    }
    
    func testBaseQueryIncludesAccessGroupAttribute() {
        sut = SimpleKeychain(accessGroup: "foo")
        let query = sut.baseQuery()
        XCTAssertEqual(query[kSecAttrAccessGroup as String] as? String, sut.accessGroup)
    }
    
    func testBaseQueryIncludesSynchronizableAttribute() {
        sut = SimpleKeychain(synchronizable: true)
        let query = sut.baseQuery()
        XCTAssertEqual(query[kSecAttrSynchronizable as String] as? Bool, sut.isSynchronizable)
    }
    
    #if canImport(LocalAuthentication) && !os(tvOS)
    func testBaseQueryIncludesContextAttribute() {
        sut = SimpleKeychain(context: LAContext())
        let query = sut.baseQuery()
        XCTAssertEqual(query[kSecUseAuthenticationContext as String] as? LAContext, sut.context)
    }
    #endif
    
    func testGetAllQueryContainsBaseQuery() {
        let baseQuery = sut.baseQuery()
        let query = sut.getAllQuery
        XCTAssertTrue(query.containsBaseQuery(baseQuery))
    }
    
    func testGetAllQueryContainsReturnAttribute() {
        let query = sut.getAllQuery
        XCTAssertEqual(query[kSecReturnAttributes as String] as? Bool, true)
    }
    
    func testGetAllQueryContainsLimitAttribute() {
        let query = sut.getAllQuery
        XCTAssertEqual(query[kSecMatchLimit as String] as? String, kSecMatchLimitAll as String)
    }
    
    func testGetOneQueryContainsBaseQuery() {
        let key = "foo"
        let baseQuery = sut.baseQuery(withKey: key)
        let query = sut.getOneQuery(byKey: key)
        XCTAssertTrue(query.containsBaseQuery(baseQuery))
    }
    
    func testGetOneQueryContainsDataAttribute() {
        let query = sut.getOneQuery(byKey: "foo")
        XCTAssertEqual(query[kSecReturnData as String] as? Bool, true)
    }
    
    func testGetOneQueryContainsLimitAttribute() {
        let query = sut.getOneQuery(byKey: "foo")
        XCTAssertEqual(query[kSecMatchLimit as String] as? String, kSecMatchLimitOne as String)
    }
    
    func testSetQueryContainsBaseQuery() {
        let key = "foo"
        let data = Data()
        let baseQuery = sut.baseQuery(withKey: key, data: data)
        let query = sut.setQuery(forKey: key, data: data)
        XCTAssertTrue(query.containsBaseQuery(baseQuery))
    }
    
    func testSetQueryIncludesAccessControlAttribute() {
        sut = SimpleKeychain(accessControlFlags: .userPresence)
        let query = sut.setQuery(forKey: "foo", data: Data())
        XCTAssertNotNil(query[kSecAttrAccessControl as String])
    }
    
    #if os(macOS)
    func testSetQueryDoesNotIncludeAccessibilityAttributeByDefault() {
        let query = sut.setQuery(forKey: "foo", data: Data())
        XCTAssertNil(query[kSecAttrAccessible as String] as? String)
    }
    
    func testSetQueryIncludesAccessibilityAttributeWhenICloudSharingIsEnabled() {
        sut = SimpleKeychain(synchronizable: true)
        let query = sut.setQuery(forKey: "foo", data: Data())
        let expectedAccessibility = sut.accessibility.rawValue as String
        XCTAssertEqual(query[kSecAttrAccessible as String] as? String, expectedAccessibility)
    }
    
    func testSetQueryIncludesAccessibilityAttributeWhenDataProtectionIsEnabled() {
        let attributes = [kSecUseDataProtectionKeychain as String: kCFBooleanTrue as Any]
        sut = SimpleKeychain(attributes: attributes)
        let query = sut.setQuery(forKey: "foo", data: Data())
        let expectedAccessibility = sut.accessibility.rawValue as String
        XCTAssertEqual(query[kSecAttrAccessible as String] as? String, expectedAccessibility)
    }
    #else
    func testSetQueryIncludesAccessibilityAttribute() {
        let query = sut.setQuery(forKey: "foo", data: Data())
        let expectedAccessibility = sut.accessibility.rawValue as String
        XCTAssertEqual(query[kSecAttrAccessible as String] as? String, expectedAccessibility)
    }
    #endif
}

public extension Dictionary where Key == String, Value == Any {
    func containsBaseQuery(_ baseQuery: [String: Any]) -> Bool {
        let filtered = self.filter { element in
            return baseQuery.keys.contains(element.key)
        }
        return filtered == baseQuery
    }
}

public func ==(lhs: [String: Any], rhs: [String: Any]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

