#import "A0SimpleKeychain+KeyPair.h"

@implementation A0SimpleKeychain (KeyPair)

- (BOOL)generateRSAKeyPairWithLength:(A0SimpleKeychainRSAKeySize)keyLength
                        publicKeyTag:(NSString *)publicKeyTag
                       privateKeyTag:(NSString *)privateKeyTag {
    NSAssert(publicKeyTag.length > 0 && privateKeyTag.length > 0, @"Both key tags should be non-empty!");

    NSMutableDictionary *pairAttr = [@{
                                       (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeRSA,
                                       (__bridge id)kSecAttrKeySizeInBits: @(keyLength),
                                       } mutableCopy];
    NSDictionary *privateAttr = @{
                                  (__bridge id)kSecAttrIsPermanent: @YES,
                                  (__bridge id)kSecAttrApplicationTag: [privateKeyTag dataUsingEncoding:NSUTF8StringEncoding],
                                  };
    NSDictionary *publicAttr = @{
                                 (__bridge id)kSecAttrIsPermanent: @YES,
                                 (__bridge id)kSecAttrApplicationTag: [publicKeyTag dataUsingEncoding:NSUTF8StringEncoding],
                                 };
    pairAttr[(__bridge id)kSecPrivateKeyAttrs] = privateAttr;
    pairAttr[(__bridge id)kSecPublicKeyAttrs] = publicAttr;

    SecKeyRef publicKeyRef;
    SecKeyRef privateKeyRef;

    OSStatus status = SecKeyGeneratePair((__bridge CFDictionaryRef)pairAttr, &publicKeyRef, &privateKeyRef);

    CFRelease(publicKeyRef);
    CFRelease(privateKeyRef);

    return status == errSecSuccess;
}

- (NSData *)dataForRSAKeyWithTag:(NSString *)keyTag {
    NSAssert(keyTag.length > 0, @"key tag should be non-empty!");

    NSDictionary *publicKeyQuery = @{
                                     (__bridge id)kSecClass: (__bridge id)kSecClassKey,
                                     (__bridge id)kSecAttrApplicationTag: [keyTag dataUsingEncoding:NSUTF8StringEncoding],
                                     (__bridge id)kSecAttrType: (__bridge id)kSecAttrKeyTypeRSA,
                                     (__bridge id)kSecReturnData: @YES,
                                     };

    CFTypeRef dataRef;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKeyQuery, &dataRef);

    if (status != errSecSuccess) {
        return nil;
    }

    NSData *data = [NSData dataWithData:(__bridge NSData *)dataRef];
    if (dataRef) {
        CFRelease(dataRef);
    }
    return data;
}

- (BOOL)hasRSAKeyWithTag:(NSString *)keyTag {
    NSAssert(keyTag.length > 0, @"key tag should be non-empty!");

    NSDictionary *publicKeyQuery = @{
                                     (__bridge id)kSecClass: (__bridge id)kSecClassKey,
                                     (__bridge id)kSecAttrApplicationTag: [keyTag dataUsingEncoding:NSUTF8StringEncoding],
                                     (__bridge id)kSecAttrType: (__bridge id)kSecAttrKeyTypeRSA,
                                     (__bridge id)kSecReturnData: @NO,
                                     };

    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKeyQuery, NULL);
    return status == errSecSuccess;
}


- (BOOL)deleteRSAKeyWithTag:(NSString *)keyTag {
    NSAssert(keyTag.length > 0, @"key tag should be non-empty!");
    NSDictionary *deleteKeyQuery = @{
                                     (__bridge id)kSecClass: (__bridge id)kSecClassKey,
                                     (__bridge id)kSecAttrApplicationTag: [keyTag dataUsingEncoding:NSUTF8StringEncoding],
                                     (__bridge id)kSecAttrType: (__bridge id)kSecAttrKeyTypeRSA,
                                     };

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteKeyQuery);
    return status == errSecSuccess;
}

- (SecKeyRef)keyRefOfRSAKeyWithTag:(NSString *)keyTag {
    NSAssert(keyTag.length > 0, @"key tag should be non-empty!");
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassKey,
                            (__bridge id)kSecAttrKeyType: (__bridge id)kSecAttrKeyTypeRSA,
                            (__bridge id)kSecReturnRef: @YES,
                            (__bridge id)kSecAttrApplicationTag: keyTag,
                            };
    SecKeyRef privateKeyRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&privateKeyRef);
    if (status != errSecSuccess) {
        return NULL;
    }
    return privateKeyRef;
}

@end
