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
  
  @objc public convenience init(service: String) {
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
  
  // Store items - Objective-C style error handling
  @objc public func setString(_ string: String, forKey key: String, error: NSErrorPointer) -> Bool {
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
  
  @objc public func setData(_ data: Data, forKey key: String, error: NSErrorPointer) -> Bool {
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
  
  // Retrieve items
  @objc public func string(forKey key: String, error: NSErrorPointer) -> String? {
    do {
      return try simpleKeychain.string(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return nil
    }
  }
  
  @objc public func data(forKey key: String, error: NSErrorPointer) -> Data? {
    do {
      return try simpleKeychain.data(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return nil
    }
  }
  
  // Delete items
  @objc public func deleteItem(forKey key: String, error: NSErrorPointer) -> Bool {
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
  
  @objc public func deleteAll(error: NSErrorPointer) -> Bool {
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
  
  // Check if an item exists
  @objc public func hasItem(forKey key: String, error: NSErrorPointer) -> Bool {
    do {
      return try simpleKeychain.hasItem(forKey: key)
    } catch let err {
      if let error = error {
        error.pointee = err as NSError
      }
      return false
    }
  }
  
  // Get all keys
  @objc public func keys(error: NSErrorPointer) -> [String]? {
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
