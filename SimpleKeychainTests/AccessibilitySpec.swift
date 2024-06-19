import Security
import XCTest
import SimpleKeychain

class AccessibilitySpec: XCTestCase {
    
    // Test from raw value to case
    func testKSecAttrAccessibleWhenUnlocked() {
        let sut = Accessibility(rawValue: kSecAttrAccessibleWhenUnlocked)
        XCTAssertEqual(sut, Accessibility.whenUnlocked)
    }
    
    func testKSecAttrAccessibleWhenUnlockedThisDeviceOnly() {
        let sut = Accessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        XCTAssertEqual(sut, Accessibility.whenUnlockedThisDeviceOnly)
    }
    
    func testKSecAttrAccessibleAfterFirstUnlock() {
        let sut = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock)
        XCTAssertEqual(sut, Accessibility.afterFirstUnlock)
    }
    
    func testKSecAttrAccessibleAfterFirstUnlockThisDeviceOnly() {
        let sut = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        XCTAssertEqual(sut, Accessibility.afterFirstUnlockThisDeviceOnly)
    }
    
    func testKSecAttrAccessibleWhenPasscodeSetThisDeviceOnly() {
        let sut = Accessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        XCTAssertEqual(sut, Accessibility.whenPasscodeSetThisDeviceOnly)
    }
    
    func testUnknownValues() {
        let sut = Accessibility(rawValue: "foo" as CFString)
        XCTAssertEqual(sut, Accessibility.afterFirstUnlock)
    }
    
    // Test from case to raw value
    func testWhenUnlocked() {
        let sut = Accessibility.whenUnlocked.rawValue as String
        XCTAssertEqual(sut, kSecAttrAccessibleWhenUnlocked as String)
    }
    
    func testWhenUnlockedThisDeviceOnly() {
        let sut = Accessibility.whenUnlockedThisDeviceOnly.rawValue as String
        XCTAssertEqual(sut, kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
    }
    
    func testAfterFirstUnlock() {
        let sut = Accessibility.afterFirstUnlock.rawValue as String
        XCTAssertEqual(sut, kSecAttrAccessibleAfterFirstUnlock as String)
    }
    
    func testAfterFirstUnlockThisDeviceOnly() {
        let sut = Accessibility.afterFirstUnlockThisDeviceOnly.rawValue as String
        XCTAssertEqual(sut, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
    }
    
    func testWhenPasscodeSetThisDeviceOnly() {
        let sut = Accessibility.whenPasscodeSetThisDeviceOnly.rawValue as String
        XCTAssertEqual(sut, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
    }
}
