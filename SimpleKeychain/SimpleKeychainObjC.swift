import Foundation
#if canImport(LocalAuthentication) && !os(tvOS)
import LocalAuthentication
public typealias SimpleKeychainContext = LAContext
#else
// Dummy context type for platforms without LAContext
public typealias SimpleKeychainContext = NSObject
#endif

@objc public enum SimpleKeychainAccessibility: Int {
  case whenUnlocked
  case whenUnlockedThisDeviceOnly
  case afterFirstUnlock
  case afterFirstUnlockThisDeviceOnly
  case whenPasscodeSetThisDeviceOnly
}

/// A 'Simple' Obj-C wrapper around `SimpleKeychain`
@objcMembers
public class SimpleKeychainObjC: NSObject {
  private let simpleKeychain: SimpleKeychain
  
  /// Initializes a ``SimpleKeychain`` instance.
  ///
  /// - Parameters:
  ///   - service: Name of the service under which to save items. Defaults to the bundle identifier.
  ///   - accessGroup: access group for sharing Keychain items. Defaults to `nil`.
  ///   - accessibility: ``Accessibility`` type the stored items will have. Defaults to ``Accessibility/afterFirstUnlock``.
  ///   - accessControlFlags: Access control conditions for `kSecAttrAccessControl`.  Defaults to `nil`.
  ///   - context: `LAContext` used to access Keychain items. Defaults to `nil`.
  ///   - synchronizable: Whether the items should be synchronized through iCloud. Defaults to `false`.
  ///   - attributes: Additional attributes to include in every query. Defaults to an empty dictionary.
  @objc public init(service: String,
                    accessGroup: String?,
                    accessibility: SimpleKeychainAccessibility,
                    accessControlFlags: NSNumber?,
                    context: SimpleKeychainContext?,
                    synchronizable: Bool,
                    attributes: [String: Any]) {
    
    // Convert ObjC enum to Swift enum
    let swiftAccessibility: Accessibility
    switch accessibility {
      case .whenUnlocked:
        swiftAccessibility = .whenUnlocked
      case .whenUnlockedThisDeviceOnly:
        swiftAccessibility = .whenUnlockedThisDeviceOnly
      case .afterFirstUnlock:
        swiftAccessibility = .afterFirstUnlock
      case .afterFirstUnlockThisDeviceOnly:
        swiftAccessibility = .afterFirstUnlockThisDeviceOnly
      case .whenPasscodeSetThisDeviceOnly:
        swiftAccessibility = .whenPasscodeSetThisDeviceOnly
    }
    
    // Convert NSNumber to SecAccessControlCreateFlags if provided
    let flags: SecAccessControlCreateFlags?
    if let accessControlFlags = accessControlFlags {
      flags = SecAccessControlCreateFlags(rawValue: accessControlFlags.uintValue)
    } else {
      flags = nil
    }
    
    // Initialize the underlying Swift SimpleKeychain
#if canImport(LocalAuthentication) && !os(tvOS)
    // On platforms with LA support, pass through the context
    self.simpleKeychain = SimpleKeychain(
      service: service,
      accessGroup: accessGroup,
      accessibility: swiftAccessibility,
      accessControlFlags: flags,
      context: context,
      synchronizable: synchronizable,
      attributes: attributes
    )
#else
    // On platforms without LA support, don't pass a context
    self.simpleKeychain = SimpleKeychain(
      service: service,
      accessGroup: accessGroup,
      accessibility: swiftAccessibility,
      accessControlFlags: flags,
      synchronizable: synchronizable,
      attributes: attributes
    )
#endif
    
    super.init()
  }
  
  /// Convenience initializer that uses the defaults
  @objc public convenience init(service: String = Bundle.main.bundleIdentifier!) {
    self.init(
      service: service,
      accessGroup: nil,
      accessibility: .afterFirstUnlock,
      accessControlFlags: nil,
      context: nil,
      synchronizable: false,
      attributes: [:]
    )
  }
}

// MARK: - Retrieve items

public extension SimpleKeychainObjC {
  /// Retrieves a `String` value from the Keychain.
  /// 
  /// ```swift
  /// var error: NSError?
  /// let value = try simpleKeychain.string(forKey: "your_key", error: &error)
  /// ```
  /// 
  /// - Parameter key: Key of the Keychain item to retrieve.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: The `String` value.
  @objc func string(forKey key: String, error: NSErrorPointer) -> String? {
    do {
      return try simpleKeychain.string(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return nil
    }
  }
  
  /// Retrieves a `Data` value from the Keychain.
  /// 
  /// ```swift
  /// var error: NSError?
  /// let value = try simpleKeychain.data(forKey: "your_key", error: &error)
  /// ```
  /// 
  /// - Parameter key: Key of the Keychain item to retrieve.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: The `Data` value.
  @objc func data(forKey key: String, error: NSErrorPointer) -> Data? {
    do {
      return try simpleKeychain.data(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return nil
    }
  }
}

// MARK: - Store items

public extension SimpleKeychainObjC {
  /// Saves a `String` value with the type `kSecClassGenericPassword` in the Keychain.
  ///
  /// ```swift
  /// var error: NSError?
  /// try simpleKeychain.setString("some string", forKey: "your_key", error: &error)
  /// ```
  ///
  /// - Parameter string: Value to save in the Keychain.
  /// - Parameter key: Key for the Keychain item.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: `True` on a successful save. When `False`, check error.
  @objc func setString(_ string: String, forKey key: String, error: NSErrorPointer) -> Bool {
    do {
      try simpleKeychain.set(string, forKey: key)
      return true
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
  
  /// Saves a `Data` value with the type `kSecClassGenericPassword` in the Keychain.
  /// 
  /// ```swift
  /// var error: NSError?
  /// try simpleKeychain.set(data, forKey: "your_key", error: &error)
  /// ```
  /// 
  /// - Parameter data: Value to save in the Keychain.
  /// - Parameter key: Key for the Keychain item.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: `True` on a successful save. When `False`, check error.
  @objc func setData(_ data: Data, forKey key: String, error: NSErrorPointer) -> Bool {
    do {
      try simpleKeychain.set(data, forKey: key)
      return true
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
}

// MARK: - Delete items

public extension SimpleKeychainObjC {
  
  /// Deletes an item from the Keychain.
  /// 
  /// ```swift
  /// var error: NSError?
  /// try simpleKeychain.deleteItem(forKey: "your_key", error: &error)
  /// ```
  /// 
  /// - Parameter key: Key of the Keychain item to delete..
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: `True` on a successful save. When `False`, check error.
  @objc func deleteItem(forKey key: String, error: NSErrorPointer) -> Bool {
    do {
      try simpleKeychain.deleteItem(forKey: key)
      return true
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
  
  /// Deletes all items from the Keychain for the service and access group values.
  /// 
  /// ```swift
  /// var error: NSError?
  /// try simpleKeychain.deleteAll(error: &error)
  /// ```
  /// 
  /// - Throws: A ``SimpleKeychainError`` when the SimpleKeychain operation fails.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: `True` on a successful save. When `False`, check error.
  @objc func deleteAll(error: NSErrorPointer) -> Bool {
    do {
      try simpleKeychain.deleteAll()
      return true
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
}

// MARK: - Convenience methods

public extension SimpleKeychainObjC {
  /// Checks if an item is stored in the Keychain.
  /// 
  /// ```swift
  /// var error: NSError?
  /// let isStored = try simpleKeychain.hasItem(forKey: "your_key", error: &error)
  /// ```
  /// 
  /// - Parameter key: Key of the Keychain item to check.
  /// - Parameter error: On failure, will be set to the error that occurred.
  /// - Returns: Whether the item is stored in the Keychain or not.. When `False`, check error.
  @objc func hasItem(forKey key: String, error: NSErrorPointer) -> Bool {
    do {
      return try simpleKeychain.hasItem(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
  
  /// Retrieves the keys of all the items stored in the Keychain for the service and access group values.
  /// 
  /// ```swift
  /// var error: NSError?
  /// let keys = try simpleKeychain.keys(error: &error)
  /// ```
  /// 
  /// - Returns: A `String` array containing the keys.
  /// - Parameter error: On failure, will be set to the error that occurred.
  @objc func keys(error: NSErrorPointer) -> [String]? {
    do {
      return try simpleKeychain.keys()
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return nil
    }
  }
}
