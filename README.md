# SimpleKeychain

![CircleCI](https://img.shields.io/circleci/project/github/auth0/SimpleKeychain.svg?style=flat)
![Version](https://img.shields.io/cocoapods/v/SimpleKeychain.svg?style=flat)
![Coverage Status](https://img.shields.io/codecov/c/github/auth0/SimpleKeychain/master.svg?style=flat)
![License](https://img.shields.io/github/license/Auth0/SimpleKeychain.svg?style=flat)

Easily store your user's credentials in the Keychain. Supports sharing credentials with an **access group** or through **iCloud**, and integrating **Touch ID / Face ID**.

**Migrating from 0.x? Check the [Migration Guide](V1_MIGRATION_GUIDE.md).**

---

## Table of Contents

- [**Requirements**](#requirements)
- [**Installation**](#installation)
  + [Swift Package Manager](#swift-package-manager)
  + [Cocoapods](#cocoapods)
  + [Carthage](#carthage)
- [**Usage**](#usage)
  + [Store a string or data item](#store-a-string-or-data-item)
  + [Check if an item is stored](#check-if-an-item-is-stored)
  + [Retrieve a string item](#retrieve-a-string-item)
  + [Retrieve a data item](#retrieve-a-data-item)
  + [Retrieve the keys of all stored items](#retrieve-the-keys-of-all-stored-items)
  + [Remove an item](#remove-an-item)
  + [Remove all items](#remove-all-items)
  + [Error handling](#error-handling)
- [**Configuration**](#configuration)
  + [Include additional attributes](#include-additional-attributes)
  + [Share items with other apps and extensions using an access group](#share-items-with-other-apps-and-extensions-using-an-access-group)
  + [Share items with other devices through iCloud synchronization](#share-items-with-other-devices-through-icloud-synchronization)
  + [Restrict item accessibility based on device state](#restrict-item-accessibility-based-on-device-state)
  + [Require Touch ID / Face ID to retrieve an item](#require-touch-id--face-id-to-retrieve-an-item)
- [**Support Policy**](#support-policy)
- [**Issue Reporting**](#issue-reporting)
- [**What is Auth0?**](#what-is-auth0)
- [**License**](#license)

## Requirements

- iOS 12.0+ / macOS 10.15+ / tvOS 12.0+ / watchOS 6.2+
- Xcode 13.x / 14.x
- Swift 5.x

> ⚠️ Check the [Support Policy](#support-policy) to learn when dropping Xcode, Swift, and platform versions will not be considered a **breaking change**.

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

**See all the available features in the [API documentation ↗](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain/)**

```swift
let simpleKeychain = SimpleKeychain()
```

You can specify a service name under which to save items. By default the bundle identifier of your app is used.

```swift
let simpleKeychain = SimpleKeychain(service: "Auth0")
```

### Store a string or data item

```swift
try simpleKeychain.set(accessToken, forKey: "auth0-access-token")
```

### Check if an item is stored

```swift
let isStored = try simpleKeychain.hasItem(forKey: "auth0-access-token")
```

### Retrieve a string item

```swift
let accessToken = try simpleKeychain.string(forKey: "auth0-access-token")
```

### Retrieve a data item

```swift
let accessToken = try simpleKeychain.data(forKey: "auth0-credentials")
```

### Retrieve the keys of all stored items

```swift
let keys = try simpleKeychain.keys()
```

### Remove an item

```swift
try simpleKeychain.deleteItem(forKey: "auth0-access-token")
```

### Remove all items

```swift
try simpleKeychain.deleteAll()
```

### Error handling

All methods will throw a `SimpleKeychainError` upon failure.

```swift
catch let error as SimpleKeychainError {
    print(error)
}
```

## Configuration

### Include additional attributes

When creating the SimpleKeychain instance, specify additional attributes to be included in every query.

```swift
let attributes = [kSecUseDataProtectionKeychain as String: true]
let simpleKeychain = SimpleKeychain(attributes: attributes)
```

### Share items with other apps and extensions using an access group

When creating the SimpleKeychain instance, specify the access group that the app may share entries with.

```swift
let simpleKeychain = SimpleKeychain(accessGroup: "ABCDEFGH.com.example.myaccessgroup")
```

> 💡 For more information on access group sharing, see [Sharing Access to Keychain Items Among a Collection of Apps](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps).

### Share items with other devices through iCloud synchronization

When creating the SimpleKeychain instance, set `synchronizable` to `true` to enable iCloud synchronization.

```swift
let simpleKeychain = SimpleKeychain(sychronizable: true)
```

> 💡 For more information on iCloud synchronization, check the [kSecAttrSynchronizable documentation](https://developer.apple.com/documentation/security/ksecattrsynchronizable).

### Restrict item accessibility based on device state

When creating the SimpleKeychain instance, specify a custom accesibility value to be used. The default value is `.afterFirstUnlock`.

```swift
let simpleKeychain = SimpleKeychain(accessibility: .whenUnlocked)
```

> 💡 For more information on accessibility, see [Restricting Keychain Item Accessibility](https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility).

### Require Touch ID / Face ID to retrieve an item

When creating the SimpleKeychain instance, specify the access control flags to be used. You can also include an `LAContext` instance with your Touch ID / Face ID configuration.

```swift
let context = LAContext()
context.touchIDAuthenticationAllowableReuseDuration = 10
let simpleKeychain = SimpleKeychain(accessControlFlags: .biometryCurrentSet,
                                    context: context)
```

> 💡 For more information on access control, see [Restricting Keychain Item Accessibility](https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility).

## Support Policy

This Policy defines the extent of the support for Xcode, Swift, and platform (iOS, macOS, tvOS, and watchOS) versions in SimpleKeychain.

### Xcode

The only supported versions of Xcode are those that can be currently used to submit apps to the App Store. Once a Xcode version becomes unsupported, dropping it from SimpleKeychain **will not be considered a breaking change**, and will be done in a **minor** release.

### Swift

The minimum supported Swift minor version is the one released with the oldest-supported Xcode version. Once a Swift minor becomes unsupported, dropping it from SimpleKeychain **will not be considered a breaking change**, and will be done in a **minor** release.

### Platforms

Only the last 4 major platform versions are supported, starting from:

- iOS **12**
- macOS **10.15**
- Catalyst **13**
- tvOS **12**
- watchOS **6.2**

Once a platform version becomes unsupported, dropping it from SimpleKeychain **will not be considered a breaking change**, and will be done in a **minor** release. For example, iOS 12 will cease to be supported when iOS 16 gets released, and SimpleKeychain will be able to drop it in a minor release.

In the case of macOS, the yearly named releases are considered a major platform version for the purposes of this Policy, regardless of the actual version numbers.

## Issue Reporting

For general support or usage questions, use the [Auth0 Community](https://community.auth0.com/c/sdks/5) forums or raise a [support ticket](https://support.auth0.com/). Only [raise an issue](https://github.com/auth0/SimpleKeychain/issues) if you have found a bug or want to request a feature.

**Do not report security vulnerabilities on the public GitHub issue tracker.** The [Responsible Disclosure Program](https://auth0.com/responsible-disclosure-policy) details the procedure for disclosing security issues.

## What is Auth0?

Auth0 helps you to:

- Add authentication with [multiple sources](https://auth0.com/docs/authenticate/identity-providers), either social identity providers such as **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce** (amongst others), or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS, or any SAML identity provider**.
- Add authentication through more traditional **[username/password databases](https://auth0.com/docs/authenticate/database-connections/custom-db)**.
- Add support for **[linking different user accounts](https://auth0.com/docs/manage-users/user-accounts/user-account-linking)** with the same user.
- Support for generating signed [JSON web tokens](https://auth0.com/docs/secure/tokens/json-web-tokens) to call your APIs and **flow the user identity** securely.
- Analytics of how, when, and where users are logging in.
- Pull data from other sources and add it to the user profile through [JavaScript Actions](https://auth0.com/docs/customize/actions).

**Why Auth0?** Because you should save time, be happy, and focus on what really matters: building your product.

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

[Go up ⤴](#table-of-contents)
