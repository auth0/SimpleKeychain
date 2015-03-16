// A0SimpleKeychain.swift
//
// Copyright (c) 2015 Auth0 (http://auth0.com)
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

import Foundation

/**
*  Enum with Kechain items accessibility types. It's a mirror of `kSecAttrAccessible` values.
*/
enum A0SimpleKeychainItemAccessible {
    /**
    *  @see kSecAttrAccessibleWhenUnlocked
    */
    case WhenUnlocked
    /**
    *  @see kSecAttrAccessibleAfterFirstUnlock
    */
    case AfterFirstUnlock
    /**
    *  @see kSecAttrAccessibleAlways
    */
    case Always
    /**
    *  @see kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
    */
    case WhenPasscodeSetThisDeviceOnly
    /**
    *  @see kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    */
    case WhenUnlockedThisDeviceOnly
    /**
    *  kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    */
    case AfterFirstUnlockThisDeviceOnly
    /**
    *  @see kSecAttrAccessibleAlwaysThisDeviceOnly
    */
    case AlwaysThisDeviceOnly
}

/**
* Enum with keychain error codes. It's a mirror of the keychain error codes.
*/
enum A0SimpleKeychainErrorCode: Int {
    /**
    * @see errSecSuccess
    */
    case NoError = 0
    /**
    * @see errSecUnimplemented
    */
    case Unimplemented = -4
    /**
    * @see errSecParam
    */
    case WrongParameter = -50
    /**
    * @see errSecAllocate
    */
    case Allocation = -108
    /**
    * @see errSecNotAvailable
    */
    case NotAvailable = -25291
    /**
    * @see errSecAuthFailed
    */
    case AuthFailed = -25293
    /**
    * @see errSecDuplicateItem
    */
    case DuplicateItem = -25299
    /**
    * @see errSecItemNotFound
    */
    case ItemNotFound = -25300
    /**
    * @see errSecInteractionNotAllowed
    */
    case InteractionNotAllowed = -25308
    /**
    * @see errSecDecode
    */
    case Decode = -26275
}

/**
*  A simple helper class to deal with storing and retrieving values from iOS Keychain.
*  It has support for sharing keychain items using Access Group and also for iOS 8 fine grained accesibility over a specific Kyechain Item (Using Access Control).
*  The support is only available for iOS 8+, otherwise it will default using the coarse grained accesibility field.
*  When a `NSString` or `NSData` is stored using Access Control and the accesibility flag `A0SimpleKeychainItemAccessible.WhenPasscodeSetThisDeviceOnly`, iOS will prompt the user for it's passcode or pass a TouchID challenge (if available).
*/
class A0SimpleKeychain: NSObject {

    private let errorDomain = "com.auth0.simplekeychain"
    private let localizedTableName = "SimpleKeychain"

    /**
    *  Service name under all items are saved. Default value is Bundle Identifier.
    */
    private(set) var service: String

    /**
    *  Access Group for Keychain item sharing. If it's nil no keychain sharing is possible. Default value is nil.
    */
    private(set) var accessGroup: String?

    /**
    *  What type of accessibility the items stored will have. All values are translated to `kSecAttrAccessible` constants.
    *  Default value is A0SimpleKeychainItemAccessibleAfterFirstUnlock.
    *  @see kSecAttrAccessible
    */
    var defaultAccessibility: A0SimpleKeychainItemAccessible
    /**
    *  Tells A0SimpleKeychain to use `kSecAttrAccessControl` instead of `kSecAttrAccessible`. It will work only in iOS 8+, defaulting to `kSecAttrAccessible` on lower version.
    *  Default value is NO.
    */
    var useAccessControl: Bool

    ///---------------------------------------------------
    /// @name Initialization
    ///---------------------------------------------------

    /**
    Creates an instance of A0SimpleKeychain

    :param: service              name of the service.
    :param: accessGroup          name of the access group used for keychain sharing. By default is nil.
    :param: defaultAccessibility default accessibility value for keychain entries. By default is .AfterFirstUnlock.
    :param: useAccessControl     if iOS 8 Access Control feature is used. By default is false.

    :returns: a new instance
    */
    init(service: String? = NSBundle.mainBundle().bundleIdentifier, accessGroup: String? = nil, defaultAccessibility: A0SimpleKeychainItemAccessible = .AfterFirstUnlock, useAccessControl: Bool = false) {
        self.service = service!
        self.accessGroup = accessGroup
        self.defaultAccessibility = defaultAccessibility
        self.useAccessControl = useAccessControl
    }

    ///---------------------------------------------------
    /// @name Store values
    ///---------------------------------------------------

    /**
    Stores a string in the keychain

    :param: string  string value to store
    :param: key     key for the string value
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.

    :returns: if the value was stored successfully
    */
    func setString(string: String, forKey key: String, promptMessage message: String? = nil) -> Bool {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            return setData(data, forKey: key, promptMessage: message)
        }
        return false
    }

    /**
    Stores a NSData in the keychain

    :param: data    data to store
    :param: key     key for the data value
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.

    :returns: if the value was stored successfully
    */
    func setData(data: NSData, forKey key: String, promptMessage message: String? = nil) -> Bool {
        let query = queryFindByKey(key, message: message)
        // Touch ID case
        if (self.useAccessControl && self.defaultAccessibility == .WhenPasscodeSetThisDeviceOnly) {
            // TouchId case. Doesn't support updating keychain items
            // see Known Issues: https://developer.apple.com/library/ios/releasenotes/General/RN-iOSSDK-8.0/
            // We need to delete old and add a new item. This can fail
            let status = SecItemDelete(query)
            if (status == errSecSuccess || status == errSecItemNotFound) {
                return insertItemWithKey(key, value: data)
            }
        }
        let findStatus = SecItemCopyMatching(query, nil)
        if (findStatus == errSecSuccess) {
            return SecItemUpdate(query, queryUpdateValue(data, message: message)) == errSecSuccess
        } else {
            return SecItemAdd(queryNewItemWithKey(key, value: data), nil) == errSecSuccess
        }
    }

    ///---------------------------------------------------
    /// @name Obtain values
    ///---------------------------------------------------

    /**
    Fetch a string value from the keychain. If you are using swift please use stringForKey(key:, promptMessage:) instead.

    :param: key     key of the value to fetch
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.
    :param: error   when an error occurs, an error will be stored here otherwise it will be nil.

    :returns: stored string value or nil
    */
    func stringForKey(key: String, promptMessage message: String? = nil, error: NSErrorPointer) -> String? {
        let result = stringForKey(key, promptMessage: message)
        switch(result) {
        case (let string, nil) where string != nil:
            return string
        case (_, let err):
            if(error != nil) {
                error.memory = err
            }
            return nil
        }
    }

    /**
    Fetch a string value from the keychain

    :param: key     key of the value to fetch
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.

    :returns: a tuple with the string value if successful otherwise with the error
    */
    func stringForKey(key: String, promptMessage message: String? = nil) -> (string: String?, error: NSError?) {
        let result = dataForKey(key, promptMessage: message)
        switch(result) {
        case (let data, nil) where data != nil:
            return (string: NSString(data: data!, encoding: NSUTF8StringEncoding), error: nil)
        case (_, let error):
            return (string: nil, error: error)
        }
    }

    /**
    Fetch a NSData value from the keychain. If you are using swift please use dataForKey(key:, promptMessage:) instead.

    :param: key     key of the value to fetch
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.
    :param: error   when an error occurs, an error will be stored here otherwise it will be nil.

    :returns: stored NSData value or nil
    */
    func dataForKey(key: String, promptMessage message: String? = nil, error: NSErrorPointer) -> NSData? {
        let result = dataForKey(key, promptMessage: message)
        switch (result) {
        case (let data, nil) where data != nil:
            return data;
        case (_, let err):
            if (error != nil) {
                error.memory = err
            }
            return nil
        }
    }

    /**
    Fetch a NSData value from the keychain

    :param: key     key of the value to fetch
    :param: message prompt message displayed if TouchID integration is enabled. By default is nil.

    :returns: a tuple with the NSData value if successful otherwise with the error
    */
    func dataForKey(key: String, promptMessage message: String? = nil) -> (data: NSData?, error: NSError?) {
        let query = querySingleItemByKey(key, message: message)
        var data : Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(query, &data)
        if (status != errSecSuccess) {
            let code = Int(status)
            return (data: nil, error: NSError(domain: errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedErrorFromStatus(status)]))
        }

        return (data: data?.takeUnretainedValue() as? NSData, nil)
    }

    /**
    Check if there is an entry in the keychain with the given key

    :param: key key to find

    :returns: if the entry exists or not
    */
    func hasValueForKey(key: String) -> Bool {
        let query = queryFindByKey(key, message: nil)
        return SecItemCopyMatching(query, nil) == errSecSuccess
    }

    ///---------------------------------------------------
    /// @name Remove values
    ///---------------------------------------------------

    /**
    Removes an entry from the keychain

    :param: key     entry key to remove
    :param: message message displayed to confirm if required

    :returns: if the entry was removed
    */
    func removeValueForKey(key: String, promptMessage message: String? = nil) -> Bool {
        let query = queryFindByKey(key, message: message)
        return SecItemDelete(query) == errSecSuccess
    }

    /**
    Remove all entries from the kechain with the service and access group values.
    */
    func removeAllValues() {
        let query = queryFindAll()
        var result: Unmanaged<AnyObject>?
        let status = SecItemCopyMatching(query, &result)
        if (status == errSecSuccess || status == errSecItemNotFound) {
            if let items = result?.takeUnretainedValue() as? NSArray {
                for item in items {
                    if let dict = item as? NSDictionary {
                        var query = NSDictionary(dictionary: dict)
                        query.setValue(NSString(format:kSecClassGenericPassword), forKey: NSString(format:kSecClass))
                        SecItemDelete(query)
                    }
                }
            }
        }
    }

    // MARK: - Query Builders

    private func insertItemWithKey(key: String, value: NSData) -> Bool {
        let queryNewItem = queryNewItemWithKey(key, value: value)
        let status = SecItemAdd(queryNewItem, nil)
        return status == errSecSuccess
    }

    private func baseQuery() -> [NSString: AnyObject] {
        var attributes = [
            NSString(format: kSecClass): NSString(format: kSecClassGenericPassword),
            NSString(format: kSecAttrService): self.service
        ]
#if !TARGET_IPHONE_SIMULATOR
        if let accessGroupName = self.accessGroup {
            attributes[NSString(format: kSecAttrAccessGroup)] = accessGroupName
        }
#endif
        return attributes
    }

    private func queryFindByKey(key: String, message: String?)  -> [NSString: AnyObject] {
        var query = baseQuery()
        query[NSString(format: kSecAttrAccount)] = key
        if let operationPrompt = message {
            query[NSString(format: kSecUseOperationPrompt)] = operationPrompt
        }
        return query
    }

    private func queryNewItemWithKey(key: String, value: NSData) -> [NSString: AnyObject] {
        var query = baseQuery()
        query[NSString(format:kSecAttrAccount)] = key
        query[NSString(format:kSecValueData)] = value
        if (self.useAccessControl && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            var error: Unmanaged<CFError>?
            var accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility(), .UserPresence, &error)
            if (error == nil || accessControl != nil) {
                query[NSString(format:kSecAttrAccessControl)] = accessControl.takeUnretainedValue()
                query[NSString(format:kSecUseNoAuthenticationUI)] = true
            }
        } else {
            query[NSString(format:kSecAttrAccessible)] = accessibility()
        }
        return query
    }

    private func queryUpdateValue(value: NSData, message: String?) -> [NSString : AnyObject] {
        var query : [NSString : AnyObject] = [
            NSString(format: kSecValueData): value
        ]
        if let promptMessage = message {
            query[NSString(format:kSecUseOperationPrompt)] = promptMessage
        }
        return query
    }

    private func querySingleItemByKey(key: String, message: String?) -> [NSString : AnyObject] {
        var query = baseQuery()
        query[NSString(format:kSecReturnData)] = true
        query[NSString(format:kSecMatchLimit)] = NSString(format: kSecMatchLimitOne)
        query[NSString(format:kSecAttrAccount)] = key
        if let promptMessage = message {
            query[NSString(format:kSecUseOperationPrompt)] = promptMessage
        }
        return query
    }

    private func queryFindAll() -> [NSString : AnyObject] {
        var query = [
            NSString(format:kSecReturnAttributes) : true,
            NSString(format:kSecMatchLimit) : NSString(format:kSecMatchLimitAll)
        ]
        return query;
    }

    //MARK: - Utility methods

    private func accessibility() -> CFTypeRef {
        switch(self.defaultAccessibility) {
        case .AfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .Always:
            return kSecAttrAccessibleAlways
        case .AfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .AlwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly
        case .WhenPasscodeSetThisDeviceOnly:
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) { //iOS 8
                return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
            } else { //iOS <= 7.1
                return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            }
        case .WhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .WhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
    }

    private func localizedErrorFromStatus(status: OSStatus) -> String {
        switch(status) {
        case errSecSuccess:
            return NSLocalizedString("errSecSuccess: No error", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecUnimplemented:
            return NSLocalizedString("errSecUnimplemented: Function or operation not implemented", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecParam:
            return NSLocalizedString("errSecParam: One or more parameters passed to the function were not valid", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecAllocate:
            return NSLocalizedString("errSecAllocate: Failed to allocate memory", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecNotAvailable:
            return NSLocalizedString("errSecNotAvailable: No trust results are available", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecAuthFailed:
            return NSLocalizedString("errSecAuthFailed: Authorization/Authentication failed", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecDuplicateItem:
            return NSLocalizedString("errSecDuplicateItem: The item already exists", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecItemNotFound:
            return NSLocalizedString("errSecItemNotFound: The item cannot be found", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecInteractionNotAllowed:
            return NSLocalizedString("errSecInteractionNotAllowed: Interaction with the Security Server is not allowed", tableName: localizedTableName, comment: "Possible error from keychain.")
        case errSecDecode:
            return NSLocalizedString("errSecDecode: Unable to decode the provided data", tableName: localizedTableName, comment: "Possible error from keychain.")
        default:
            return NSString(format:NSLocalizedString("Unknown error code %d", tableName: localizedTableName, comment: "Possible error from keychain."), status)
        }
    }
}
