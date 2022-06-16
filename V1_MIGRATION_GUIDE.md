# v1 Migration Guide

As expected with a major release, SimpleKeychain v1 contains breaking changes. Please review this guide thorougly to understand the changes required to migrate your application to v1.

---

## Table of Contents

- [**Supported Languages**](#supported-languages)
  + [Objective-C](#objective-c)
- [**Supported Platform Versions**](#supported-platform-versions)
- [**Types Removed**](#types-removed)
- [**Properties Removed**](#properties-removed)
  + [SimpleKeychain Struct](#simplekeychain-struct)
- [**Methods Removed**](#methods-removed)
  + [SimpleKeychain Struct](#simplekeychain-struct-1)
- [**Types Changed**](#types-changed)
- [**Method Signatures Changed**](#method-signatures-changed)
  + [SimpleKeychain Struct](#simplekeychain-struct-2)
- [**Behavior Changes**](#behavior-changes)
  + [SimpleKeychain Struct](#simplekeychain-struct-3)

## Supported Languages

### Objective-C

SimpleKeychain no longer supports Objective-C.

## Supported Platform Versions

The deployment targets for each platform were raised to:

- iOS **12.0**
- macOS **10.15**
- tvOS **12.0**
- watchOS **6.2**

## Types Removed

- The `A0SimpleKeychainError` enum was removed in favor of the new `SimpleKeychainError` enum.
- The `A0SimpleKeychainItemAccessible` enum was removed in favor of the new `Accessibility` enum.
- The `A0ErrorDomain` macro was removed.
- The `A0LocalAuthenticationCapable` macro was removed.

## Properties removed

### SimpleKeychain Struct

- The property `defaultAccessiblity` was removed in favor of the new `accessibility` initalizer parameter.

<!-- BEFORE/AFTER -->

- The property `useAccessControl` was removed in favor of the new `accessControlFlags` initializer parameter.

<!-- BEFORE/AFTER -->

- The property `localAuthenticationContext` was removed in favor of the new `context` initializer parameter.

The following properties are no longer public:

- `service`
- `accessGroup`

## Methods Removed

### SimpleKeychain Struct

The `setTouchIDAuthenticationAllowableReuseDuration` method was removed. Configure that in a custom `LAContext` instance instead.

<!-- BEFORE/AFTER -->

The following methods were removed and have no replacement:

- `publicRSAKeyData(forTag:)`
- `generateRSAKeyPair(withLength:publicKeyTag:privateKeyTag:)`
- `dataForRSAKey(withTag:)`
- `keyRefOfRSAKey(withTag:)`
- `deleteRSAKey(withTag:)`
- `hasRSAKey(withTag:)`

<!-- BEFORE/AFTER -->

## Types Changed

`A0SimpleKeychain` was renamed to `SimpleKeychain`, and was changed from class to struct.

## Method Signatures Changed

### SimpleKeychain Struct

All the methods now **throw** a `SimpleKeychainError` when the operation fails.

#### Methods renamed

| Old                    | New                   |
|:-----------------------|:----------------------|
| `setString(forKey:)`   | `set(_:forKey:)`      |
| `setData(forKey:)`     | `set(_:forKey:)`      |
| `hasValue(forKey:)`    | `hasItem(forKey:)`    |
| `deleteEntry(forKey:)` | `deleteItem(forKey:)` |
| `clearAll()`           | `deleteAll()`         |

#### Parameters removed

The `promptMessage` parameter was removed from the following methods, as `kSecUseOperationPrompt` [is deprecated](https://developer.apple.com/documentation/security/ksecuseoperationprompt):

- `string(forKey:)`
- `data(forKey:)`
- `set(_:forKey:)`

Configure the message in a custom `LAContext` instance instead, using the `LAContext.localizedReason` property.

<!-- BEFORE/AFTER -->

The `error` parameter was removed from the `data(forKey:)` method, as it now throws a `SimpleKeychainError`. 

<!-- BEFORE/AFTER -->

## Behavior Changes

### SimpleKeychain Struct

- `kSecUseAuthenticationUI` is no longer used. Configure if the user should be prompted for authentication in a custom `LAContext` instance instead, using the `LAContext.interactionNotAllowed` property.
- The `hasItem(forKey:)` method no longer retuns `false` whenever any error occurs. Now it only returns `false` when the error is `errSecItemNotFound`.

---

[Go up ⤴](#table-of-contents)
