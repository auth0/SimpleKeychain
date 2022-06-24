import Foundation

/// Represents an error during a SimpleKeychain operation.
public struct SimpleKeychainError: LocalizedError, CustomDebugStringConvertible {
    enum Code: RawRepresentable, Equatable {
        case operationNotImplemented
        case invalidParameters
        case userCanceled
        case itemNotAvailable
        case authFailed
        case duplicateItem
        case itemNotFound
        case interactionNotAllowed
        case decodeFailed
        case other(status: OSStatus)
        case unknown(message: String)

        init(rawValue: OSStatus) {
            switch rawValue {
            case errSecUnimplemented: self = .operationNotImplemented
            case errSecParam: self = .invalidParameters
            case errSecUserCanceled: self = .userCanceled
            case errSecNotAvailable: self = .itemNotAvailable
            case errSecAuthFailed: self = .authFailed
            case errSecDuplicateItem: self = .duplicateItem
            case errSecItemNotFound: self = .itemNotFound
            case errSecInteractionNotAllowed: self = .interactionNotAllowed
            case errSecDecode: self = .decodeFailed
            default: self = .other(status: rawValue)
            }
        }

        var rawValue: OSStatus {
            switch self {
            case .operationNotImplemented: return errSecUnimplemented
            case .invalidParameters: return errSecParam
            case .userCanceled: return errSecUserCanceled
            case .itemNotAvailable: return errSecNotAvailable
            case .authFailed: return errSecAuthFailed
            case .duplicateItem: return errSecDuplicateItem
            case .itemNotFound: return errSecItemNotFound
            case .interactionNotAllowed: return errSecInteractionNotAllowed
            case .decodeFailed: return errSecDecode
            case let .other(status): return status
            case .unknown: return errSecSuccess // This is not a Keychain error
            }
        }
    }

    let code: Code

    init(code: Code) {
        self.code = code
    }

    /// The `OSStatus` of the Keychain operation.
    public var status: OSStatus {
        return self.code.rawValue
    }

    /// Description of the error.
    ///
    /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
    public var localizedDescription: String { return self.debugDescription }

    /// Description of the error.
    ///
    /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
    public var errorDescription: String? { return self.debugDescription }

    /// Description of the error.
    ///
    /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
    public var debugDescription: String {
        switch self.code {
        case .operationNotImplemented:
            return "errSecUnimplemented: A function or operation is not implemented."
        case .invalidParameters:
            return "errSecParam: One or more parameters passed to the function are not valid."
        case .userCanceled:
            return "errSecUserCanceled: User canceled the operation."
        case .itemNotAvailable:
            return "errSecNotAvailable: No trust results are available."
        case .authFailed:
            return "errSecAuthFailed: Authorization and/or authentication failed."
        case .duplicateItem:
            return "errSecDuplicateItem: The item already exists."
        case .itemNotFound:
            return "errSecItemNotFound: The item cannot be found."
        case .interactionNotAllowed:
            return "errSecInteractionNotAllowed: Interaction with the Security Server is not allowed."
        case .decodeFailed:
            return "errSecDecode: Unable to decode the provided data."
        case .other:
            return "Unspecified Keychain error: \(self.status)."
        case let .unknown(message):
            return "Unknown error: \(message)."
        }
    }

    // MARK: - Error Cases

    /// A function or operation is not implemented.
    /// See [errSecUnimplemented](https://developer.apple.com/documentation/security/errsecunimplemented).
    public static let operationNotImplemented: SimpleKeychainError = .init(code: .operationNotImplemented)

    /// One or more parameters passed to the function are not valid.
    /// See [errSecParam](https://developer.apple.com/documentation/security/errsecparam).
    public static let invalidParameters: SimpleKeychainError = .init(code: .invalidParameters)

    /// User canceled the operation.
    /// See [errSecUserCanceled](https://developer.apple.com/documentation/security/errsecusercanceled).
    public static let userCanceled: SimpleKeychainError = .init(code: .userCanceled)

    /// No trust results are available.
    /// See [errSecNotAvailable](https://developer.apple.com/documentation/security/errsecnotavailable).
    public static let itemNotAvailable: SimpleKeychainError = .init(code: .itemNotAvailable)

    /// Authorization and/or authentication failed.
    /// See [errSecAuthFailed](https://developer.apple.com/documentation/security/errsecauthfailed).
    public static let authFailed: SimpleKeychainError = .init(code: .authFailed)

    /// The item already exists.
    /// See [errSecDuplicateItem](https://developer.apple.com/documentation/security/errsecduplicateitem).
    public static let duplicateItem: SimpleKeychainError = .init(code: .duplicateItem)

    /// The item cannot be found.
    /// See [errSecItemNotFound](https://developer.apple.com/documentation/security/errsecitemnotfound).
    public static let itemNotFound: SimpleKeychainError = .init(code: .itemNotFound)

    /// Interaction with the Security Server is not allowed.
    /// See [errSecInteractionNotAllowed](https://developer.apple.com/documentation/security/errsecinteractionnotallowed).
    public static let interactionNotAllowed: SimpleKeychainError = .init(code: .interactionNotAllowed)

    /// Unable to decode the provided data.
    /// See [errSecDecode](https://developer.apple.com/documentation/security/errsecdecode).
    public static let decodeFailed: SimpleKeychainError = .init(code: .decodeFailed)

    /// Other Keychain error.
    /// The `OSStatus` of the Keychain operation can be accessed via the ``status`` property.
    public static let other: SimpleKeychainError = .init(code: .other(status: 0))

    /// Unknown error. This is not a Keychain error but a SimpleKeychain failure. For example, being unable to cast the retrieved item.
    public static let unknown: SimpleKeychainError = .init(code: .unknown(message: ""))
}

// MARK: - Equatable

extension SimpleKeychainError: Equatable {
    /// Conformance to `Equatable`.
    public static func == (lhs: SimpleKeychainError, rhs: SimpleKeychainError) -> Bool {
        return lhs.code == rhs.code && lhs.localizedDescription == rhs.localizedDescription
    }
}

// MARK: - Pattern Matching Operator

public extension SimpleKeychainError {
    /// Matches `SimpleKeychainError` values in a switch statement.
    static func ~= (lhs: SimpleKeychainError, rhs: SimpleKeychainError) -> Bool {
        return lhs.code == rhs.code
    }

    /// Matches `Error` values in a switch statement.
    static func ~= (lhs: SimpleKeychainError, rhs: Error) -> Bool {
        guard let rhs = rhs as? SimpleKeychainError else { return false }
        return lhs.code == rhs.code
    }
}
