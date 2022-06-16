import Foundation
import Security
#if canImport(LocalAuthentication)
import LocalAuthentication
#endif

/// A simple Keychain wrapper for iOS, macOS, tvOS, and watchOS.
/// Supports sharing items with an **Access Group** and integrating **Touch ID / Face ID** through a `LAContext` instance.
public struct SimpleKeychain {
    let service: String
    let accessGroup: String?
    let accessibility: Accessibility
    let accessControlFlags: SecAccessControlCreateFlags?

    #if canImport(LocalAuthentication)
    let context: LAContext

    /// Initializes a ``SimpleKeychain`` instance.
    ///
    /// - Parameter service: Name of the service to save items under. Defaults to the bundle identifier.
    /// - Parameter accessGroup: Access Group for sharing Keychain items. Defaults to `nil`.
    /// - Parameter accessibility: ``Accessibility`` type the stored items will have. Defaults to ``Accessibility/afterFirstUnlock``.
    /// - Parameter accessControlFlags: Access control conditions for `kSecAttrAccessControl`.
    ///   When set, `kSecAttrAccessControl` will be used instead of `kSecAttrAccessible`.  Defaults to `nil`.
    /// - Parameter context: `LAContext` used to access Keychain items. Defaults to a new `LAContext` instance.
    /// - Returns: A ``SimpleKeychain`` instance.
    public init(service: String = Bundle.main.bundleIdentifier!,
                accessGroup: String? = nil,
                accessibility: Accessibility = .afterFirstUnlock,
                accessControlFlags: SecAccessControlCreateFlags? = nil,
                context: LAContext = LAContext()) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.accessControlFlags = accessControlFlags
        self.context = context
    }
    #else
    /// Initializes a ``SimpleKeychain`` instance.
    ///
    /// - Parameter service: Name of the service to save items under. Defaults to the bundle identifier.
    /// - Parameter accessGroup: Access Group for sharing Keychain items. Defaults to `nil`.
    /// - Parameter accessibility: ``Accessibility`` type the stored items will have. Defaults to ``Accessibility/afterFirstUnlock``.
    /// - Parameter accessControlFlags: Access control conditions for `kSecAttrAccessControl`.
    ///   When set, `kSecAttrAccessControl` will be used instead of `kSecAttrAccessible`.  Defaults to `nil`.
    /// - Returns: A ``SimpleKeychain`` instance.
    public init(service: String = Bundle.main.bundleIdentifier!,
                accessGroup: String? = nil,
                accessibility: Accessibility = .afterFirstUnlock,
                accessControlFlags: SecAccessControlCreateFlags? = nil) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.accessControlFlags = accessControlFlags
    }
    #endif

    private func assertSuccess(forStatus status: OSStatus) throws {
        if status != errSecSuccess {
            throw SimpleKeychainError(code: SimpleKeychainError.Code(rawValue: status))
        }
    }
}

// MARK: - Retrieve items

public extension SimpleKeychain {
    /// Retrieves a `String`value from the Keychain.
    ///
    /// - Parameter key: Key of the Keychain item to retrieve.
    /// - Returns: The `String` value.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func string(forKey key: String) throws -> String {
        let data = try self.data(forKey: key)

        guard let result = String(data: data, encoding: .utf8) else {
            let message = "Unable to convert the retrieved item to a String value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        return result
    }

    /// Retrieves a `Data` value from the Keychain.
    ///
    /// - Parameter key: Key of the Keychain item to retrieve.
    /// - Returns: The `Data` value.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func data(forKey key: String) throws -> Data {
        let query = self.getOneQuery(byKey: key)
        var result: AnyObject?
        try assertSuccess(forStatus: SecItemCopyMatching(query as CFDictionary, &result))

        guard let data = result as? Data else {
            let message = "Unable to cast the retrieved item to a Data value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        return data
    }
}

// MARK: - Store items

public extension SimpleKeychain {
    /// Saves a `String` value with the type `kSecClassGenericPassword` in the Keychain.
    ///
    /// - Parameter string: Value to save in the Keychain.
    /// - Parameter key: Key for the Keychain item.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func set(_ string: String, forKey key: String) throws {
        guard let data = string.data(using: .utf8) else {
            let message = "Unable to encode the string into a Data value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        return try self.set(data, forKey: key)
    }

    /// Saves a `Data` value with the type `kSecClassGenericPassword` in the Keychain.
    ///
    /// - Parameter data: Value to save in the Keychain.
    /// - Parameter key: Key for the Keychain item.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func set(_ data: Data, forKey key: String) throws {
        let addItemQuery = self.setQuery(forKey: key, value: data)
        let addStatus = SecItemAdd(addItemQuery as CFDictionary, nil)

        if addStatus == errSecDuplicateItem {
            let updateQuery = self.baseQuery(withKey: key)
            let updateAttributes = self.attributes(withData: data)
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
            try assertSuccess(forStatus: updateStatus)
        } else {
            try assertSuccess(forStatus: addStatus)
        }
    }
}

// MARK: - Delete items

public extension SimpleKeychain {
    /// Deletes an item from the Keychain.
    ///
    /// - Parameter key: Key of the Keychain item to delete..
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func deleteItem(forKey key: String) throws {
        let query = self.baseQuery(withKey: key)
        try assertSuccess(forStatus: SecItemDelete(query as CFDictionary))
    }

    /// Deletes all items from the Keychain for the service and access group values.
    func deleteAll() throws {
        var query = self.baseQuery()
        #if os(macOS)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        #endif
        let status = SecItemDelete(query as CFDictionary)
        guard SimpleKeychainError.Code(rawValue: status) != SimpleKeychainError.Code.itemNotFound else { return }
        try assertSuccess(forStatus: status)
    }
}

// MARK: - Convenience methods

public extension SimpleKeychain {
    /// Checks if an item is stored in the Keychain.
    ///
    /// - Parameter key: Key of the Keychain item to check.
    /// - Returns: Whether the item is stored in the Keychain or not.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func hasItem(forKey key: String) throws -> Bool {
        let query = self.baseQuery(withKey: key)
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecItemNotFound {
            return false
        }
        try assertSuccess(forStatus: status)
        return true
    }

    /// Retrieves the keys of all the items stored in the Keychain for the service and access group values.
    ///
    /// - Returns: A `String` array containing the keys.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func keys() throws -> [String] {
        let query = self.getAllQuery
        var keys: [String] = []
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard SimpleKeychainError.Code(rawValue: status) != SimpleKeychainError.Code.itemNotFound else { return keys }
        try assertSuccess(forStatus: status)

        guard let items = result as? [[String: Any]] else {
            let message = "Unable to cast the retrieved items to a [[String: Any]] value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        for item in items {
            if let key = item[kSecAttrAccount as String] as? String {
                keys.append(key)
            }
        }

        return keys
    }
}

// MARK: - Queries

extension SimpleKeychain {
    func baseQuery(withKey key: String? = nil, data: Data? = nil) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.service
        ]
        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        if let key = key {
            query[kSecAttrAccount as String] = key
        }
        if let data = data {
            query[kSecValueData as String] = data
        }
        #if !targetEnvironment(simulator) && canImport(LocalAuthentication)
        query[kSecUseAuthenticationContext as String] = self.context
        #endif
        return query
    }

    var getAllQuery: [String: Any] {
        var query = self.baseQuery()
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        return query
    }

    func getOneQuery(byKey key: String) -> [String: Any] {
        var query = self.baseQuery(withKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        return query
    }

    func setQuery(forKey key: String, value: Data) -> [String: Any] {
        var query = self.baseQuery(withKey: key, data: value)

        if let flags = self.accessControlFlags,
           let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault, self.accessibility.rawValue, flags, nil) {
            query[kSecAttrAccessControl as String] = access
        } else {
            query[kSecAttrAccessible as String] = self.accessibility.rawValue
        }

        return query
    }

    func attributes(withData data: Data) -> [String: Any] {
        return [kSecValueData as String: data]
    }
}
