#import "A0SimpleKeychain.h"

@interface A0SimpleKeychain ()

@end

@implementation A0SimpleKeychain

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
        _defaultAccessiblity = A0SimpleKeychainItemAccessibleAfterFirstUnlock;
        _useAccessControl = NO;
        
// This does not apply to watchOS & tvOS
#if A0LocalAuthenticationCapable
        _localAuthenticationContext = [LAContext new];
        _localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = 0;
#endif
    }
    return self;
}

- (void)setTouchIDAuthenticationAllowableReuseDuration:(NSTimeInterval) duration {
// This does not apply to watchOS & tvOS
#if A0LocalAuthenticationCapable
    if (duration <= 0) {
        _localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = 0;
    } else if (duration >= LATouchIDAuthenticationMaximumAllowableReuseDuration) {
        _localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = LATouchIDAuthenticationMaximumAllowableReuseDuration;
    } else {
        _localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = duration;
    }
#endif
}

- (NSString *)stringForKey:(NSString *)key {
    return [self stringForKey:key promptMessage:nil];
}

- (NSData *)dataForKey:(NSString *)key {
    return [self dataForKey:key promptMessage:nil];
}

- (NSString *)stringForKey:(NSString *)key promptMessage:(NSString *)message {
    NSData *data = [self dataForKey:key promptMessage:message];
    NSString *string = nil;
    if (data) {
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return string;
}

- (NSData *)dataForKey:(NSString *)key promptMessage:(NSString *)message {
    return [self dataForKey:key promptMessage:message error:nil];
}

- (NSData *)dataForKey:(NSString *)key promptMessage:(NSString *)message error:(NSError**)err {
    if (!key) {
        return nil;
    }
    
    NSDictionary *query = [self queryFetchOneByKey:key message:message];
    CFTypeRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    if (status != errSecSuccess) {
        if(err != nil) {
            *err = [NSError errorWithDomain:A0ErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey : [self stringForSecStatus:status]}];
        }
        return nil;
    }
    
    NSData *dataFound = [NSData dataWithData:(__bridge NSData *)data];
    if (data) {
        CFRelease(data);
    }
    
    return dataFound;
}

- (BOOL)hasValueForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    NSDictionary *query = [self queryFindByKey:key message:nil];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    return status == errSecSuccess;
}

- (nonnull NSArray *)keys {
    NSMutableArray *keys = [NSMutableArray array];
    NSDictionary *query = [self queryFindAll];
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecSuccess) {
        NSArray *items = [NSArray arrayWithArray:(__bridge NSArray *)result];
        CFBridgingRelease(result);
        for (NSDictionary *item in items) {
            id secAccount = item[(__bridge id)kSecAttrAccount];
            if ([secAccount isKindOfClass:[NSString class]]) {
                NSString *key = (NSString *)secAccount;
                [keys addObject:key];
            }
        }
    }
    return keys;
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key {
    return [self setString:string forKey:key promptMessage:nil];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key {
    return [self setData:data forKey:key promptMessage:nil];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key promptMessage:(NSString *)message {
    NSData *data = key ? [string dataUsingEncoding:NSUTF8StringEncoding] : nil;
    return [self setData:data forKey:key promptMessage:message];
}


- (BOOL)setData:(NSData *)data forKey:(NSString *)key promptMessage:(NSString *)message {
    if (!key) {
        return NO;
    }
    
    NSDictionary *query = [self queryFindByKey:key message:message];

    // Touch ID case
    if (self.useAccessControl && self.defaultAccessiblity == A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly) {
        // TouchId case. Doesn't support updating keychain items
        // see Known Issues: https://developer.apple.com/library/ios/releasenotes/General/RN-iOSSDK-8.0/
        // We need to delete old and add a new item. This can fail
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
        if (status == errSecSuccess || status == errSecItemNotFound) {
            NSDictionary *newQuery = [self queryNewKey:key value:data];
            OSStatus status = SecItemAdd((__bridge CFDictionaryRef)newQuery, NULL);
            return status == errSecSuccess;
        }
    }

    // Normal case
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecSuccess) {
        if (data) {
            NSDictionary *updateQuery = [self queryUpdateValue:data message:message];
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
    NSDictionary *deleteQuery = [self queryFindByKey:key message:nil];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
    return status == errSecSuccess;
}

- (void)clearAll {
  NSMutableDictionary *queryDelete = [self baseQuery];
  queryDelete[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
#if !TARGET_OS_IPHONE
  queryDelete[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
#endif
  OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDelete);
  if (status != errSecSuccess) {
    return;
  }
}

+ (A0SimpleKeychain *)keychain {
    return [[A0SimpleKeychain alloc] init];
}

+ (A0SimpleKeychain *)keychainWithService:(NSString *)service {
    return [[A0SimpleKeychain alloc] initWithService:service];
}

+ (A0SimpleKeychain *)keychainWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
    return [[A0SimpleKeychain alloc] initWithService:service accessGroup:accessGroup];
}

#pragma mark - Utility methods

- (CFTypeRef)accessibility {
    CFTypeRef accessibility;
    switch (self.defaultAccessiblity) {
        case A0SimpleKeychainItemAccessibleAfterFirstUnlock:
            accessibility = kSecAttrAccessibleAfterFirstUnlock;
            break;
        case A0SimpleKeychainItemAccessibleAfterFirstUnlockThisDeviceOnly:
            accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
            break;
        case A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly:
            accessibility = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly;
            break;
        case A0SimpleKeychainItemAccessibleWhenUnlocked:
            accessibility = kSecAttrAccessibleWhenUnlocked;
            break;
        case A0SimpleKeychainItemAccessibleWhenUnlockedThisDeviceOnly:
            accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
            break;
        default:
            accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    }
    return accessibility;
}

- (NSString*)stringForSecStatus:(OSStatus)status {
    
    switch(status) {
        case errSecSuccess:
            return NSLocalizedStringFromTable(@"errSecSuccess: No error", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecUnimplemented:
            return NSLocalizedStringFromTable(@"errSecUnimplemented: Function or operation not implemented", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecParam:
            return NSLocalizedStringFromTable(@"errSecParam: One or more parameters passed to the function were not valid", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecAllocate:
            return NSLocalizedStringFromTable(@"errSecAllocate: Failed to allocate memory", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecNotAvailable:
            return NSLocalizedStringFromTable(@"errSecNotAvailable: No trust results are available", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecAuthFailed:
            return NSLocalizedStringFromTable(@"errSecAuthFailed: Authorization/Authentication failed", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecDuplicateItem:
            return NSLocalizedStringFromTable(@"errSecDuplicateItem: The item already exists", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecItemNotFound:
            return NSLocalizedStringFromTable(@"errSecItemNotFound: The item cannot be found", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecInteractionNotAllowed:
            return NSLocalizedStringFromTable(@"errSecInteractionNotAllowed: Interaction with the Security Server is not allowed", @"SimpleKeychain", @"Possible error from keychain. ");
        case errSecDecode:
            return NSLocalizedStringFromTable(@"errSecDecode: Unable to decode the provided data", @"SimpleKeychain", @"Possible error from keychain. ");
        default:
            return [NSString stringWithFormat:NSLocalizedStringFromTable(@"Unknown error code %d", @"SimpleKeychain", @"Possible error from keychain. "), (int)status];
    }
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
    
#if A0LocalAuthenticationCapable
    attributes[(__bridge id)kSecUseAuthenticationContext] = self.localAuthenticationContext;
#endif
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

- (NSDictionary *)queryFindByKey:(NSString *)key message:(NSString *)message {
    NSAssert(key != nil, @"Must have a valid non-nil key");
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
    if (message) {
        query[(__bridge id)kSecUseOperationPrompt] = message;
    }
    return query;
}

- (NSDictionary *)queryUpdateValue:(NSData *)data message:(NSString *)message {
    if (message) {
        return @{
            (__bridge id)kSecUseOperationPrompt: message,
            (__bridge id)kSecValueData: data
        };
    }
    return @{(__bridge id)kSecValueData: data};
}

- (NSDictionary *)queryNewKey:(NSString *)key value:(NSData *)value {
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
    query[(__bridge id)kSecValueData] = value;
    if (self.useAccessControl) {
        CFErrorRef error = NULL;
        SecAccessControlRef accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, [self accessibility], kSecAccessControlUserPresence, &error);
        if (error == NULL || accessControl != NULL) {
            query[(__bridge id)kSecAttrAccessControl] = (__bridge_transfer id)accessControl;
            query[(__bridge id)kSecUseAuthenticationUI] = (__bridge_transfer id)kSecUseAuthenticationUIFail;
        }
    } else {
        query[(__bridge id)kSecAttrAccessible] = (__bridge id)[self accessibility];
    }
    return query;
}

- (NSDictionary *)queryFetchOneByKey:(NSString *)key message:(NSString *)message {
    NSMutableDictionary *query = [self baseQuery];
    [query addEntriesFromDictionary:@{
                                      (__bridge id)kSecReturnData: @YES,
                                      (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
                                      (__bridge id)kSecAttrAccount: key,
                                      }];
    if (self.useAccessControl && message) {
        query[(__bridge id)kSecUseOperationPrompt] = message;
    }

    return query;
}
@end
