//  A0KeychainSpec.m
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

#import "Specta.h"
#import "A0Keychain.h"


SpecBegin(A0Keychain)

describe(@"A0Keychain", ^{

    __block A0Keychain *keychain;

    describe(@"initialization", ^{

        it(@"should init with default values", ^{
            keychain = [[A0Keychain alloc] init];
            expect(keychain.accessGroup).to.beNil();
            expect(keychain.service).to.equal([[NSBundle mainBundle] bundleIdentifier]);
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });

        it(@"should init with service only", ^{
            keychain = [[A0Keychain alloc] initWithService:@"Auth0"];
            expect(keychain.accessGroup).to.beNil();
            expect(keychain.service).to.equal(@"Auth0");
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });

        it(@"should init with service and access group", ^{
            keychain = [[A0Keychain alloc] initWithService:@"Auth0" accessGroup:@"Group"];
            expect(keychain.accessGroup).to.equal(@"Group");
            expect(keychain.service).to.equal(@"Auth0");
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });

    });

    describe(@"factory methods", ^{

        it(@"should create with default values", ^{
            keychain = [A0Keychain keychain];
            expect(keychain.accessGroup).to.beNil();
            expect(keychain.service).to.equal([[NSBundle mainBundle] bundleIdentifier]);
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });

        it(@"should create with service only", ^{
            keychain = [A0Keychain keychainWithService:@"Auth0"];
            expect(keychain.accessGroup).to.beNil();
            expect(keychain.service).to.equal(@"Auth0");
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });

        it(@"should create with service and access group", ^{
            keychain = [A0Keychain keychainWithService:@"Auth0" accessGroup:@"Group"];
            expect(keychain.accessGroup).to.equal(@"Group");
            expect(keychain.service).to.equal(@"Auth0");
            expect(keychain.defaultAccesiblity).to.equal(kSecAttrAccessibleAfterFirstUnlock);
        });
        
    });

    describe(@"Storing values", ^{

        __block NSString *key;

        beforeEach(^{
            keychain = [A0Keychain keychain];
            key = [[NSUUID UUID] UUIDString];
        });

        it(@"should fail to store a value with nil key", ^{
            expect([keychain setString:@"value" forKey:nil]).to.beFalsy();
        });

        it(@"should store a a value under a new key", ^{
            expect([keychain setString:@"value" forKey:key]).to.beTruthy();
        });

        it(@"should store a a value under an existing key", ^{
            [keychain setString:@"value1" forKey:key];
            expect([keychain setString:@"value2" forKey:key]).to.beTruthy();
        });

        it(@"should fail to store a data value with nil key", ^{
            expect([keychain setData:[NSData data] forKey:nil]).to.beFalsy();
        });

        it(@"should store a data value under a new key", ^{
            expect([keychain setData:[NSData data] forKey:key]).to.beTruthy();
        });

        it(@"should store a data value under an existing key", ^{
            [keychain setData:[NSData data] forKey:key];
            expect([keychain setData:[NSData data] forKey:key]).to.beTruthy();
        });

    });

    describe(@"Removing values", ^{

        __block NSString *key;

        beforeEach(^{
            keychain = [A0Keychain keychain];
            key = [[NSUUID UUID] UUIDString];
            [keychain setString:@"value1" forKey:key];
        });

        it(@"should remove a key when value is nil", ^{
            expect([keychain setString:nil forKey:key]).to.beTruthy();
        });

        it(@"should remove a key when data value is nil", ^{
            expect([keychain setData:nil forKey:key]).to.beTruthy();
        });

        it(@"should remove entry for key", ^{
            expect([keychain deleteEntryForKey:key]).to.beTruthy();
        });

        it(@"should fail with nil key", ^{
            expect([keychain deleteEntryForKey:nil]).to.beFalsy();
        });

        it(@"should fail with nonexisting key", ^{
            expect([keychain deleteEntryForKey:@"SHOULDNOTEXIST"]).to.beFalsy();
        });

        it(@"should clear all entries", ^{
            [keychain clearAll];
            expect([keychain stringForKey:key]).to.beNil();
        });

    });

    describe(@"retrieving values", ^{

        __block NSString *key;

        beforeEach(^{
            keychain = [A0Keychain keychain];
            key = [[NSUUID UUID] UUIDString];
            [keychain setString:@"value1" forKey:key];
        });

        it(@"should return nil string with nil key", ^{
            expect([keychain stringForKey:nil]).to.beNil();
        });

        it(@"should return nil data with nil key", ^{
            expect([keychain dataForKey:nil]).to.beNil();
        });

        it(@"should return nil data with non existing key", ^{
            expect([keychain dataForKey:@"SHOULDNOTEXIST"]).to.beNil();
        });

        it(@"should return nil string with non existing key", ^{
            expect([keychain stringForKey:@"SHOULDNOTEXIST"]).to.beNil();
        });

        it(@"should return string for a key", ^{
            expect([keychain stringForKey:key]).to.equal(@"value1");
        });

        it(@"should return data for a key", ^{
            expect([keychain dataForKey:key]).notTo.beNil();
        });
    });
});

SpecEnd
