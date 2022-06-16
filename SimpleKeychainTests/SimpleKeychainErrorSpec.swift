import Security
import Nimble
import Quick

@testable import SimpleKeychain

class SimpleKeychainErrorSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("should initialize with code") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error.code) == SimpleKeychainError.Code.operationNotImplemented
            }
        }

        describe("operators") {
            it("should be equal by code") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error) == SimpleKeychainError.operationNotImplemented
            }

            it("should not be equal to an error with a different code") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error) != SimpleKeychainError.itemNotAvailable
            }

            it("should not be equal to an error with a different description") {
                let error = SimpleKeychainError(code: .unknown(message: "foo"))
                expect(error) != SimpleKeychainError(code: .unknown(message: "bar"))
            }

            it("should pattern match by code") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error ~= SimpleKeychainError.operationNotImplemented) == true
            }

            it("should not pattern match by code with a different error") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error ~= SimpleKeychainError.itemNotAvailable) == false
            }

            it("should pattern match by code with a generic error") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error ~= (SimpleKeychainError.operationNotImplemented) as Error) == true
            }

            it("should not pattern match by code with a different generic error") {
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error ~= (SimpleKeychainError.itemNotAvailable) as Error) == false
            }
        }

        describe("debug description") {
            it("should match the localized message") {
                let error = SimpleKeychainError(code: .itemNotAvailable)
                expect(error.debugDescription) == SimpleKeychainError.itemNotAvailable.debugDescription
            }

            it("should match the error description") {
                let error = SimpleKeychainError(code: .itemNotAvailable)
                expect(error.debugDescription) == SimpleKeychainError.itemNotAvailable.errorDescription
            }
        }

        describe("error message") {
            it("should return message for operation not implemented") {
                let message = "errSecUnimplemented: A function or operation is not implemented."
                let error = SimpleKeychainError(code: .operationNotImplemented)
                expect(error.localizedDescription) == message
            }

            it("should return message for invalid parameters") {
                let message = "errSecParam: One or more parameters passed to the function are not valid."
                let error = SimpleKeychainError(code: .invalidParameters)
                expect(error.localizedDescription) == message
            }

            it("should return message for user canceled") {
                let message = "errSecUserCanceled: User canceled the operation."
                let error = SimpleKeychainError(code: .userCanceled)
                expect(error.localizedDescription) == message
            }

            it("should return message for item not available") {
                let message = "errSecNotAvailable: No trust results are available."
                let error = SimpleKeychainError(code: .itemNotAvailable)
                expect(error.localizedDescription) == message
            }

            it("should return message for auth failed") {
                let message = "errSecAuthFailed: Authorization and/or authentication failed."
                let error = SimpleKeychainError(code: .authFailed)
                expect(error.localizedDescription) == message
            }

            it("should return message for duplicate item") {
                let message = "errSecDuplicateItem: The item already exists."
                let error = SimpleKeychainError(code: .duplicateItem)
                expect(error.localizedDescription) == message
            }

            it("should return message for item not found") {
                let message = "errSecItemNotFound: The item cannot be found."
                let error = SimpleKeychainError(code: .itemNotFound)
                expect(error.localizedDescription) == message
            }

            it("should return message for interaction not allowed") {
                let message = "errSecInteractionNotAllowed: Interaction with the Security Server is not allowed."
                let error = SimpleKeychainError(code: .interactionNotAllowed)
                expect(error.localizedDescription) == message
            }

            it("should return message for decode failed") {
                let message = "errSecDecode: Unable to decode the provided data."
                let error = SimpleKeychainError(code: .decodeFailed)
                expect(error.localizedDescription) == message
            }

            it("should return message for other error") {
                let status: OSStatus = 123
                let message = "Unspecified Keychain error: \(status)."
                let error = SimpleKeychainError(code: .other(status: status))
                expect(error.localizedDescription) == message
            }

            it("should return message for unknown error") {
                let description = "foo"
                let message = "Unknown error: \(description)."
                let error = SimpleKeychainError(code: .unknown(message: description))
                expect(error.localizedDescription) == message
            }
        }
    }
}
