import UIKit
import Quick
import Nimble
import SimpleKeychain

let ServiceName = "com.auth0.simplekeychain"

class A0SimpleKeychainSpec: QuickSpec {
    override func spec() {

        describe("initialisation") {
            it("should init with default values") {
                let keychain = A0SimpleKeychain(service: ServiceName)
                expect(keychain.service).to(equal(ServiceName))
                expect(keychain.accessGroup).to(beNil())
                expect(keychain.defaultAccessibility).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                expect(keychain.useAccessControl).to(beFalse())
            }

            it("should init with custom values") {
                let keychain = A0SimpleKeychain(service: ServiceName, accessGroup: "com.auth0.shared", defaultAccessibility: .WhenPasscodeSetThisDeviceOnly, useAccessControl: true)
                expect(keychain.service).to(equal(ServiceName))
                expect(keychain.accessGroup).to(equal("com.auth0.shared"))
                expect(keychain.defaultAccessibility).to(equal(A0SimpleKeychainItemAccessible.WhenPasscodeSetThisDeviceOnly))
                expect(keychain.useAccessControl).to(beTrue())
            }
        }

        describe("Store values") {

            var keychain: A0SimpleKeychain!
            var key: String!

            beforeEach {
                keychain = A0SimpleKeychain(service: ServiceName)
                key = NSUUID().UUIDString
            }

            afterEach {
                keychain.removeAllValues()
            }

            it("should update an existing NSData value") {
                expect(keychain.setData("OLD".dataUsingEncoding(NSUTF8StringEncoding)!, forKey: key)).to(beTrue())
                expect(keychain.setData("NEW".dataUsingEncoding(NSUTF8StringEncoding)!, forKey: key)).to(beTrue())
                let data = keychain.dataForKey(key).value!
                expect(NSString(data: data, encoding: NSUTF8StringEncoding)!).to(equal("NEW"))
            }

            it("should store a new string value") {
                expect(keychain.setString("A String", forKey: key)).to(beTrue())
            }

            it("should update an existing string value") {
                let oldValue = "OLD"
                let newValue = "NEW"
                expect(keychain.setString(oldValue, forKey: key)).to(beTrue())
                expect(keychain.stringForKey(key).value).to(equal(oldValue))
                expect(keychain.setString(newValue, forKey: key)).to(beTrue())
                expect(keychain.stringForKey(key).value).to(equal(newValue))
            }
            

            it("should store a new NSData value") {
                expect(keychain.setData("A String".dataUsingEncoding(NSUTF8StringEncoding)!, forKey: key)).to(beTrue())
            }


        }
    }
}
