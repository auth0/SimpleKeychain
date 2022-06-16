import Nimble
import Quick

@testable import SimpleKeychain
import LocalAuthentication

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let kKeychainService = "com.auth0.simplekeychain.tests"

class SimpleKeychainSpec: QuickSpec {
    override func spec() {
        describe("SimpleKeychain") {
            var sut: SimpleKeychain!

            afterEach {
                try? sut.deleteAll()
            }

            describe("initialization") {
                it("should init with default values") {
                    sut = SimpleKeychain()
                    expect(sut.accessGroup).to(beNil())
                    expect(sut.service).to(equal(Bundle.main.bundleIdentifier))
                    expect(sut.accessibility).to(equal(Accessibility.afterFirstUnlock))
                    expect(sut.accessControlFlags).to(beNil())
                }

                it("should init with custom values") {
                    sut = SimpleKeychain(service: kKeychainService,
                                         accessGroup: "Group",
                                         accessibility: .whenUnlocked,
                                         accessControlFlags: .userPresence)
                    expect(sut.accessGroup).to(equal("Group"))
                    expect(sut.service).to(equal(kKeychainService))
                    expect(sut.accessibility).to(equal(Accessibility.whenUnlocked))
                    expect(sut.accessControlFlags).to(equal(.userPresence))
                }

                #if canImport(LocalAuthentication)
                it("should init with custom local authentication context") {
                    let context = LAContext()
                    sut = SimpleKeychain(context: context)
                    expect(sut.context).to(be(context))
                }
                #endif
            }

            describe("storing items") {
                var key: String!

                beforeEach({
                    sut = SimpleKeychain(service: kKeychainService)
                    key = UUID().uuidString
                })

                context("string items") {
                    it("should store a string item under a new key") {
                        expect { try sut.set("value", forKey: key) }.toNot(throwError())
                    }

                    it("should store a string item under an existing key") {
                        try sut.set("value1", forKey: key)
                        expect { try sut.set("value2", forKey: key) }.toNot(throwError())
                    }

                    it("should store a string item with a custom accessibility value") {
                        sut = SimpleKeychain(service: kKeychainService, accessibility: .whenUnlocked)
                        expect(try sut.set("value", forKey: key)).toNot(throwError())
                    }

                    #if !os(macOS)
                    it("should store a string item with access control") {
                        sut = SimpleKeychain(service: kKeychainService, accessControlFlags: .privateKeyUsage)
                        expect(try sut.set("value", forKey: key)).toNot(throwError())
                    }
                    #endif
                }

                context("data items") {
                    it("should store a data item under a new key") {
                        expect { try sut.set(Data(), forKey: key) }.toNot(throwError())
                    }

                    it("should store a data item under an existing key") {
                        try sut.set( Data(), forKey: key)
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }

                    it("should store a string item with a custom accessibility value") {
                        sut = SimpleKeychain(service: kKeychainService, accessibility: .whenUnlocked)
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }

                    #if !os(macOS)
                    it("should store a data item with access control") {
                        sut = SimpleKeychain(service: kKeychainService, accessControlFlags: .privateKeyUsage)
                        expect(try sut.set(Data(), forKey: key)).toNot(throwError())
                    }
                    #endif
                }
            }

            describe("removing items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: kKeychainService)
                    key = UUID().uuidString
                    try! sut.set("value1", forKey: key)
                }

                it("should delete item") {
                    expect { try sut.deleteItem(forKey: key) }.toNot(throwError())
                }

                it("should throw an error when retrieving an item with a non-existing key") {
                    expect { try sut.deleteItem(forKey: "SHOULDNOTEXIST") }.to(throwError())
                }

                it("should clear all items") {
                    try sut.deleteAll()
                    expect { try sut.string(forKey: key) }.to(throwError(SimpleKeychainError.itemNotFound))
                }
            }

            describe("retrieving items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: kKeychainService)
                    key = UUID().uuidString
                    try! sut.set("value1", forKey: key)
                }

                it("should retrieve string item") {
                    expect { try sut.string(forKey: key) }.to(equal("value1"))
                }

                it("should retrieve data item") {
                    expect { try sut.data(forKey: key) }.notTo(beNil())
                }

                it("should throw error when retrieving a data item with non-existing key") {
                    let expectedError = SimpleKeychainError.itemNotFound
                    expect { try sut.data(forKey: "SHOULDNOTEXIST") }.to(throwError(expectedError))
                }

                it("should throw error when retrieving a string item with non-existing key") {
                    let expectedError = SimpleKeychainError.itemNotFound
                    expect { try sut.string(forKey: "SHOULDNOTEXIST") }.to(throwError(expectedError))
                }
            }

            describe("checking items") {
                var key: String!

                beforeEach {
                    sut = SimpleKeychain(service: kKeychainService)
                    key = UUID().uuidString
                    try! sut.set("value1", forKey: key)
                }

                it("should return true when the item is stored") {
                    expect { try sut.hasItem(forKey: key) }.to(beTrue())
                }

                it("should return false when the item is not stored") {
                    expect { try sut.hasItem(forKey: "SHOULDNOTEXIST") }.to(beFalse())
                }
            }

            describe("retrieving keys") {
                var keys: [String] = []

                beforeEach {
                    try! sut.deleteAll()

                    sut = SimpleKeychain(service: kKeychainService)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)
                    keys.append(UUID().uuidString)

                    for (i, key) in keys.enumerated() {
                        try! sut.set("value\(i)", forKey: key)
                    }
                }

                it("should return all the keys") {
                    expect { try sut.keys() }.to(equal(keys))
                }
                
                it("should return an empty array when there are no keys") {
                    for key in keys {
                        expect { try sut.data(forKey: key) }.notTo(beNil())
                    }

                    expect{ try sut.keys().count }.to(equal(keys.count))

                    try sut.deleteAll()
                    let expectedError = SimpleKeychainError.itemNotFound
                    
                    for key in keys {
                        expect { try sut.data(forKey: key) }.to(throwError(expectedError))
                    }

                    expect{ try sut.keys().count }.to(equal(0))
                }
            }
        }
    }
}
