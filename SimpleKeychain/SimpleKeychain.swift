import Foundation
import Security
#if canImport(LocalAuthentication)
import LocalAuthentication
#endif

typealias RetrieveFunction = (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
typealias RemoveFunction = (_ query: CFDictionary) -> OSStatus

/// A simple Keychain wrapper for iOS, macOS, tvOS, and watchOS.
/// Supports sharing credentials with an **access group** or through **iCloud**, and integrating **Touch ID / Face ID**.
public struct SimpleKeychain {
    let service: String
    let accessGroup: String?
    let accessibility: Accessibility
    let accessControlFlags: SecAccessControlCreateFlags?
    let isSynchronizable: Bool
    let attributes: [String: Any]

    var retrieve: RetrieveFunction = SecItemCopyMatching
    var remove: RemoveFunction = SecItemDelete

    #if canImport(LocalAuthentication) && !os(tvOS)
    let context: LAContext?

    /// Initializes a ``SimpleKeychain`` instance.
    ///
    /// - Parameter service: Name of the service under which to save items. Defaults to the bundle identifier.
    /// - Parameter accessGroup: access group for sharing Keychain items. Defaults to `nil`.
    /// - Parameter accessibility: ``Accessibility`` type the stored items will have. Defaults to ``Accessibility/afterFirstUnlock``.
    /// - Parameter accessControlFlags: Access control conditions for `kSecAttrAccessControl`.  Defaults to `nil`.
    /// - Parameter context: `LAContext` used to access Keychain items. Defaults to `nil`.
    /// - Parameter synchronizable: Whether the items should be synchronized through iCloud. Defaults to `false`.
    /// - Parameter attributes: Additional attributes to include in every query. Defaults to an empty dictionary.
    /// - Returns: A ``SimpleKeychain`` instance.
    public init(service: String = Bundle.main.bundleIdentifier!,
                accessGroup: String? = nil,
                accessibility: Accessibility = .afterFirstUnlock,
                accessControlFlags: SecAccessControlCreateFlags? = nil,
                context: LAContext? = nil,
                synchronizable: Bool = false,
                attributes: [String: Any] = [:]) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.accessControlFlags = accessControlFlags
        self.context = context
        self.isSynchronizable = synchronizable
        self.attributes = attributes
    }
    #else
    /// Initializes a ``SimpleKeychain`` instance.
    ///
    /// - Parameter service: Name of the service under which to save items. Defaults to the bundle identifier.
    /// - Parameter accessGroup: access group for sharing Keychain items. Defaults to `nil`.
    /// - Parameter accessibility: ``Accessibility`` type the stored items will have. Defaults to ``Accessibility/afterFirstUnlock``.
    /// - Parameter accessControlFlags: Access control conditions for `kSecAttrAccessControl`.  Defaults to `nil`.
    /// - Parameter synchronizable: Whether the items should be synchronized through iCloud. Defaults to `false`.
    /// - Parameter attributes: Additional attributes to include in every query. Defaults to an empty dictionary.
    /// - Returns: A ``SimpleKeychain`` instance.
    public init(service: String = Bundle.main.bundleIdentifier!,
                accessGroup: String? = nil,
                accessibility: Accessibility = .afterFirstUnlock,
                accessControlFlags: SecAccessControlCreateFlags? = nil,
                synchronizable: Bool = false,
                attributes: [String: Any] = [:]) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.accessControlFlags = accessControlFlags
        self.isSynchronizable = synchronizable
        self.attributes = attributes
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
    /// Retrieves a `String` value from the Keychain.
    ///
    /// ```swift
    /// let value = try simpleKeychain.string(forKey: "your_key")
    /// ```
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
    /// ```swift
    /// let value = try simpleKeychain.data(forKey: "your_key")
    /// ```
    ///
    /// - Parameter key: Key of the Keychain item to retrieve.
    /// - Returns: The `Data` value.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func data(forKey key: String) throws -> Data {
        let query = self.getOneQuery(byKey: key)
        var result: AnyObject?
        try assertSuccess(forStatus: retrieve(query as CFDictionary, &result))

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
    /// ```swift
    /// try simpleKeychain.set("some string", forKey: "your_key")
    /// ```
    ///
    /// - Parameter string: Value to save in the Keychain.
    /// - Parameter key: Key for the Keychain item.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func set(_ string: String, forKey key: String) throws {
        return try self.set(Data(string.utf8), forKey: key)
    }

    /// Saves a `Data` value with the type `kSecClassGenericPassword` in the Keychain.
    ///
    /// ```swift
    /// try simpleKeychain.set(data, forKey: "your_key")
    /// ```
    ///
    /// - Parameter data: Value to save in the Keychain.
    /// - Parameter key: Key for the Keychain item.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func set(_ data: Data, forKey key: String) throws {
        let addItemQuery = self.setQuery(forKey: key, data: data)
        let addStatus = SecItemAdd(addItemQuery as CFDictionary, nil)

        if addStatus == SimpleKeychainError.duplicateItem.status {
            let updateQuery = self.baseQuery(withKey: key)
            let updateAttributes: [String: Any] = [kSecValueData as String: data]
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
    /// ```swift
    /// try simpleKeychain.deleteItem(forKey: "your_key")
    /// ```
    ///
    /// - Parameter key: Key of the Keychain item to delete..
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func deleteItem(forKey key: String) throws {
        let query = self.baseQuery(withKey: key)
        try assertSuccess(forStatus: remove(query as CFDictionary))
    }

    /// Deletes all items from the Keychain for the service and access group values.
    ///
    /// ```swift
    /// try simpleKeychain.deleteAll()
    /// ```
    ///
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func deleteAll() throws {
        var query = self.baseQuery()
        #if os(macOS)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        #endif
        let status = remove(query as CFDictionary)
        guard SimpleKeychainError.Code(rawValue: status) != SimpleKeychainError.Code.itemNotFound else { return }
        try assertSuccess(forStatus: status)
    }
}

// MARK: - Convenience methods

public extension SimpleKeychain {
    /// Checks if an item is stored in the Keychain.
    ///
    /// ```swift
    /// let isStored = try simpleKeychain.hasItem(forKey: "your_key")
    /// ```
    ///
    /// - Parameter key: Key of the Keychain item to check.
    /// - Returns: Whether the item is stored in the Keychain or not.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func hasItem(forKey key: String) throws -> Bool {
        let query = self.baseQuery(withKey: key)
        let status = retrieve(query as CFDictionary, nil)

        if status == SimpleKeychainError.itemNotFound.status {
            return false
        }

        try assertSuccess(forStatus: status)
        return true
    }

    /// Retrieves the keys of all the items stored in the Keychain for the service and access group values.
    ///
    /// ```swift
    /// let keys = try simpleKeychain.keys()
    /// ```
    ///
    /// - Returns: A `String` array containing the keys.
    /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
    func keys() throws -> [String] {
        let query = self.getAllQuery
        var keys: [String] = []
        var result: AnyObject?
        let status = retrieve(query as CFDictionary, &result)
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
        var query = self.attributes
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = self.service

        if let key = key {
            query[kSecAttrAccount as String] = key
        }
        if let data = data {
            query[kSecValueData as String] = data
        }
        if let accessGroup = self.accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        #if canImport(LocalAuthentication) && !os(tvOS)
        if let context = self.context {
            query[kSecUseAuthenticationContext as String] = context
        }
        #endif
        if self.isSynchronizable {
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue
        }

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

    func setQuery(forKey key: String, data: Data) -> [String: Any] {
        var query = self.baseQuery(withKey: key, data: data)

        if let flags = self.accessControlFlags,
           let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault, self.accessibility.rawValue, flags, nil) {
            query[kSecAttrAccessControl as String] = access
        } else {
            #if os(macOS)
            // See https://developer.apple.com/documentation/security/ksecattraccessible
            if self.isSynchronizable || query[kSecUseDataProtectionKeychain as String] as? Bool == true {
                query[kSecAttrAccessible as String] = self.accessibility.rawValue
            }
            #else
            query[kSecAttrAccessible as String] = self.accessibility.rawValue
            #endif
        }

        return query
    }
}
