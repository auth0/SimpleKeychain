import Security
import Nimble
import Quick
import SimpleKeychain

class AccessibilitySpec: QuickSpec {
    override func spec() {
        describe("raw representable") {
            context("from raw value to case") {
                it("should map kSecAttrAccessibleWhenUnlocked") {
                    let sut = SKAccessibility(rawValue: kSecAttrAccessibleWhenUnlocked)
                    expect(sut) == SKAccessibility.whenUnlocked
                }

                it("should map kSecAttrAccessibleWhenUnlockedThisDeviceOnly") {
                    let sut = SKAccessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
                    expect(sut) == SKAccessibility.whenUnlockedThisDeviceOnly
                }

                it("should map kSecAttrAccessibleAfterFirstUnlock") {
                    let sut = SKAccessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock)
                    expect(sut) == SKAccessibility.afterFirstUnlock
                }

                it("should map kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly") {
                    let sut = SKAccessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
                    expect(sut) == SKAccessibility.afterFirstUnlockThisDeviceOnly
                }

                it("should map kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly") {
                    let sut = SKAccessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
                    expect(sut) == SKAccessibility.whenPasscodeSetThisDeviceOnly
                }

                it("should map unknown values") {
                    let sut = SKAccessibility(rawValue: "foo" as CFString)
                    expect(sut) == SKAccessibility.afterFirstUnlock
                }
            }

            context("from case to raw value") {
                it("should map whenUnlocked") {
                    let sut = SKAccessibility.whenUnlocked.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenUnlocked as String)
                }

                it("should map whenUnlockedThisDeviceOnly") {
                    let sut = SKAccessibility.whenUnlockedThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
                }

                it("should map afterFirstUnlock") {
                    let sut = SKAccessibility.afterFirstUnlock.rawValue as String
                    expect(sut) == (kSecAttrAccessibleAfterFirstUnlock as String)
                }

                it("should map afterFirstUnlockThisDeviceOnly") {
                    let sut = SKAccessibility.afterFirstUnlockThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
                }

                it("should map whenPasscodeSetThisDeviceOnly") {
                    let sut = SKAccessibility.whenPasscodeSetThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
                }

                it("should map whenPasscodeSetThisDeviceOnly") {
                    let sut = SKAccessibility.whenPasscodeSetThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
                }
            }
        }
    }
}
