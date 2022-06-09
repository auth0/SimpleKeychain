import SimpleKeychain
import Nimble
import Quick

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let kKeychainService = "com.auth0.simplekeychain.tests"

class A0SimpleKeychainSpec: QuickSpec {
    override func spec() {
        describe("A0SimpleKeychain") {
            var keychain: A0SimpleKeychain!

            describe("initialization") {
                it("should init with default values") {
                    keychain = A0SimpleKeychain()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service only") {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service and access group") {
                    keychain = A0SimpleKeychain(service: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
            }

            describe("factory methods") {
                it("should create with default values") {
                    keychain = A0SimpleKeychain()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service only") {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service and access group") {
                    keychain = A0SimpleKeychain(service: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.afterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
            }

            describe("storing values") {

                var key: String!

                beforeEach({
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().uuidString
                })

                it("should store a a value under a new key") {
                    expect(keychain.setString("value", forKey: key)).to(beTruthy())
                }

                it("should store a a value under an existing key") {
                    keychain.setString("value1", forKey:key)
                    expect(keychain.setString("value2", forKey:key)).to(beTruthy())
                }

                it("should store a data value under a new key") {
                    expect(keychain.setData(NSData() as Data, forKey:key)).to(beTruthy())
                }

                it("should store a data value under an existing key") {
                    keychain.setData(NSData() as Data, forKey:key)
                    expect(keychain.setData(NSData() as Data, forKey:key)).to(beTruthy())
                }

            }

            describe("removing values") {

                var key: String!

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().uuidString
                    keychain.setString("value1", forKey:key)
                }

                it("should remove entry for key") {
                    expect(keychain.deleteEntry(forKey: key)).to(beTruthy())
                }

                it("should fail with nonexisting key") {
                    expect(keychain.deleteEntry(forKey: "SHOULDNOTEXIST")).to(beFalsy())
                }

                it("should clear all entries") {
                    keychain.clearAll()
                    expect(keychain.string(forKey: key)).to(beNil())
                }

            }

            describe("retrieving values") {

                var key: String!

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().uuidString
                    keychain.setString("value1", forKey:key)
                }

                it("should return that a key exists") {
                    expect(keychain.string(forKey: key)).toNot(beNil())
                }

                it("should return nil data with non existing key") {
                    expect(keychain.data(forKey: "SHOULDNOTEXIST")).to(beNil())
                }

                it("should return nil string with non existing key") {
                    expect(keychain.string(forKey: "SHOULDNOTEXIST")).to(beNil())
                }

                it("should return string for a key") {
                    expect(keychain.string(forKey: key)).to(equal("value1"))
                }

                it("should return data for a key") {
                    expect(keychain.data(forKey: key)).notTo(beNil())
                }
            }
            
            describe("retrieving keys") {
                
                var keys = [String]()
                
                beforeEach {
                    keychain.clearAll()
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)

                    for (i, key) in keys.enumerated() {
                        keychain.setString("value\(i)", forKey: key)
                    }
                }
                
                afterEach {
                    keychain.clearAll()
                }
                
                it("should return all the keys") {
                    expect(keychain.keys() as? [String]).to(equal(keys))
                }
                
                it("should clear all") {
                    
                    for key in keys {
                        expect(keychain.data(forKey: key)).notTo(beNil())
                    }
                    expect(keychain.keys().count).to(equal(keys.count))
                    
                    keychain.clearAll()
                    
                    for key in keys {
                        expect(keychain.data(forKey: key)).to(beNil())
                    }
                    expect(keychain.keys().count).to(equal(0))
                }
            }
        }
    }
}
