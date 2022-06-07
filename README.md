# SimpleKeychain

![CircleCI](https://img.shields.io/circleci/project/github/auth0/SimpleKeychain.svg?style=flat)
![Version](https://img.shields.io/cocoapods/v/SimpleKeychain.svg?style=flat)
![Coverage Status](https://img.shields.io/codecov/c/github/auth0/SimpleKeychain/master.svg?style=flat)
![License](https://img.shields.io/github/license/Auth0/SimpleKeychain.svg?style=flat)

Easily store your user's credentials in the Keychain. Supports sharing credentials with an **Access Group** and integrating **Touch ID / Face ID** with a reusable `LAContext` instance.

> ⚠️ This library is currently in **First Availability**. We do not recommend using this library in production yet. As we move towards General Availability, please be aware that releases may contain breaking changes.

**Migrating from 0.x? Check the [Migration Guide](V1_MIGRATION_GUIDE.md).**

---

## Table of Contents

- [**Requirements**](#requirements)
- [**Installation**](#installation)
  + [Swift Package Manager](#swift-package-manager)
  + [Cocoapods](#cocoapods)
  + [Carthage](#carthage)
- [**Usage**](#usage)
  + [Save an entry](#save-an-entry)
  + [Retrieve an entry](#retrieve-an-entry)
  + [Remove an entry](#remove-an-entry)
  + [Remove all entries](#remove-all-entries)
  + [Require Touch ID / Face ID to retrieve an entry](#require-touch-id--face-id-to-retrieve-an-entry)
  + [Share entries with other apps and extensions using an Access Group](#share-entries-with-other-apps-and-extensions-using-an-access-group)
- [**Issue Reporting**](#issue-reporting)
- [**What is Auth0?**](#what-is-auth0)
- [**License**](#license)

## Requirements

- iOS 12.0+ / macOS 10.15+ / tvOS 12.0+ / watchOS 6.2+
- Xcode 13.x
- Swift 5.x

## Installation

### Swift Package Manager

Open the following menu item in Xcode:

**File > Add Packages...**

In the **Search or Enter Package URL** search box enter this URL: 

```text
https://github.com/auth0/SimpleKeychain
```

Then, select the dependency rule and press **Add Package**.

> 💡 For further reference on SPM, check its [official documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).

### Cocoapods

Add the following line to your `Podfile`:

```ruby
pod 'SimpleKeychain', '~> 1.0'
```

Then, run `pod install`.

> 💡 For further reference on Cocoapods, check their [official documentation](https://guides.cocoapods.org/using/getting-started.html).

### Carthage

Add the following line to your `Cartfile`:

```text
github "auth0/SimpleKeychain" ~> 1.0
```

Then, run `carthage bootstrap --use-xcframeworks`.

> 💡 For further reference on Carthage, check their [official documentation](https://github.com/Carthage/Carthage#getting-started).

## Usage

```swift
let keychain = A0SimpleKeychain()
```

### Save an entry

```swift
keychain.setString(accessToken, forKey: "auth0-access-token")
```

### Retrieve an entry

```swift
let accessToken = keychain.string(forKey: "auth0-access-token")
```

### Remove an entry

```swift
keychain.deleteEntry(forKey: "auth0-access-token")
```

### Remove all entries

This is useful for testing.

```swift
keychain.clearAll()
```

### Require Touch ID / Face ID to retrieve an entry

First, configure the SimpleKeychain instance to use Face ID / Touch ID.

```swift
keychain.useAccessControl = true
keychain.defaultAccessiblity = .whenPasscodeSetThisDeviceOnly
keychain.setTouchIDAuthenticationAllowableReuseDuration(5.0)
```

When retrieving an entry, specify a prompt message for Face ID / Touch ID.

```swift
let message = NSLocalizedString("Please enter your passcode or fingerprint to login with Awesome App!", comment: "Prompt message")
let accessToken = keychain.string(forKey: "auth0-access-token", promptMessage: message)
```

### Share entries with other apps and extensions using an Access Group

When creating the SimpleKeychain instance, specify the Access Group that the app may share entries with.

```swift
let keychain = A0SimpleKeychain(service: "Auth0", accessGroup: "ABCDEFGH.com.example.myaccessgroup")
keychain.setString(accessToken, forKey: "auth0-access-token")
```

## Issue Reporting

For general support or usage questions, use the [Auth0 Community](https://community.auth0.com/c/sdks/5) forums or raise a [support ticket](https://support.auth0.com/). Only [raise an issue](https://github.com/auth0/SimpleKeychain/issues) if you have found a bug or want to request a feature.

**Do not report security vulnerabilities on the public GitHub issue tracker.** The [Responsible Disclosure Program](https://auth0.com/responsible-disclosure-policy) details the procedure for disclosing security issues.

## What is Auth0?

Auth0 helps you to:

- Add authentication with [multiple sources](https://auth0.com/docs/authenticate/identity-providers), either social identity providers such as **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce** (amongst others), or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS, or any SAML Identity Provider**.
- Add authentication through more traditional **[username/password databases](https://auth0.com/docs/authenticate/database-connections/custom-db)**.
- Add support for **[linking different user accounts](https://auth0.com/docs/manage-users/user-accounts/user-account-linking)** with the same user.
- Support for generating signed [JSON Web Tokens](https://auth0.com/docs/secure/tokens/json-web-tokens) to call your APIs and **flow the user identity** securely.
- Analytics of how, when, and where users are logging in.
- Pull data from other sources and add it to the user profile through [JavaScript Actions](https://auth0.com/docs/customize/actions).

**Why Auth0?** Because you should save time, be happy, and focus on what really matters: building your product.

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

[Go up ⤴](#table-of-contents)
