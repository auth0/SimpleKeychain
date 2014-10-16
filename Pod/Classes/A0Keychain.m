//  A0Keychain.m
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

#import "A0Keychain.h"

@interface A0Keychain ()

@end

@implementation A0Keychain

- (instancetype)init {
    NSString *service = [[NSBundle mainBundle] bundleIdentifier];
    return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service {
    return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
    self = [super init];
    if (self) {
        _service = service;
        _accessGroup = accessGroup;
        _defaultAccesiblity = A0KeychainItemAccessibleAfterFirstUnlock;
    }
    return self;
}

- (NSString *)stringForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    NSString *string;
    if (data) {
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return string;
}

- (NSData *)dataForKey:(NSString *)key {
    if (!key) {
        return nil;
    }

    NSDictionary *query = [self queryFetchOneByKey:key];
    CFTypeRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    if (status != errSecSuccess) {
        return nil;
    }

    NSData *dataFound = [NSData dataWithData:(__bridge NSData *)data];
    if (data) {
        CFRelease(data);
    }

    return dataFound;
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key {
    NSData *data = key ? [string dataUsingEncoding:NSUTF8StringEncoding] : nil;
    return [self setData:data forKey:key];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key {
    if (!key) {
        return NO;
    }

    NSDictionary *query = [self queryFindByKey:key];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecSuccess) {
        if (data) {
            NSDictionary *updateQuery = [self queryUpdateValue:data];
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)updateQuery);
            return status == errSecSuccess;
        } else {
            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
            return status == errSecSuccess;
        }
    } else {
        NSDictionary *newQuery = [self queryNewKey:key value:data];
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)newQuery, NULL);
        return status == errSecSuccess;
    }
}

- (BOOL)deleteEntryForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    NSDictionary *deleteQuery = [self queryFindByKey:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
    return status == errSecSuccess;
}

- (void)clearAll {
    NSDictionary *query = [self queryFindAll];
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        NSArray *items = [NSArray arrayWithArray:(__bridge NSArray *)result];
        CFBridgingRelease(result);
        for (NSDictionary *item in items) {
            NSMutableDictionary *queryDelete = [[NSMutableDictionary alloc] initWithDictionary:item];
            queryDelete[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;

            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDelete);
            if (status != errSecSuccess) {
                break;
            }
        }
    }
}

+ (A0Keychain *)keychain {
    return [[A0Keychain alloc] init];
}

+ (A0Keychain *)keychainWithService:(NSString *)service {
    return [[A0Keychain alloc] initWithService:service];
}

+ (A0Keychain *)keychainWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
    return [[A0Keychain alloc] initWithService:service accessGroup:accessGroup];
}

#pragma mark - Utility methods

- (CFTypeRef)accessibility {
    CFTypeRef accessibility;
    switch (self.defaultAccesiblity) {
        case A0KeychainItemAccessibleAfterFirstUnlock:
            accessibility = kSecAttrAccessibleAfterFirstUnlock;
            break;
        case A0KeychainItemAccessibleAlways:
            accessibility = kSecAttrAccessibleAlways;
            break;
        case A0KeychainItemAccessibleAfterFirstUnlockThisDeviceOnly:
            accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
            break;
        case A0KeychainItemAccessibleAlwaysThisDeviceOnly:
            accessibility = kSecAttrAccessibleAlwaysThisDeviceOnly;
            break;
        case A0KeychainItemAccessibleWhenPasscodeSetThisDeviceOnly:
            accessibility = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
            break;
        case A0KeychainItemAccessibleWhenUnlocked:
            accessibility = kSecAttrAccessibleWhenUnlocked;
            break;
        case A0KeychainItemAccessibleWhenUnlockedThisDeviceOnly:
            accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
            break;
        default:
            accessibility = kSecAttrAccessibleAfterFirstUnlock;
    }
    return accessibility;
}

#pragma mark - Query Dictionary Builder methods

- (NSMutableDictionary *)baseQuery {
    NSMutableDictionary *attributes = [@{
                                         (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                         (__bridge id)kSecAttrService: self.service,
                                         } mutableCopy];
#if !TARGET_IPHONE_SIMULATOR
    if (self.accessGroup) {
        attributes[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
#endif

    return attributes;
}

- (NSDictionary *)queryFindAll {
    NSMutableDictionary *query = [self baseQuery];
    [query addEntriesFromDictionary:@{
                                     (__bridge id)kSecReturnAttributes: @YES,
                                     (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitAll,
                                     }];
    return query;
}

- (NSDictionary *)queryFindByKey:(NSString *)key {
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
    return query;
}

- (NSDictionary *)queryUpdateValue:(NSData *)data {
    return @{
             (__bridge id)kSecValueData: data,
             };
}

- (NSDictionary *)queryNewKey:(NSString *)key value:(NSData *)value {
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
    query[(__bridge id)kSecValueData] = value;
    query[(__bridge id)kSecAttrAccessible] = (__bridge id)[self accessibility];
    return query;
}

- (NSDictionary *)queryFetchOneByKey:(NSString *)key {
    NSMutableDictionary *query = [self baseQuery];
    [query addEntriesFromDictionary:@{
                                      (__bridge id)kSecReturnData: @YES,
                                      (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
                                      (__bridge id)kSecAttrAccount: key,
                                      }];

    return query;
}
@end
