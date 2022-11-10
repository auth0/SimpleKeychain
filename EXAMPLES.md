# Examples

- [Use a custom service name](#use-a-custom-service-name)
- [Include additional attributes](#include-additional-attributes)
- [Share items with other apps and extensions using an access group](#share-items-with-other-apps-and-extensions-using-an-access-group)
- [Share items with other devices through iCloud synchronization](#share-items-with-other-devices-through-icloud-synchronization)
- [Restrict item accessibility based on device state](#restrict-item-accessibility-based-on-device-state)
- [Require Touch ID / Face ID to retrieve an item](#require-touch-id--face-id-to-retrieve-an-item)

---

## Use a custom service name

When creating the SimpleKeychain instance, specify a service name under which to save items. By default the bundle identifier of your app is used.

```swift
let simpleKeychain = SimpleKeychain(service: "Auth0")
```

## Include additional attributes

When creating the SimpleKeychain instance, specify additional attributes to be included in every query.

```swift
let attributes = [kSecUseDataProtectionKeychain as String: true]
let simpleKeychain = SimpleKeychain(attributes: attributes)
```

## Share items with other apps and extensions using an access group

When creating the SimpleKeychain instance, specify the access group that the app may share entries with.

```swift
let simpleKeychain = SimpleKeychain(accessGroup: "ABCDEFGH.com.example.myaccessgroup")
```

> **Note**
> For more information on access group sharing, see [Sharing Access to Keychain Items Among a Collection of Apps](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps).

## Share items with other devices through iCloud synchronization

When creating the SimpleKeychain instance, set `synchronizable` to `true` to enable iCloud synchronization.

```swift
let simpleKeychain = SimpleKeychain(sychronizable: true)
```

> **Note**
> For more information on iCloud synchronization, check the [kSecAttrSynchronizable documentation](https://developer.apple.com/documentation/security/ksecattrsynchronizable).

## Restrict item accessibility based on device state

When creating the SimpleKeychain instance, specify a custom accesibility value to be used. The default value is `.afterFirstUnlock`.

```swift
let simpleKeychain = SimpleKeychain(accessibility: .whenUnlocked)
```

> **Note**
> For more information on accessibility, see [Restricting Keychain Item Accessibility](https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility).

## Require Touch ID / Face ID to retrieve an item

When creating the SimpleKeychain instance, specify the access control flags to be used. You can also include an `LAContext` instance with your Touch ID / Face ID configuration.

```swift
let context = LAContext()
context.touchIDAuthenticationAllowableReuseDuration = 10
let simpleKeychain = SimpleKeychain(accessControlFlags: .biometryCurrentSet,
                                    context: context)
```

> **Note**
> For more information on access control, see [Restricting Keychain Item Accessibility](https://developer.apple.com/documentation/security/keychain_services/keychain_items/restricting_keychain_item_accessibility).

---

[Go up ⤴](#examples)
