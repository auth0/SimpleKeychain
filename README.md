# SimpleKeychain

[![CI Status](http://img.shields.io/travis/auth0/SimpleKeychain.svg?style=flat-square)](https://travis-ci.org/auth0/SimpleKeychain)
[![Version](https://img.shields.io/cocoapods/v/SimpleKeychain.svg?style=flat-square)](http://cocoadocs.org/docsets/SimpleKeychain)
[![License](https://img.shields.io/cocoapods/l/SimpleKeychain.svg?style=flat-square)](http://cocoadocs.org/docsets/SimpleKeychain)
[![Platform](https://img.shields.io/cocoapods/p/SimpleKeychain.svg?style=flat-square)](http://cocoadocs.org/docsets/SimpleKeychain)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

A wrapper to make it really easy to deal with iOS Keychain and store your user's credentials securely.

## Key Features

- **Simple interface** to store user's credentials (e.g. JWT) in the Keychain.
- Store credentials under an **Access Group to enable Keychain Sharing**.
- Support for **iOS 8 Access Control** for fine grained access control. _(Only for iOS 8+)_
- **TouchID and Keychain integration** with iOS 8 new accessibility field `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`. _(Only for iOS 8+)_

## Requirements

At least iOS 7, if you want to use `kSecAttrAccessControl` with the flag `useAccessControl` you need to have iOS 8+.

## Installation

### CocoaPods

SimpleKeychain is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SimpleKeychain"
```

Or you can add `A0SimpleKeychain.h` and `A0SimpleKeychain.m` to your project.

### Carthage

In your Cartfile add

```ruby
github "auth0/SimpleKeychain"
```

## Before Getting Started

### Objective-C
Just import in your source file's header:

```objc
#import <SimpleKeychain/SimpleKeychain.h>
```

### Swift
Import Lock module in your swift file:

```swift
import SimpleKeychain
```

## Usage

### Save a JWT token or password

```objc
NSString *jwt = //user's JWT token obtained after login
[[A0SimpleKeychain keychain] setString:jwt forKey:@"auth0-user-jwt"];
```

```swift
let jwt = //user's JWT token obtained after login
A0SimpleKeychain().setString(jwt, forKey:"auth0-user-jwt")
```

### Obtain a JWT token or password

```objc
NSString *jwt = [[A0SimpleKeychain keychain] stringForKey:@"auth0-user-jwt"];
```

```swift
let jwt = A0SimpleKeychain().string(forKey: "auth0-user-jwt")
```

### Share JWT Token with other apps using iOS Access Group

```objc
NSString *jwt = //user's JWT token obtained after login
A0SimpleKeychain *keychain = [A0SimpleKeychain keychainWithService:@"Auth0" accessGroup:@"ABCDEFGH.com.mydomain.myaccessgroup"];
[keychain setString:jwt forKey:@"auth0-user-jwt"];
```

```swift
let jwt = //user's JWT token obtained after login
let keychain = A0SimpleKeychain(service: "Auth0", accessGroup: "ABCDEFGH.com.mydomain.myaccessgroup")
keychain.setString(jwt, forKey:"auth0-user-jwt")
```

### Store and retrieve JWT token using TouchID and Keychain AcessControl attribute (iOS 8 Only).

Let's save the JWT first:
```objc
NSString *jwt = //user's JWT token obtained after login
A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
keychain.useAccessControl = YES;
keychain.defaultAccessiblity = A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly;
[keychain setString:jwt forKey:@"auth0-user-jwt"];
```

```swift
let jwt = //user's JWT token obtained after login
let keychain = A0SimpleKeychain()
keychain.useAccessControl = true
keychain.defaultAccessiblity = .whenPasscodeSetThisDeviceOnly
keychain.setString(jwt, forKey:"auth0-user-jwt")
```

> If there is an existent value under the key `auth0-user-jwt` saved with AccessControl and `A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly`, iOS will prompt the user to enter their passcode or fingerprint before updating the value.

Then let's obtain the value

```objc
NSString *message = NSLocalizedString(@"Please enter your passcode/fingerprint to login with awesome App!.", @"Prompt TouchID message");
A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
NSString *jwt = [keychain stringForKey:@"auth0-user-jwt" promptMessage:message];
```

```swift
let message = NSLocalizedString("Please enter your passcode/fingerprint to login with awesome App!.", comment: "Prompt TouchID message")
let keychain = A0SimpleKeychain()
let jwt = keychain.string(forKey: "auth0-user-jwt", promptMessage:message)
```

### Remove a JWT token or password
```objc
[[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-user-jwt"];
```

```swift
A0SimpleKeychain().deleteEntry(forKey: "auth0-user-jwt")
```

## Contributing

Just clone the repo, and run pod install from the Example directory and you're ready to contribute!.

## Issue Reporting

If you have found a bug or if you have a feature request, please report them at this repository issues section. Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/whitehat) details the procedure for disclosing security issues.

## License

SimpleKeychain is available under the MIT license. See the [LICENSE file]([LICENSE file](https://github.com/auth0/SimpleKeychain/blob/master/LICENSE)) for more info.

## Author

[Auth0](https://auth0.com)

## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple authentication sources](https://docs.auth0.com/identityproviders), either social like **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce, amont others**, or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://docs.auth0.com/mysql-connection-tutorial)**.
* Add support for **[linking different user accounts](https://docs.auth0.com/link-accounts)** with the same user.
* Support for generating signed [Json Web Tokens](https://docs.auth0.com/jwt) to call your APIs and **flow the user identity** securely.
* Analytics of how, when and where users are logging in.
* Pull data from other sources and add it to the user profile, through [JavaScript rules](https://docs.auth0.com/rules).

## Create a free account in Auth0

1. Go to [Auth0](https://auth0.com) and click Sign Up.
2. Use Google, GitHub or Microsoft Account to login.
