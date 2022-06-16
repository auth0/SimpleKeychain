import Foundation
import Security
#if canImport(LocalAuthentication)
import LocalAuthentication
#endif

// ADDED -> A0SimpleKeychain was renamed to SimpleKeychain
// ADDED -> setTouchIDAuthenticationAllowableReuseDuration was removed
// ADDED -> useAccessControl was replaced with accessControlFlags
// ADDED -> deleteEntry(forKey) was renamed to deleteItem(forKey:)
// ADDED -> hasValueForKey was renamed to hasItem(forKey:)
// ADDED -> clearAll was renamed to deleteAll
// ADDED -> defaultAccessiblity is gone -> it's now in the initializer
// ADDED -> setString(forKey:) is now set(_:forKey:)
// ADDED -> setData(forKey:) is now set(_:forKey:)
// no more promptMessage parameter
// kSecUseAuthenticationUI no longer being added when using access control
// hasItem no longer returns false on any error, only on errSecItemNotFound

public struct SimpleKeychain {
    let service: String
    let accessGroup: String?
    let accessibility: Accessibility
    let accessControlFlags: SecAccessControlCreateFlags?

    #if canImport(LocalAuthentication)
    let context: LAContext

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
}

// MARK: - Accessibility

public extension SimpleKeychain {
    enum Accessibility: RawRepresentable {
        case whenUnlocked
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlock
        case afterFirstUnlockThisDeviceOnly
        case whenPasscodeSetThisDeviceOnly

        public var rawValue: CFString {
            switch self {
            case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
            case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
            case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
            }
        }

        public init(rawValue: CFString) {
            switch rawValue {
            case kSecAttrAccessibleWhenUnlocked: self = .whenUnlocked
            case kSecAttrAccessibleWhenUnlockedThisDeviceOnly: self = .whenUnlockedThisDeviceOnly
            case kSecAttrAccessibleAfterFirstUnlock: self = .afterFirstUnlock
            case kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly: self = .afterFirstUnlockThisDeviceOnly
            case kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly: self = .whenPasscodeSetThisDeviceOnly
            default: self = .afterFirstUnlock
            }
        }
    }
}

// MARK: - CRUD

public extension SimpleKeychain {
    func hasItem(forKey key: String) throws -> Bool {
        let query = self.baseQuery(withKey: key)
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecItemNotFound {
            return false
        }
        try assertSuccess(forStatus: status)
        return true
    }

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

    func string(forKey key: String) throws -> String {
        let data = try self.data(forKey: key)

        guard let result = String(data: data, encoding: .utf8) else {
            let message = "Unable to convert the retrieved item to a String value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        return result
    }

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

    func set(_ string: String, forKey key: String) throws {
        guard let data = string.data(using: .utf8) else {
            let message = "Unable to encode the string into a Data value"
            throw SimpleKeychainError(code: SimpleKeychainError.Code.unknown(message: message))
        }

        return try self.set(data, forKey: key)
    }

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

    func deleteItem(forKey key: String) throws {
        let query = self.baseQuery(withKey: key)
        try assertSuccess(forStatus: SecItemDelete(query as CFDictionary))
    }

    func deleteAll() throws {
        var query = self.baseQuery()
        #if os(macOS)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        #endif
        let status = SecItemDelete(query as CFDictionary)
        guard SimpleKeychainError.Code(rawValue: status) != SimpleKeychainError.Code.itemNotFound else { return }
        try assertSuccess(forStatus: status)
    }

    private func assertSuccess(forStatus status: OSStatus) throws {
        if status != errSecSuccess {
            throw SimpleKeychainError(code: SimpleKeychainError.Code(rawValue: status))
        }
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
