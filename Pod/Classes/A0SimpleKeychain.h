//  A0SimpleKeychain.h
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

typedef NS_ENUM(NSInteger, A0SimpleKeychainItemAccessible) {
    /**
     *  @see kSecAttrAccessibleWhenUnlocked
     */
    A0SimpleKeychainItemAccessibleWhenUnlocked = 0,
    /**
     *  @see kSecAttrAccessibleAfterFirstUnlock
     */
    A0SimpleKeychainItemAccessibleAfterFirstUnlock,
    /**
     *  @see kSecAttrAccessibleAlways
     */
    A0SimpleKeychainItemAccessibleAlways,
    /**
     *  @see kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
     */
    A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly,
    /**
     *  @see kSecAttrAccessibleWhenUnlockedThisDeviceOnly
     */
    A0SimpleKeychainItemAccessibleWhenUnlockedThisDeviceOnly,
    /**
     *  kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
     */
    A0SimpleKeychainItemAccessibleAfterFirstUnlockThisDeviceOnly,
    /**
     *  @see kSecAttrAccessibleAlwaysThisDeviceOnly
     */
    A0SimpleKeychainItemAccessibleAlwaysThisDeviceOnly
};

@interface A0SimpleKeychain : NSObject

@property (readonly, nonatomic) NSString *service;
@property (readonly, nonatomic) NSString *accessGroup;
@property (assign, nonatomic) A0SimpleKeychainItemAccessible defaultAccesiblity;
@property (assign, nonatomic) BOOL useAccessControl;


- (instancetype)init;
- (instancetype)initWithService:(NSString *)service;
- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key promptMessage:(NSString *)message;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key promptMessage:(NSString *)message;

- (BOOL)deleteEntryForKey:(NSString *)key;
- (void)clearAll;

- (NSString *)stringForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key promptMessage:(NSString *)message;
- (NSData *)dataForKey:(NSString *)key promptMessage:(NSString *)message;

+ (A0SimpleKeychain *)keychain;
+ (A0SimpleKeychain *)keychainWithService:(NSString *)service;
+ (A0SimpleKeychain *)keychainWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end
