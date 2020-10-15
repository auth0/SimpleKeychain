# SimpleKeychain

[![CircleCI](https://img.shields.io/circleci/project/github/auth0/SimpleKeychain.svg?style=flat-square)](https://circleci.com/gh/auth0/SimpleKeychain/tree/master)
[![Coverage Status](https://img.shields.io/codecov/c/github/auth0/SimpleKeychain/master.svg?style=flat-square)](https://codecov.io/github/auth0/SimpleKeychain)
[![Version](https://img.shields.io/cocoapods/v/SimpleKeychain.svg?style=flat-square)](https://cocoapods.org/pods/SimpleKeychain)
[![License](https://img.shields.io/cocoapods/l/SimpleKeychain.svg?style=flat-square)](https://cocoapods.org/pods/SimpleKeychain)
[![Platform](https://img.shields.io/cocoapods/p/SimpleKeychain.svg?style=flat-square)](https://cocoapods.org/pods/SimpleKeychain)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fauth0%2FSimpleKeychain.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fauth0%2FSimpleKeychain?ref=badge_shield)

A wrapper to make it really easy to deal with iOS Keychain and store your user's credentials securely.

## Key Features

- **Simple interface** to store user's credentials (e.g. JWT) in the Keychain.
- Store credentials under an **Access Group to enable Keychain Sharing**.
- **TouchID/FaceID integration** with a reusable `LAContext` instance. 

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [What is Auth0?](#what-is-auth0)
- [Create a Free Auth0 Account](#create-a-free-auth0-account)
- [Issue Reporting](#issue-reporting)
- [Author](#author)
- [License](#license)

## Requirements

- iOS 9.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 11.4+ / Xcode 12.x
- Swift 4.x/5.x

## Installation

### CocoaPods

If you are using [Cocoapods](https://cocoapods.org), add this line to your `Podfile`:

```ruby
pod "SimpleKeychain"
```

Then run `pod install`.

> For more information on Cocoapods, check [their official documentation](https://guides.cocoapods.org/using/getting-started.html).

### Carthage

If you are using [Carthage](https://github.com/Carthage/Carthage), add the following line to your `Cartfile`:

```ruby
github "auth0/SimpleKeychain"
```

Then run `carthage bootstrap`.

> For more information about Carthage usage, check [their official documentation](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

#### SPM (Xcode 11.2+)

If you are using the Swift Package Manager, open the following menu item in Xcode:

**File > Swift Packages > Add Package Dependency...**

In the **Choose Package Repository** prompt add this url: 

```
https://github.com/auth0/SimpleKeychain.git
```

Then, press **Next** and complete the remaining steps.

> For more information on SPM, check [its official documentation](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Usage

### Save a JWT token or password

```swift
let jwt = // user's JWT token obtained after login
A0SimpleKeychain().setString(jwt, forKey: "auth0-user-jwt")
```

### Obtain a JWT token or password

```swift
let jwt = A0SimpleKeychain().string(forKey: "auth0-user-jwt")
```

### Share a JWT Token with other apps using iOS Access Group

```swift
let jwt = // user's JWT token obtained after login
let keychain = A0SimpleKeychain(service: "Auth0", accessGroup: "ABCDEFGH.com.mydomain.myaccessgroup")
keychain.setString(jwt, forKey: "auth0-user-jwt")
```

### Store and retrieve a JWT token using TouchID/FaceID

Let's save the JWT first:

```swift
let jwt = // user's JWT token obtained after login
let keychain = A0SimpleKeychain()
keychain.useAccessControl = true
keychain.defaultAccessiblity = .whenPasscodeSetThisDeviceOnly
keychain.setTouchIDAuthenticationAllowableReuseDuration(5.0)
keychain.setString(jwt, forKey: "auth0-user-jwt")
```

> If there is an existent value under the key `auth0-user-jwt` saved with AccessControl and `A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly`, iOS will prompt the user to enter their passcode or fingerprint before updating the value.

Then let's obtain the value:

```swift
let message = NSLocalizedString("Please enter your passcode/fingerprint to login with awesome App!.", comment: "Prompt TouchID message")
let keychain = A0SimpleKeychain()
let jwt = keychain.string(forKey: "auth0-user-jwt", promptMessage: message)
```

### Remove a JWT token or password

```swift
A0SimpleKeychain().deleteEntry(forKey: "auth0-user-jwt")
```

## Contributing

Just clone the repo, run `carthage bootstrap` and you're ready to contribute!

## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple sources](https://auth0.com/docs/identityproviders), either social identity providers such as **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce** (amongst others), or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS, or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://auth0.com/docs/connections/database/custom-db)**.
* Add support for **[linking different user accounts](https://auth0.com/docs/link-accounts)** with the same user.
* Support for generating signed [JSON Web Tokens](https://auth0.com/docs/tokens/concepts/jwts) to call your APIs and **flow the user identity** securely.
* Analytics of how, when, and where users are logging in.
* Pull data from other sources and add it to the user profile through [JavaScript rules](https://auth0.com/docs/rules).

## Create a Free Auth0 Account

1. Go to [Auth0](https://auth0.com) and click **Sign Up**.
2. Use Google, GitHub, or Microsoft Account to login.

## Issue Reporting

If you have found a bug or to request a feature, please [raise an issue](https://github.com/auth0/simplekeychain/issues). Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/responsible-disclosure-policy) details the procedure for disclosing security issues.

## Author

[Auth0](https://auth0.com)

## License

This project is licensed under the MIT license. See the [LICENSE](https://github.com/auth0/SimpleKeychain/blob/master/LICENSE) file for more info.


[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fauth0%2FSimpleKeychain.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fauth0%2FSimpleKeychain?ref=badge_large)
