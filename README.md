![SimpleKeychain](https://cdn.auth0.com/website/sdks/banners/simplekeychain-banner.png)

![Version](https://img.shields.io/cocoapods/v/SimpleKeychain.svg?style=flat)
[![CircleCI](https://img.shields.io/circleci/project/github/auth0/SimpleKeychain.svg?style=flat)](https://circleci.com/gh/auth0/SimpleKeychain/tree/master)
[![Coverage Status](https://img.shields.io/codecov/c/github/auth0/SimpleKeychain/master.svg?style=flat)](https://codecov.io/github/auth0/SimpleKeychain)
![License](https://img.shields.io/github/license/auth0/SimpleKeychain.svg?style=flat)

📚 [**Documentation**](#documentation) • 🚀 [**Getting Started**](#getting-started) • 📃 [**Support Policy**](#support-policy) • 💬 [**Feedback**](#feedback)

Migrating from 0.x? Check the [Migration Guide](V1_MIGRATION_GUIDE.md).

## Documentation

- [**Examples**](EXAMPLES.md) - explains how to use more advanced features.
- [**API Documentation**](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain) - documentation auto-generated from the code comments that explains all the available features.
  + [SimpleKeychain](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain/simplekeychain)
  + [Accessibility](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain/accessibility)
  + [SimpleKeychainError](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain/simplekeychainerror)
- [**Auth0 Documentation**](https://auth0.com/docs) - explore our docs site and learn more about Auth0.

## Getting Started

### Requirements

- iOS 12.0+ / macOS 10.15+ / tvOS 12.0+ / watchOS 6.2+
- Xcode 13.x / 14.x
- Swift 5.x

> **Note**
> Check the [Support Policy](#support-policy) to learn when dropping Xcode, Swift, and platform versions will not be considered a **breaking change**.

### Installation

#### Swift Package Manager

Open the following menu item in Xcode:

**File > Add Packages...**

In the **Search or Enter Package URL** search box enter this URL: 

```text
https://github.com/auth0/SimpleKeychain
```

Then, select the dependency rule and press **Add Package**.

#### Cocoapods

Add the following line to your `Podfile`:

```ruby
pod 'SimpleKeychain', '~> 1.0'
```

Then, run `pod install`.

#### Carthage

Add the following line to your `Cartfile`:

```text
github "auth0/SimpleKeychain" ~> 1.0
```

Then, run `carthage bootstrap --use-xcframeworks`.

### Usage

**Learn about more advanced features in [Examples ↗](EXAMPLES.md)**

**See all the available features in the [API documentation ↗](https://auth0.github.io/SimpleKeychain/documentation/simplekeychain)**

```swift
let simpleKeychain = SimpleKeychain()
```

You can specify a service name under which to save items. By default the bundle identifier of your app is used.

```swift
let simpleKeychain = SimpleKeychain(service: "Auth0")
```

#### Store a string or data item

```swift
try simpleKeychain.set(accessToken, forKey: "auth0-access-token")
```

#### Check if an item is stored

```swift
let isStored = try simpleKeychain.hasItem(forKey: "auth0-access-token")
```

#### Retrieve a string item

```swift
let accessToken = try simpleKeychain.string(forKey: "auth0-access-token")
```

#### Retrieve a data item

```swift
let accessToken = try simpleKeychain.data(forKey: "auth0-credentials")
```

#### Retrieve the keys of all stored items

```swift
let keys = try simpleKeychain.keys()
```

#### Remove an item

```swift
try simpleKeychain.deleteItem(forKey: "auth0-access-token")
```

#### Remove all items

```swift
try simpleKeychain.deleteAll()
```

#### Error handling

All methods will throw a `SimpleKeychainError` upon failure.

```swift
catch let error as SimpleKeychainError {
    print(error)
}
```

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
- macCatalyst **13**
- tvOS **12**
- watchOS **6.2**

Once a platform version becomes unsupported, dropping it from SimpleKeychain **will not be considered a breaking change**, and will be done in a **minor** release. For example, iOS 13 will cease to be supported when iOS 17 gets released, and SimpleKeychain will be able to drop it in a minor release.

In the case of macOS, the yearly named releases are considered a major platform version for the purposes of this Policy, regardless of the actual version numbers.

## Feedback

### Contributing

We appreciate feedback and contribution to this repo! Before you get started, please see the following:

- [Auth0's general contribution guidelines](https://github.com/auth0/open-source-template/blob/master/GENERAL-CONTRIBUTING.md)
- [Auth0's code of conduct guidelines](https://github.com/auth0/open-source-template/blob/master/CODE-OF-CONDUCT.md)
- [SimpleKeychain's contribution guide](CONTRIBUTING.md)

### Raise an issue

To provide feedback or report a bug, please [raise an issue on our issue tracker](https://github.com/auth0/SimpleKeychain/issues).

### Vulnerability reporting

Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/responsible-disclosure-policy) details the procedure for disclosing security issues.

---

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
    <source media="(prefers-color-scheme: dark)" srcset="https://cdn.auth0.com/website/sdks/logos/auth0_dark_mode.png" width="150">
    <img alt="Auth0 Logo" src="https://cdn.auth0.com/website/sdks/logos/auth0_light_mode.png" width="150">
  </picture>
</p>

<p align="center">Auth0 is an easy to implement, adaptable authentication and authorization platform. To learn more checkout <a href="https://auth0.com/why-auth0">Why Auth0?</a></p>

<p align="center">This project is licensed under the MIT license. See the <a href="./LICENSE"> LICENSE</a> file for more info.</p>
