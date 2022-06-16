# v1 Migration Guide

As expected with a major release, SimpleKeychain v1 contains breaking changes. Please review this guide thorougly to understand the changes required to migrate your application to v1.

## Table of Contents

- [**Supported Languages**](#supported-languages)
  + [Objective-C](#objective-c)
- [**Supported Platform Versions**](#supported-platform-versions)
- [**Types Changed**](#types-changed)
- [**Method Signatures Changed**](#method-signatures-changed)
- [**Types Removed**](#types-removed)
- [**Properties Removed**](#properties-removed)
- [**Methods Removed**](#methods-removed)

## Supported Languages

### Objective-C

Auth0.swift no longer supports Objective-C.

## Supported Platform Versions

The deployment targets for each platform were raised to:

- iOS **12.0**
- macOS **10.15**
- tvOS **12.0**
- watchOS **6.2**

## Types Changed

`A0SimpleKeychain` was renamed to `SimpleKeychain`.

## Method Signatures Changed

| Old                    | New                   |
|:-----------------------|:----------------------|
| `setString(forKey:)`   | `set(_:forKey:)`      |
| `setData(forKey:)`     | `set(_:forKey:)`      |
| `deleteEntry(forKey:)` | `deleteItem(forKey:)` |
| `clearAll()`           | `deleteAll()`         |
| `hasValue(forKey:)`    | `hasItem(forKey:)`    |

## Types Removed

The `A0SimpleKeychainItemAccessible` enum was removed in favor of the new `SimpleKeychain.Accessibility` enum.

## Properties removed

- The property `defaultAccessiblity` was removed in favor of the `accessibility` parameter in the `SimpleKeychain` initializer.

<!-- BEFORE/AFTER -->

- The property `useAccessControl` was removed in favor of the `accessControlFlags` parameter in the `SimpleKeychain` initializer.

<!-- BEFORE/AFTER -->

## Methods Removed

The `setTouchIDAuthenticationAllowableReuseDuration` method was removed. You should configure that in a custom `LAContext` instance.

<!-- BEFORE/AFTER -->

The following methods were removed and have no replacement:

- `publicRSAKeyData(forTag:)`
- `generateRSAKeyPair(withLength:publicKeyTag:privateKeyTag:)`
- `dataForRSAKey(withTag:)`
- `keyRefOfRSAKey(withTag:)`
- `deleteRSAKey(withTag:)`
- `hasRSAKey(withTag:)`

<!-- BEFORE/AFTER -->
