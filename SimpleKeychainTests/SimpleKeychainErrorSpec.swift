import Foundation
import Security
import XCTest

@testable import SimpleKeychain

class SimpleKeychainErrorSpec: XCTestCase {
    func testInit() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertEqual(sut.code, SimpleKeychainError.Code.operationNotImplemented)
    }
    
    func testOperators_shouldBeEqualByCode() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertEqual(sut, SimpleKeychainError.operationNotImplemented)
    }
    
    func testOperators_shouldNotBeEqualToErrorWithDifferentCode() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertNotEqual(sut, SimpleKeychainError.itemNotAvailable)
    }
    
    func testOperators_shouldNotBeEqualToErrorWithDifferentDescription() {
        let sut = SimpleKeychainError(code: .unknown(message: "foo"))
        XCTAssertNotEqual(sut, SimpleKeychainError(code: .unknown(message: "bar")))
    }
    
    func testOperators_shouldPatternMatchByCode() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertTrue(sut ~= SimpleKeychainError.operationNotImplemented)
    }
    
    func testOperators_shouldNotPatternMatchByCodeWithDifferentError() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertFalse(sut ~= SimpleKeychainError.itemNotAvailable)
    }
    
    func testOperators_shouldPatternMatchByCodeWithGenericError() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertTrue(sut ~= (SimpleKeychainError.operationNotImplemented) as Error)
    }
    
    func testOperators_shouldNotPatternMatchByCodeWithDifferentGenericError() {
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertFalse(sut ~= NSError())
    }
    
    func testDebugDescription_shouldMatchLocalizedMessage() {
        let sut = SimpleKeychainError(code: .itemNotAvailable)
        XCTAssertEqual(sut.debugDescription, SimpleKeychainError.itemNotAvailable.debugDescription)
    }
    
    func testDebugDescription_shouldMatchErrorDescription() {
        let sut = SimpleKeychainError(code: .itemNotAvailable)
        XCTAssertEqual(sut.debugDescription, SimpleKeychainError.itemNotAvailable.errorDescription)
    }
    
    func testErrorMessage_shouldReturnMessageForOperationNotImplemented() {
        let message = "errSecUnimplemented: A function or operation is not implemented."
        let sut = SimpleKeychainError(code: .operationNotImplemented)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForInvalidParameters() {
        let message = "errSecParam: One or more parameters passed to the function are not valid."
        let sut = SimpleKeychainError(code: .invalidParameters)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForUserCanceled() {
        let message = "errSecUserCanceled: User canceled the operation."
        let sut = SimpleKeychainError(code: .userCanceled)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForItemNotAvailable() {
        let message = "errSecNotAvailable: No trust results are available."
        let sut = SimpleKeychainError(code: .itemNotAvailable)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForAuthFailed() {
        let message = "errSecAuthFailed: Authorization and/or authentication failed."
        let sut = SimpleKeychainError(code: .authFailed)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForDuplicateItem() {
        let message = "errSecDuplicateItem: The item already exists."
        let sut = SimpleKeychainError(code: .duplicateItem)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForItemNotFound() {
        let message = "errSecItemNotFound: The item cannot be found."
        let sut = SimpleKeychainError(code: .itemNotFound)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForInteractionNotAllowed() {
        let message = "errSecInteractionNotAllowed: Interaction with the Security Server is not allowed."
        let sut = SimpleKeychainError(code: .interactionNotAllowed)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForDecodeFailed() {
        let message = "errSecDecode: Unable to decode the provided data."
        let sut = SimpleKeychainError(code: .decodeFailed)
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForOtherError() {
        let status: OSStatus = 123
        let message = "Unspecified Keychain error: \(status)."
        let sut = SimpleKeychainError(code: .other(status: status))
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testErrorMessage_shouldReturnMessageForUnknownError() {
        let description = "foo"
        let message = "Unknown error: \(description)."
        let sut = SimpleKeychainError(code: .unknown(message: description))
        XCTAssertEqual(sut.localizedDescription, message)
    }
    
    func testMapErrSecUnimplemented() {
        let sut = SimpleKeychainError.Code(rawValue: errSecUnimplemented)
        XCTAssertEqual(sut, SimpleKeychainError.operationNotImplemented.code)
    }
    
    func testMapErrSecParam() {
        let sut = SimpleKeychainError.Code(rawValue: errSecParam)
        XCTAssertEqual(sut, SimpleKeychainError.invalidParameters.code)
    }
    
    func testMapErrSecUserCanceled() {
        let sut = SimpleKeychainError.Code(rawValue: errSecUserCanceled)
        XCTAssertEqual(sut, SimpleKeychainError.userCanceled.code)
    }
    
    func testMapErrSecNotAvailable() {
        let sut = SimpleKeychainError.Code(rawValue: errSecNotAvailable)
        XCTAssertEqual(sut, SimpleKeychainError.itemNotAvailable.code)
    }
    
    func testMapErrSecAuthFailed() {
        let sut = SimpleKeychainError.Code(rawValue: errSecAuthFailed)
        XCTAssertEqual(sut, SimpleKeychainError.authFailed.code)
    }
    
    func testMapErrSecDuplicateItem() {
        let sut = SimpleKeychainError.Code(rawValue: errSecDuplicateItem)
        XCTAssertEqual(sut, SimpleKeychainError.duplicateItem.code)
    }
    
    func testMapErrSecItemNotFound() {
        let sut = SimpleKeychainError.Code(rawValue: errSecItemNotFound)
        XCTAssertEqual(sut, SimpleKeychainError.itemNotFound.code)
    }
    
    func testMapErrSecInteractionNotAllowed() {
        let sut = SimpleKeychainError.Code(rawValue: errSecInteractionNotAllowed)
        XCTAssertEqual(sut, SimpleKeychainError.interactionNotAllowed.code)
    }
    
    func testMapErrSecDecode() {
        let sut = SimpleKeychainError.Code(rawValue: errSecDecode)
        XCTAssertEqual(sut, SimpleKeychainError.decodeFailed.code)
    }
    
    func testMapOtherStatusValue() {
        let status: OSStatus = 1234
        let sut = SimpleKeychainError.Code(rawValue: status)
        XCTAssertEqual(sut.rawValue, status)
    }
    
    func testMapOperationNotImplemented() {
        XCTAssertEqual(SimpleKeychainError.operationNotImplemented.code.rawValue, errSecUnimplemented)
    }
    
    func testMapInvalidParameters() {
        XCTAssertEqual(SimpleKeychainError.invalidParameters.code.rawValue, errSecParam)
    }
    
    func testMapUserCanceled() {
        XCTAssertEqual(SimpleKeychainError.userCanceled.code.rawValue, errSecUserCanceled)
    }
    
    func testMapItemNotAvailable() {
        XCTAssertEqual(SimpleKeychainError.itemNotAvailable.code.rawValue, errSecNotAvailable)
    }
    
    func testMapAuthFailed() {
        XCTAssertEqual(SimpleKeychainError.authFailed.code.rawValue, errSecAuthFailed)
    }
    
    func testMapDuplicateItem() {
        XCTAssertEqual(SimpleKeychainError.duplicateItem.code.rawValue, errSecDuplicateItem)
    }
    
    func testMapInteractionNotAllowed() {
        XCTAssertEqual(SimpleKeychainError.interactionNotAllowed.code.rawValue, errSecInteractionNotAllowed)
    }
    
    func testMapDecodeFailed() {
        XCTAssertEqual(SimpleKeychainError.decodeFailed.code.rawValue, errSecDecode)
    }
    
    func testMapOther() {
        let status: OSStatus = 1234
        XCTAssertEqual(SimpleKeychainError(code: .other(status: status)).status, status)
    }
    
    func testMapUnknown() {
        XCTAssertEqual(SimpleKeychainError.unknown.code.rawValue, errSecSuccess)
    }
}
