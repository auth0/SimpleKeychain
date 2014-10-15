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
        _accesiblity = kSecAttrAccessibleAfterFirstUnlock;
    }
    return self;
}

- (NSString *)stringForKey:(NSString *)key {
    return nil;
}

- (NSData *)dataForKey:(NSString *)key {
    return nil;
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    return [self setString:string forKey:key useACL:NO];
}

- (void)setString:(NSString *)string forKey:(NSString *)key useACL:(BOOL)useACL {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self setData:data forKey:key useACL:useACL];
}

- (void)setData:(NSData *)data forKey:(NSString *)key {
    [self setData:data forKey:key useACL:NO];
}

- (void)setData:(NSData *)data forKey:(NSString *)key useACL:(BOOL)useACL {
}

- (void)deleteEntryForKey:(NSString *)key {
}

- (void)clearAll {
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

@end
