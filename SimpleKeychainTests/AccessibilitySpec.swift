import Security
import Nimble
import Quick
import SimpleKeychain

class AccessibilitySpec: QuickSpec {
    override class func spec() {
        describe("raw representable") {
            context("from raw value to case") {
                it("should map kSecAttrAccessibleWhenUnlocked") {
                    let sut = Accessibility(rawValue: kSecAttrAccessibleWhenUnlocked)
                    expect(sut) == Accessibility.whenUnlocked
                }

                it("should map kSecAttrAccessibleWhenUnlockedThisDeviceOnly") {
                    let sut = Accessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
                    expect(sut) == Accessibility.whenUnlockedThisDeviceOnly
                }

                it("should map kSecAttrAccessibleAfterFirstUnlock") {
                    let sut = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock)
                    expect(sut) == Accessibility.afterFirstUnlock
                }

                it("should map kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly") {
                    let sut = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
                    expect(sut) == Accessibility.afterFirstUnlockThisDeviceOnly
                }

                it("should map kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly") {
                    let sut = Accessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
                    expect(sut) == Accessibility.whenPasscodeSetThisDeviceOnly
                }

                it("should map unknown values") {
                    let sut = Accessibility(rawValue: "foo" as CFString)
                    expect(sut) == Accessibility.afterFirstUnlock
                }
            }

            context("from case to raw value") {
                it("should map whenUnlocked") {
                    let sut = Accessibility.whenUnlocked.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenUnlocked as String)
                }

                it("should map whenUnlockedThisDeviceOnly") {
                    let sut = Accessibility.whenUnlockedThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
                }

                it("should map afterFirstUnlock") {
                    let sut = Accessibility.afterFirstUnlock.rawValue as String
                    expect(sut) == (kSecAttrAccessibleAfterFirstUnlock as String)
                }

                it("should map afterFirstUnlockThisDeviceOnly") {
                    let sut = Accessibility.afterFirstUnlockThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
                }

                it("should map whenPasscodeSetThisDeviceOnly") {
                    let sut = Accessibility.whenPasscodeSetThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
                }

                it("should map whenPasscodeSetThisDeviceOnly") {
                    let sut = Accessibility.whenPasscodeSetThisDeviceOnly.rawValue as String
                    expect(sut) == (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
                }
            }
        }
    }
}
