#import "A0SimpleKeychain.h"

typedef NS_ENUM(NSUInteger, A0SimpleKeychainRSAKeySize) {
    A0SimpleKeychainRSAKeySize512Bits = 512,
    A0SimpleKeychainRSAKeySize1024Bits = 1024,
    A0SimpleKeychainRSAKeySize2048Bits = 2048
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  Category of `A0SimpleKeychain` to handle RSA pairs keys in the Keychain
 */
@interface A0SimpleKeychain (KeyPair)

/**
 *  Generates a RSA key pair with a specific length and tags. 
 *  Each key is marked as permanent in the Keychain
 *
 *  @param keyLength     number of bits of the keys.
 *  @param publicKeyTag  tag of the public key
 *  @param privateKeyTag tag of the private key
 *
 *  @return if the key par is created it will return YES, otherwise NO.
 */
- (BOOL)generateRSAKeyPairWithLength:(A0SimpleKeychainRSAKeySize)keyLength
                        publicKeyTag:(NSString *)publicKeyTag
                       privateKeyTag:(NSString *)privateKeyTag;

/**
 *  Returns a RSA key as NSData.
 *
 *  @param keyTag tag of the key
 *
 *  @return the key as NSData or nil if not found
 */
- (nullable NSData *)dataForRSAKeyWithTag:(NSString *)keyTag;

/**
 *  Removes a key using its tag.
 *
 *  @param keyTag tag of the key to remove
 *
 *  @return if the key was removed successfuly.
 */
- (BOOL)deleteRSAKeyWithTag:(NSString *)keyTag;

/**
 *  Returns a RSA key as `SecKeyRef`. You must release it when you're done with it
 *
 *  @param keyTag tag of the RSA Key
 *
 *  @return SecKeyRef of RSA Key
 */
- (nullable SecKeyRef)keyRefOfRSAKeyWithTag:(NSString *)keyTag;

/**
 *  Checks if a RSA key exists with a given tag.
 *
 *  @param keyTag tag of RSA Key
 *
 *  @return if the key exists or not.
 */
- (BOOL)hasRSAKeyWithTag:(NSString *)keyTag;

@end

NS_ASSUME_NONNULL_END
