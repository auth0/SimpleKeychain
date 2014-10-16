//  A0Keychain.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, A0KeychainItemAccessible) {
    /**
     *  @see kSecAttrAccessibleWhenUnlocked
     */
    A0KeychainItemAccessibleWhenUnlocked = 0,
    /**
     *  @see kSecAttrAccessibleAfterFirstUnlock
     */
    A0KeychainItemAccessibleAfterFirstUnlock,
    /**
     *  @see kSecAttrAccessibleAlways
     */
    A0KeychainItemAccessibleAlways,
    /**
     *  @see kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
     */
    A0KeychainItemAccessibleWhenPasscodeSetThisDeviceOnly,
    /**
     *  @see kSecAttrAccessibleWhenUnlockedThisDeviceOnly
     */
    A0KeychainItemAccessibleWhenUnlockedThisDeviceOnly,
    /**
     *  kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
     */
    A0KeychainItemAccessibleAfterFirstUnlockThisDeviceOnly,
    /**
     *  @see kSecAttrAccessibleAlwaysThisDeviceOnly
     */
    A0KeychainItemAccessibleAlwaysThisDeviceOnly
};

@interface A0Keychain : NSObject

@property (readonly, nonatomic) NSString *service;
@property (readonly, nonatomic) NSString *accessGroup;
@property (assign, nonatomic) A0KeychainItemAccessible defaultAccesiblity;
@property (assign, nonatomic) BOOL useAccessControl;


- (instancetype)init;
- (instancetype)initWithService:(NSString *)service;
- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;
- (BOOL)deleteEntryForKey:(NSString *)key;
- (void)clearAll;

- (NSString *)stringForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;

+ (A0Keychain *)keychain;
+ (A0Keychain *)keychainWithService:(NSString *)service;
+ (A0Keychain *)keychainWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end
