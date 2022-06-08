#import <Foundation/Foundation.h>

#if __has_include("LocalAuthentication/LocalAuthentication.h")

#import <LocalAuthentication/LocalAuthentication.h>

#endif

///---------------------------------------------------
/// @name Keychain Items Accessibility Values
///---------------------------------------------------

/**
 *  Enum with Keychain items accessibility types. It's a mirror of `kSecAttrAccessible` values.
 */
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
    A0SimpleKeychainItemAccessibleAfterFirstUnlockThisDeviceOnly
};

#define A0ErrorDomain @"com.auth0.simplekeychain"

#define A0LocalAuthenticationCapable TARGET_OS_IOS || TARGET_OS_OSX

/**
 * Enum with keychain error codes. It's a mirror of the keychain error codes. 
 */
typedef NS_ENUM(NSInteger, A0SimpleKeychainError) {
    /**
     * @see errSecSuccess
     */
    A0SimpleKeychainErrorNoError = 0,
    /**
     * @see errSecUnimplemented
     */
    A0SimpleKeychainErrorUnimplemented = -4,
    /**
     * @see errSecParam
     */
    A0SimpleKeychainErrorWrongParameter = -50,
    /**
     * @see errSecAllocate
     */
    A0SimpleKeychainErrorAllocation = -108,
    /**
     * @see errSecNotAvailable
     */
    A0SimpleKeychainErrorNotAvailable = -25291,
    /**
     * @see errSecAuthFailed
     */
    A0SimpleKeychainErrorAuthFailed = -25293,
    /**
     * @see errSecDuplicateItem
     */
    A0SimpleKeychainErrorDuplicateItem = -25299,
    /**
     * @see errSecItemNotFound
     */
    A0SimpleKeychainErrorItemNotFound = -25300,
    /**
     * @see errSecInteractionNotAllowed
     */
    A0SimpleKeychainErrorInteractionNotAllowed = -25308,
    /**
     * @see errSecDecode
     */
    A0SimpleKeychainErrorDecode = -26275
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  A simple helper class to deal with storing and retrieving values from iOS Keychain.
 *  It has support for sharing Keychain items using Access Group and also for fine grained accessibility over a specific Keychain Item (Using Access Control).
 *  When a `NSString` or `NSData` is stored using Access Control and the accessibility flag `A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly`, the OS will prompt the user for their passcode or present a biometrics challenge (if available).
 */
@interface A0SimpleKeychain : NSObject

/**
 *  Service name under all items are saved. Default value is Bundle Identifier.
 */
@property (readonly, nonatomic) NSString *service;

/**
 *  Access Group for Keychain item sharing. If it's nil no keychain sharing is possible. Default value is nil.
 */
@property (readonly, nullable, nonatomic) NSString *accessGroup;

/**
 *  What type of accessibility the items stored will have. All values are translated to `kSecAttrAccessible` constants.
 *  Default value is A0SimpleKeychainItemAccessibleAfterFirstUnlock.
 *  @see kSecAttrAccessible
 */
@property (assign, nonatomic) A0SimpleKeychainItemAccessible defaultAccessiblity;

/**
 *  Tells A0SimpleKeychain to use `kSecAttrAccessControl` instead of `kSecAttrAccessible`.
 *  Default value is NO.
 */
@property (assign, nonatomic) BOOL useAccessControl;


/**
*  Local Authentication context used to access items. Default value is a new `LAContext` object.
*/
#if A0LocalAuthenticationCapable
@property (readonly, nullable, nonatomic) LAContext *localAuthenticationContext;
#endif

///---------------------------------------------------
/// @name Initialization
///---------------------------------------------------

/**
 *  Initialize a `A0SimpleKeychain` with default values.
 *
 *  @return an initialized instance
 */
- (instancetype)init;

/**
 *  Initialize a `A0SimpleKeychain` with a given service.
 *
 *  @param service name of the service to use to save items.
 *
 *  @return an initialized instance.
 */
- (instancetype)initWithService:(NSString *)service;

/**
 *  Initialize a `A0SimpleKeychain` with a given service and access group.
 *
 *  @param service name of the service to use to save items.
 *  @param accessGroup name of the access group to share items.
 *
 *  @return an initialized instance.
 */
- (instancetype)initWithService:(NSString *)service accessGroup:(nullable NSString *)accessGroup;

/**
 *  The duration for which Touch ID authentication reuse is allowable.
 *  Maximum value is LATouchIDAuthenticationMaximumAllowableReuseDuration
 */
#if A0LocalAuthenticationCapable
- (void)setTouchIDAuthenticationAllowableReuseDuration:(NSTimeInterval) duration API_UNAVAILABLE(watchos, tvos);
#endif

///---------------------------------------------------
/// @name Store values
///---------------------------------------------------

/**
 *  Saves the NSString with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param string value to save in the keychain
 *  @param key    key for the keychain entry.
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setString:(NSString *)string forKey:(NSString *)key;

/**
 *  Saves the NSData with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param data value to save in the keychain
 *  @param key    key for the keychain entry.
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;

/**
 *  Saves the NSString with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param string   value to save in the keychain
 *  @param key      key for the keychain entry.
 *  @param message  prompt message to display for TouchID/passcode prompt if necessary
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setString:(NSString *)string forKey:(NSString *)key promptMessage:(nullable NSString *)message;

/**
 *  Saves the NSData with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param data   value to save in the keychain
 *  @param key      key for the keychain entry.
 *  @param message  prompt message to display for TouchID/passcode prompt if necessary
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setData:(NSData *)data forKey:(NSString *)key promptMessage:(nullable NSString *)message;

///---------------------------------------------------
/// @name Remove values
///---------------------------------------------------

/**
 *  Removes an entry from the Keychain using its key
 *
 *  @param key the key of the entry to delete.
 *
 *  @return If the entry was removed it will return YES. Otherwise it will return NO.
 */
- (BOOL)deleteEntryForKey:(NSString *)key;

/**
 *  Remove all entries from the Keychain with the service and access group values.
 */
- (void)clearAll;

///---------------------------------------------------
/// @name Obtain values
///---------------------------------------------------

/**
 *  Fetches a NSString from the Keychain
 *
 *  @param key the key of the value to fetch
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSString *)stringForKey:(NSString *)key;

/**
 *  Fetches a NSData from the Keychain
 *
 *  @param key the key of the value to fetch
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key;

/**
 *  Fetches a NSString from the Keychain
 *
 *  @param key     the key of the value to fetch
 *  @param message prompt message to display for TouchID/passcode prompt if necessary
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSString *)stringForKey:(NSString *)key promptMessage:(nullable NSString *)message;

/**
 *  Fetches a NSData from the Keychain
 *
 *  @param key     the key of the value to fetch
 *  @param message prompt message to display for TouchID/passcode prompt if necessary
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key promptMessage:(nullable NSString *)message;

/**
 *  Fetches a NSData from the Keychain
 *
 *  @param key     the key of the value to fetch
 *  @param message prompt message to display for TouchID/passcode prompt if necessary
 *  @param err     Returns an error, if the item cannot be retrieved. F.e. item not found 
 *                 or user authentication failed in TouchId case.
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key promptMessage:(nullable NSString *)message error:(NSError **)err;

/**
 *  Checks if a key has a value in the Keychain
 *
 *  @param key the key to check if it has a value
 *
 *  @return if the key has an associated value in the Keychain or not.
 */
- (BOOL)hasValueForKey:(NSString *)key;


/**
 *  Fetches an array of NSString containing all the keys used in the Keychain
 *
 *  @return a NSString array with all keys from the Keychain.
 */
- (nonnull NSArray *)keys;

///---------------------------------------------------
/// @name Create helper methods
///---------------------------------------------------

/**
 *  Creates a new instance of `A0SimpleKeychain`
 *
 *  @return a new instance
 */
+ (A0SimpleKeychain *)keychain;

/**
 *  Creates a new instance of `A0SimpleKeychain` with a service name.
 *
 *  @param service name of the service under all items will be stored.
 *
 *  @return a new instance
 */
+ (A0SimpleKeychain *)keychainWithService:(NSString *)service;

/**
 *  Creates a new instance of `A0SimpleKeychain` with a service name and access group
 *
 *  @param service     name of the service under all items will be stored.
 *  @param accessGroup name of the access group to share Keychain items.
 *
 *  @return a new instance
 */
+ (A0SimpleKeychain *)keychainWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end

NS_ASSUME_NONNULL_END
