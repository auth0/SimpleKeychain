// SimpleKeychainSpec.swift
//
// Copyright (c) 2014 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service only") {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service and access group") {
                    keychain = A0SimpleKeychain(service: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
            }

            describe("factory methods") {
                it("should create with default values") {
                    keychain = A0SimpleKeychain()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service only") {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service and access group") {
                    keychain = A0SimpleKeychain(service: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(A0SimpleKeychainItemAccessible.AfterFirstUnlock))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
            }

            describe("Storing values") {

                var key: String!

                beforeEach({
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().UUIDString
                })

                it("should store a a value under a new key") {
                    expect(keychain.setString("value", forKey: key)).to(beTruthy())
                }

                it("should store a a value under an existing key") {
                    keychain.setString("value1", forKey:key)
                    expect(keychain.setString("value2", forKey:key)).to(beTruthy())
                }

                it("should store a data value under a new key") {
                    expect(keychain.setData(NSData(), forKey:key)).to(beTruthy())
                }

                it("should store a data value under an existing key") {
                    keychain.setData(NSData(), forKey:key)
                    expect(keychain.setData(NSData(), forKey:key)).to(beTruthy())
                }

            }

            describe("Removing values") {

                var key: String!

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().UUIDString
                    keychain.setString("value1", forKey:key)
                }

                it("should remove entry for key") {
                    expect(keychain.deleteEntryForKey(key)).to(beTruthy())
                }

                it("should fail with nonexisting key") {
                    expect(keychain.deleteEntryForKey("SHOULDNOTEXIST")).to(beFalsy())
                }

                it("should clear all entries") {
                    keychain.clearAll()
                    expect(keychain.stringForKey(key)).to(beNil())
                }

            }

            describe("retrieving values") {

                var key: String!

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    key = NSUUID().UUIDString
                    keychain.setString("value1", forKey:key)
                }

                it("should return that a key exists") {
                    expect(keychain.stringForKey(key)).toNot(beNil())
                }

                it("should return nil data with non existing key") {
                    expect(keychain.dataForKey("SHOULDNOTEXIST")).to(beNil())
                }

                it("should return nil string with non existing key") {
                    expect(keychain.stringForKey("SHOULDNOTEXIST")).to(beNil())
                }

                it("should return string for a key") {
                    expect(keychain.stringForKey(key)).to(equal("value1"))
                }

                it("should return data for a key") {
                    expect(keychain.dataForKey(key)).notTo(beNil())
                }
            }

            describe("generate key pair") {

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                }

                afterEach {
                    keychain.deleteRSAKeyWithTag(PublicKeyTag)
                    keychain.deleteRSAKeyWithTag(PrivateKeyTag)
                }

                it("should generate a key pair") {
                keychain.generateRSAKeyPairWithLength(A0SimpleKeychainRSAKeySize.Size1024Bits, publicKeyTag:PublicKeyTag, privateKeyTag:PrivateKeyTag)
                expect(keychain.dataForRSAKeyWithTag(PublicKeyTag)).notTo(beNil())
                expect(keychain.dataForRSAKeyWithTag(PrivateKeyTag)).notTo(beNil())
                }
            }

            describe("obtain RSA key as NSData") {

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    keychain.generateRSAKeyPairWithLength(A0SimpleKeychainRSAKeySize.Size1024Bits,
                        publicKeyTag:PublicKeyTag,
                        privateKeyTag:PrivateKeyTag)
                }

                afterEach {
                    keychain.deleteRSAKeyWithTag(PublicKeyTag)
                    keychain.deleteRSAKeyWithTag(PrivateKeyTag)
                }

                it("should obtain keys") {
                    expect(keychain.dataForRSAKeyWithTag(PublicKeyTag)).notTo(beNil())
                    expect(keychain.dataForRSAKeyWithTag(PrivateKeyTag)).notTo(beNil())
                }
            }

            describe("check if RSA key exists") {

                beforeEach {
                    keychain = A0SimpleKeychain(service: kKeychainService)
                    keychain.generateRSAKeyPairWithLength(A0SimpleKeychainRSAKeySize.Size1024Bits,
                        publicKeyTag:PublicKeyTag,
                        privateKeyTag:PrivateKeyTag)
                }

                afterEach {
                    keychain.deleteRSAKeyWithTag(PublicKeyTag)
                    keychain.deleteRSAKeyWithTag(PrivateKeyTag)
                }

                it("should check if the key exists") {
                    expect(keychain.hasRSAKeyWithTag(PublicKeyTag)).to(beTruthy())
                    expect(keychain.hasRSAKeyWithTag(PrivateKeyTag)).to(beTruthy())
                }

                it("should return NO for nonexisting key") {
                    expect(keychain.hasRSAKeyWithTag("NONEXISTENT")).to(beFalsy())
                }
            }
        }
    }
}
