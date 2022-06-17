import Security

/// Represents the accessibility types of Keychain items. It's a mirror of `kSecAttrAccessible` values.
public enum Accessibility: RawRepresentable {

    /// The data in the Keychain item can be accessed only while the device is unlocked by the user.
    /// See [kSecAttrAccessibleWhenUnlocked](https://developer.apple.com/documentation/security/ksecattraccessiblewhenunlocked).
    case whenUnlocked

    /// The data in the Keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
    /// See [kSecAttrAccessibleWhenUnlockedThisDeviceOnly](https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly).
    case whenUnlockedThisDeviceOnly

    /// The data in the Keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
    /// See [kSecAttrAccessibleAfterFirstUnlock](https://developer.apple.com/documentation/security/ksecattraccessibleafterfirstunlock).
    case afterFirstUnlock

    /// The data in the Keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
    /// See [kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly](https://developer.apple.com/documentation/security/ksecattraccessibleafterfirstunlockthisdeviceonly).
    case afterFirstUnlockThisDeviceOnly

    /// The data in the Keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
    /// See [kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly](https://developer.apple.com/documentation/security/ksecattraccessiblewhenpasscodesetthisdeviceonly).
    case whenPasscodeSetThisDeviceOnly

    /// Maps a `kSecAttrAccessible` value to an accessibility type.
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

    /// The `kSecAttrAccessible` value of a given accessibility type.
    public var rawValue: CFString {
        switch self {
        case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        }
    }
}
