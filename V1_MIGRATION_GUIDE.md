# v1 Migration Guide

As expected with a major release, SimpleKeychain v1 contains breaking changes. Please review this guide thorougly to understand the changes required to migrate your application to v1.

## Table of Contents

- [**Supported Languages**](#supported-languages)
- [**Supported Platform Versions**](#supported-platform-versions)
- [**Methods Removed**](#methods-removed)

## Supported Languages

## Supported Platform Versions

The deployment targets for each platform were raised to:

- iOS **12.0**
- macOS **10.15**
- tvOS **12.0**
- watchOS **6.2**

## Properties Changed

The `defaultAccessiblity` property was renamed to `defaultAccessibility`.

## Enum Cases Removed

The following cases were removed from the `A0SimpleKeychainItemAccessible` enum:

- `A0SimpleKeychainItemAccessibleAlways`
- `A0SimpleKeychainItemAccessibleAlwaysThisDeviceOnly`

## Methods Removed

The method `publicRSAKeyData(forTag:)` was removed.
