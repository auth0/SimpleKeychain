import Foundation
import Security
import Nimble
import Quick

@testable import SimpleKeychain

class SimpleKeychainErrorSpec: QuickSpec {
    override class func spec() {
        describe("init") {
            it("should initialize with code") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut.code) == SimpleKeychainError.Code.operationNotImplemented
            }
        }

        describe("operators") {
            it("should be equal by code") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut) == SimpleKeychainError.operationNotImplemented
            }

            it("should not be equal to an error with a different code") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut) != SimpleKeychainError.itemNotAvailable
            }

            it("should not be equal to an error with a different description") {
                let sut = SimpleKeychainError(code: .unknown(message: "foo"))
                expect(sut) != SimpleKeychainError(code: .unknown(message: "bar"))
            }

            it("should pattern match by code") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut ~= SimpleKeychainError.operationNotImplemented) == true
            }

            it("should not pattern match by code with a different error") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut ~= SimpleKeychainError.itemNotAvailable) == false
            }

            it("should pattern match by code with a generic error") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut ~= (SimpleKeychainError.operationNotImplemented) as Error) == true
            }

            it("should not pattern match by code with a different generic error") {
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut ~= NSError()) == false
            }
        }

        describe("debug description") {
            it("should match the localized message") {
                let sut = SimpleKeychainError(code: .itemNotAvailable)
                expect(sut.debugDescription) == SimpleKeychainError.itemNotAvailable.debugDescription
            }

            it("should match the error description") {
                let sut = SimpleKeychainError(code: .itemNotAvailable)
                expect(sut.debugDescription) == SimpleKeychainError.itemNotAvailable.errorDescription
            }
        }

        describe("error message") {
            it("should return message for operation not implemented") {
                let message = "errSecUnimplemented: A function or operation is not implemented."
                let sut = SimpleKeychainError(code: .operationNotImplemented)
                expect(sut.localizedDescription) == message
            }

            it("should return message for invalid parameters") {
                let message = "errSecParam: One or more parameters passed to the function are not valid."
                let sut = SimpleKeychainError(code: .invalidParameters)
                expect(sut.localizedDescription) == message
            }

            it("should return message for user canceled") {
                let message = "errSecUserCanceled: User canceled the operation."
                let sut = SimpleKeychainError(code: .userCanceled)
                expect(sut.localizedDescription) == message
            }

            it("should return message for item not available") {
                let message = "errSecNotAvailable: No trust results are available."
                let sut = SimpleKeychainError(code: .itemNotAvailable)
                expect(sut.localizedDescription) == message
            }

            it("should return message for auth failed") {
                let message = "errSecAuthFailed: Authorization and/or authentication failed."
                let sut = SimpleKeychainError(code: .authFailed)
                expect(sut.localizedDescription) == message
            }

            it("should return message for duplicate item") {
                let message = "errSecDuplicateItem: The item already exists."
                let sut = SimpleKeychainError(code: .duplicateItem)
                expect(sut.localizedDescription) == message
            }

            it("should return message for item not found") {
                let message = "errSecItemNotFound: The item cannot be found."
                let sut = SimpleKeychainError(code: .itemNotFound)
                expect(sut.localizedDescription) == message
            }

            it("should return message for interaction not allowed") {
                let message = "errSecInteractionNotAllowed: Interaction with the Security Server is not allowed."
                let sut = SimpleKeychainError(code: .interactionNotAllowed)
                expect(sut.localizedDescription) == message
            }

            it("should return message for decode failed") {
                let message = "errSecDecode: Unable to decode the provided data."
                let sut = SimpleKeychainError(code: .decodeFailed)
                expect(sut.localizedDescription) == message
            }

            it("should return message for other error") {
                let status: OSStatus = 123
                let message = "Unspecified Keychain error: \(status)."
                let sut = SimpleKeychainError(code: .other(status: status))
                expect(sut.localizedDescription) == message
            }

            it("should return message for unknown error") {
                let description = "foo"
                let message = "Unknown error: \(description)."
                let sut = SimpleKeychainError(code: .unknown(message: description))
                expect(sut.localizedDescription) == message
            }
        }
 
        describe("code") {
            context("from status to code") {
                it("should map errSecUnimplemented") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecUnimplemented)
                    expect(sut) == SimpleKeychainError.operationNotImplemented.code
                }

                it("should map errSecParam") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecParam)
                    expect(sut) == SimpleKeychainError.invalidParameters.code
                }

                it("should map errSecUserCanceled") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecUserCanceled)
                    expect(sut) == SimpleKeychainError.userCanceled.code
                }

                it("should map errSecNotAvailable") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecNotAvailable)
                    expect(sut) == SimpleKeychainError.itemNotAvailable.code
                }

                it("should map errSecAuthFailed") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecAuthFailed)
                    expect(sut) == SimpleKeychainError.authFailed.code
                }

                it("should map errSecDuplicateItem") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecDuplicateItem)
                    expect(sut) == SimpleKeychainError.duplicateItem.code
                }

                it("should map errSecItemNotFound") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecItemNotFound)
                    expect(sut) == SimpleKeychainError.itemNotFound.code
                }

                it("should map errSecInteractionNotAllowed") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecInteractionNotAllowed)
                    expect(sut) == SimpleKeychainError.interactionNotAllowed.code
                }

                it("should map errSecDecode") {
                    let sut = SimpleKeychainError.Code(rawValue: errSecDecode)
                    expect(sut) == SimpleKeychainError.decodeFailed.code
                }

                it("should map other status value") {
                    let status: OSStatus = 1234
                    let sut = SimpleKeychainError.Code(rawValue: status)
                    expect(sut.rawValue) == status
                }
            }

            context("from code to status") {
                it("should map operationNotImplemented") {
                    expect(SimpleKeychainError.operationNotImplemented.code.rawValue) == errSecUnimplemented
                }

                it("should map invalidParameters") {
                    expect(SimpleKeychainError.invalidParameters.code.rawValue) == errSecParam
                }

                it("should map userCanceled") {
                    expect(SimpleKeychainError.userCanceled.code.rawValue) == errSecUserCanceled
                }

                it("should map itemNotAvailable") {
                    expect(SimpleKeychainError.itemNotAvailable.code.rawValue) == errSecNotAvailable
                }

                it("should map authFailed") {
                    expect(SimpleKeychainError.authFailed.code.rawValue) == errSecAuthFailed
                }

                it("should map duplicateItem") {
                    expect(SimpleKeychainError.duplicateItem.code.rawValue) == errSecDuplicateItem
                }

                it("should map interactionNotAllowed") {
                    expect(SimpleKeychainError.interactionNotAllowed.code.rawValue) == errSecInteractionNotAllowed
                }

                it("should map decodeFailed") {
                    expect(SimpleKeychainError.decodeFailed.code.rawValue) == errSecDecode
                }

                it("should map other") {
                    let status: OSStatus = 1234
                    expect(SimpleKeychainError(code: .other(status: status)).status ) == status
                }

                it("should map unknown") {
                    expect(SimpleKeychainError.unknown.code.rawValue) == errSecSuccess
                }
            }
        }
    }
}
