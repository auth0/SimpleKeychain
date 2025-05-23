# Change Log

## [1.3.0](https://github.com/auth0/SimpleKeychain/tree/1.3.0) (2025-03-14)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/1.2.0...1.3.0)

**Added**
- feat: add `errSecMissingEntitlement` error [\#224](https://github.com/auth0/SimpleKeychain/pull/224) ([grdsdev](https://github.com/grdsdev))
- Add `Sendable` conformance [\#235](https://github.com/auth0/SimpleKeychain/pull/235) ([Widcket](https://github.com/Widcket))

## [1.2.0](https://github.com/auth0/SimpleKeychain/tree/1.2.0) (2024-09-16)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/1.1.0...1.2.0)

**Added**
- feat: added support for visionOS platform [\#215](https://github.com/auth0/SimpleKeychain/pull/215) ([desusai7](https://github.com/desusai7))

**Changed**
- Update Platforms Support Policy in README [\#198](https://github.com/auth0/SimpleKeychain/pull/198) ([Widcket](https://github.com/Widcket))

## [1.2.0-beta.0](https://github.com/auth0/SimpleKeychain/tree/1.2.0-beta.0) (2024-07-02)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/1.1.0...1.2.0-beta.0)

**Added**
- feat: added support for visionOS platform [\#215](https://github.com/auth0/SimpleKeychain/pull/215) ([desusai7](https://github.com/desusai7))
- Add GitHub Actions workflow [SDK-4458] [\#186](https://github.com/auth0/SimpleKeychain/pull/186) ([Widcket](https://github.com/Widcket))

**Changed**
- Remove CircleCI config and related Fastlane lanes [SDK-4458] [\#187](https://github.com/auth0/SimpleKeychain/pull/187) ([Widcket](https://github.com/Widcket))

**Fixed**
- test: migrated from Quick & Nimble to use XCTest to remove dependency on third party packages [\#213](https://github.com/auth0/SimpleKeychain/pull/213) ([desusai7](https://github.com/desusai7))
- Improve GH Actions workflows [\#192](https://github.com/auth0/SimpleKeychain/pull/192) ([Widcket](https://github.com/Widcket))
- Reduce permissions of GH actions and limit its triggers [\#189](https://github.com/auth0/SimpleKeychain/pull/189) ([Widcket](https://github.com/Widcket))

## [1.1.0](https://github.com/auth0/SimpleKeychain/tree/1.1.0) (2023-06-14)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/1.0.1...1.1.0)

**Removed**
- Drop support for iOS 12, tvOS 12, macOS 10.15, watch0S < 7, and Xcode 13 [\#184](https://github.com/auth0/SimpleKeychain/pull/184) ([Widcket](https://github.com/Widcket))

## [1.0.1](https://github.com/auth0/SimpleKeychain/tree/1.0.1) (2022-09-14)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/1.0.0...1.0.1)

**Fixed**
- Fix Xcode 14 tvOS builds [\#170](https://github.com/auth0/SimpleKeychain/pull/170) ([yanniks](https://github.com/yanniks))

## [1.0.0](https://github.com/auth0/SimpleKeychain/tree/1.0.0) (2022-07-20)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.5...1.0.0)

[Migration Guide](V1_MIGRATION_GUIDE.md)

**⚠️ BREAKING CHANGES**
- Drop support for old Swift versions [SDK-3444] [\#141](https://github.com/auth0/SimpleKeychain/pull/141) ([Widcket](https://github.com/Widcket))
- Migrate to Swift [SDK-3428] [\#139](https://github.com/auth0/SimpleKeychain/pull/139) ([Widcket](https://github.com/Widcket))
- Remove obsolete functionality [SDK-3419] [\#136](https://github.com/auth0/SimpleKeychain/pull/136) ([Widcket](https://github.com/Widcket))
- Remove usage of deprecated properties [SDK-3414] [\#133](https://github.com/auth0/SimpleKeychain/pull/133) ([Widcket](https://github.com/Widcket))
- Remove deprecated method [SDK-3413] [\#132](https://github.com/auth0/SimpleKeychain/pull/132) ([Widcket](https://github.com/Widcket))
- Drop old platform versions [SDK-3387] [\#129](https://github.com/auth0/SimpleKeychain/pull/129) ([Widcket](https://github.com/Widcket))

**Added**
- Add support for custom attributes [\#153](https://github.com/auth0/SimpleKeychain/pull/153) ([Widcket](https://github.com/Widcket))
- Add support for iCloud synchronization [SDK-3453] [\#146](https://github.com/auth0/SimpleKeychain/pull/146) ([Widcket](https://github.com/Widcket))
- Added keys method [\#125](https://github.com/auth0/SimpleKeychain/pull/125) ([asclepix](https://github.com/asclepix))

**Changed**
- Replace OSX with macOS in schemes and targets [\#154](https://github.com/auth0/SimpleKeychain/pull/154) ([Widcket](https://github.com/Widcket))
- Apply recommended Xcode 14 settings [\#143](https://github.com/auth0/SimpleKeychain/pull/143) ([Widcket](https://github.com/Widcket))

## [1.0.0-fa](https://github.com/auth0/SimpleKeychain/tree/1.0.0-fa) (2022-06-24)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.5...1.0.0-fa)

[Migration Guide](V1_MIGRATION_GUIDE.md)

**⚠️ BREAKING CHANGES**
- Drop support for old Swift versions [SDK-3444] [\#141](https://github.com/auth0/SimpleKeychain/pull/141) ([Widcket](https://github.com/Widcket))
- Migrate to Swift [SDK-3428] [\#139](https://github.com/auth0/SimpleKeychain/pull/139) ([Widcket](https://github.com/Widcket))
- Remove obsolete functionality [SDK-3419] [\#136](https://github.com/auth0/SimpleKeychain/pull/136) ([Widcket](https://github.com/Widcket))
- Remove usage of deprecated properties [SDK-3414] [\#133](https://github.com/auth0/SimpleKeychain/pull/133) ([Widcket](https://github.com/Widcket))
- Remove deprecated method [SDK-3413] [\#132](https://github.com/auth0/SimpleKeychain/pull/132) ([Widcket](https://github.com/Widcket))
- Drop old platform versions [SDK-3387] [\#129](https://github.com/auth0/SimpleKeychain/pull/129) ([Widcket](https://github.com/Widcket))

**Added**
- Add support for custom attributes [\#153](https://github.com/auth0/SimpleKeychain/pull/153) ([Widcket](https://github.com/Widcket))
- Add support for iCloud synchronization [SDK-3453] [\#146](https://github.com/auth0/SimpleKeychain/pull/146) ([Widcket](https://github.com/Widcket))

**Changed**
- Replace OSX with macOS in schemes and targets [\#154](https://github.com/auth0/SimpleKeychain/pull/154) ([Widcket](https://github.com/Widcket))
- Apply recommended Xcode 14 settings [\#143](https://github.com/auth0/SimpleKeychain/pull/143) ([Widcket](https://github.com/Widcket))

## [0.12.5](https://github.com/auth0/SimpleKeychain/tree/0.12.5) (2021-09-30)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.4...0.12.5)

**Changed**
- Updated dependencies [\#116](https://github.com/auth0/SimpleKeychain/pull/116) ([Widcket](https://github.com/Widcket))

## [0.12.4](https://github.com/auth0/SimpleKeychain/tree/0.12.4) (2021-08-24)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.3...0.12.4)

**Security**
- Update Addressable to v2.8.0 [\#111](https://github.com/auth0/SimpleKeychain/pull/111) ([Widcket](https://github.com/Widcket))

## [0.12.3](https://github.com/auth0/SimpleKeychain/tree/0.12.3) (2021-06-07)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.2...0.12.3)

**Changed**
- Make test dependencies not resolve when installing with SPM [SDK-2598] [\#108](https://github.com/auth0/SimpleKeychain/pull/108) ([Widcket](https://github.com/Widcket))

## [0.12.2](https://github.com/auth0/SimpleKeychain/tree/0.12.2) (2021-02-11)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.1...0.12.2)

**Fixed**
- Fixed Mac Catalyst warnings related to deprecated accessibility options [\#105](https://github.com/auth0/SimpleKeychain/pull/105) ([eaceto](https://github.com/eaceto))

## [0.12.1](https://github.com/auth0/SimpleKeychain/tree/0.12.1) (2020-10-19)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.12.0...0.12.1)

**Fixed**
- Fixed macOS version check on Big Sur [\#99](https://github.com/auth0/SimpleKeychain/pull/99) ([Widcket](https://github.com/Widcket))

## [0.12.0](https://github.com/auth0/SimpleKeychain/tree/0.12.0) (2020-10-15)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.11.1...0.12.0)

**Changed**
- Updated Quick and Nimble [\#97](https://github.com/auth0/SimpleKeychain/pull/97) ([Widcket](https://github.com/Widcket))

## [0.11.1](https://github.com/auth0/SimpleKeychain/tree/0.11.1) (2020-03-26)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.11.0...0.11.1)

**Fixed**
- Disabled LAContext attribute in simulator [SDK-1476] [\#91](https://github.com/auth0/SimpleKeychain/pull/91) ([Widcket](https://github.com/Widcket))

## [0.11.0](https://github.com/auth0/SimpleKeychain/tree/0.11.0) (2020-02-27)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.10.0...0.11.0)

**Changed**
- Marked up A0SimpleKeychain+KeyPair to admit that keys may not exist [\#86](https://github.com/auth0/SimpleKeychain/pull/86) ([cysp](https://github.com/cysp))

**Fixed**
- Fixed A0LocalAuthenticationCapable macro [\#81](https://github.com/auth0/SimpleKeychain/pull/81) ([Widcket](https://github.com/Widcket))

## [0.10.0](https://github.com/auth0/SimpleKeychain/tree/0.10.0) (2020-02-05)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.9.0...0.10.0)

**Added**
- Swift Package Manager support [\#75](https://github.com/auth0/SimpleKeychain/pull/75) ([StuClift](https://github.com/StuClift))

**Changed**
- Reused LocalAuthentication context [\#74](https://github.com/auth0/SimpleKeychain/pull/74) ([eaceto](https://github.com/eaceto))

## [0.9.0](https://github.com/auth0/SimpleKeychain/tree/0.9.0) (2019-04-23)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.8.1...0.9.0)

**Changed**
- Update Swift 5 / Xcode 10.2 [\#66](https://github.com/auth0/SimpleKeychain/pull/66) ([cocojoe](https://github.com/cocojoe))

## [0.8.1](https://github.com/auth0/SimpleKeychain/tree/0.8.1) (2018-04-30)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.8.0...0.8.1)

**Added**
- Added Circle CI 2.0 [\#51](https://github.com/auth0/SimpleKeychain/pull/51) ([cocojoe](https://github.com/cocojoe))

**Changed**
- Update dependencies [\#49](https://github.com/auth0/SimpleKeychain/pull/49) ([cocojoe](https://github.com/cocojoe))

**Fixed**
- Fix Pod Lib Lint Warnings [\#48](https://github.com/auth0/SimpleKeychain/pull/48) ([Y2JChamp](https://github.com/Y2JChamp))

## [0.8.0](https://github.com/auth0/SimpleKeychain/tree/0.8.0) (2017-06-06)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.7.0...0.8.0)

**Added**
- Added tvOS and watchOS platform support [\#43](https://github.com/auth0/SimpleKeychain/pull/43) ([cocojoe](https://github.com/cocojoe))
- Xcode 8.3 Compatibility [\#42](https://github.com/auth0/SimpleKeychain/pull/42) ([cocojoe](https://github.com/cocojoe))

**Changed**
- Fix Xcode warnings [\#45](https://github.com/auth0/SimpleKeychain/pull/45) ([hzalaz](https://github.com/hzalaz))

## [0.7.0](https://github.com/auth0/SimpleKeychain/tree/0.7.0) (2016-01-20)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.6.1...0.7.0)

**Closed issues:**

- Always getting "Error trying to access to non available kSecUseOperationPrompt in iOS7" log [\#24](https://github.com/auth0/SimpleKeychain/issues/24)
- Default accessiblity should be kSecAttrAccessibleWhenUnlockedThisDeviceOnly [\#17](https://github.com/auth0/SimpleKeychain/issues/17)

**Merged pull requests:**

- Update default accessibility [\#26](https://github.com/auth0/SimpleKeychain/pull/26) ([tupakapoor](https://github.com/tupakapoor))
- Only show ios7 error message when attempting to use access control [\#25](https://github.com/auth0/SimpleKeychain/pull/25) ([tupakapoor](https://github.com/tupakapoor))

## [0.6.1](https://github.com/auth0/SimpleKeychain/tree/0.6.1) (2015-10-29)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.6.0...0.6.1)

## [0.6.0](https://github.com/auth0/SimpleKeychain/tree/0.6.0) (2015-10-29)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.5.0...0.6.0)

**Merged pull requests:**

- Avoid iOS7 kSecUseOperationPrompt crash [\#23](https://github.com/auth0/SimpleKeychain/pull/23) ([elkraneo](https://github.com/elkraneo))
- Add nullability annotations [\#22](https://github.com/auth0/SimpleKeychain/pull/22) ([hzalaz](https://github.com/hzalaz))
- Build with Xcode 7 [\#21](https://github.com/auth0/SimpleKeychain/pull/21) ([hzalaz](https://github.com/hzalaz))

## [0.5.0](https://github.com/auth0/SimpleKeychain/tree/0.5.0) (2015-08-13)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.4.0...0.5.0)

**Fixed bugs:**

- -\[A0SimpleKeychain queryNewKey:value:\] leaks accessControl [\#18](https://github.com/auth0/SimpleKeychain/issues/18)

**Merged pull requests:**

- Avoid memory leak for access control [\#20](https://github.com/auth0/SimpleKeychain/pull/20) ([hzalaz](https://github.com/hzalaz))
- Carthage support [\#19](https://github.com/auth0/SimpleKeychain/pull/19) ([hzalaz](https://github.com/hzalaz))

## [0.4.0](https://github.com/auth0/SimpleKeychain/tree/0.4.0) (2015-06-05)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.3.0...0.4.0)

**Closed issues:**

- Enhancement: Update to swift 1.2 [\#13](https://github.com/auth0/SimpleKeychain/issues/13)
- Code Errors in Your README. [\#11](https://github.com/auth0/SimpleKeychain/issues/11)
- TouchID does not show up [\#10](https://github.com/auth0/SimpleKeychain/issues/10)

**Merged pull requests:**

- Initialise variable in stringForKey [\#16](https://github.com/auth0/SimpleKeychain/pull/16) ([davidjb](https://github.com/davidjb))
- Fix minor typo in example [\#15](https://github.com/auth0/SimpleKeychain/pull/15) ([davidjb](https://github.com/davidjb))
- Adds OS X as a target. I'm doing this to then have the meteor-ios project also target OS X [\#14](https://github.com/auth0/SimpleKeychain/pull/14) ([mathieutozer](https://github.com/mathieutozer))
- Update README.md [\#12](https://github.com/auth0/SimpleKeychain/pull/12) ([AndyIbanez](https://github.com/AndyIbanez))

## [0.3.0](https://github.com/auth0/SimpleKeychain/tree/0.3.0) (2015-01-15)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.2.2...0.3.0)

**Closed issues:**

- how to disable touch ID dialog [\#8](https://github.com/auth0/SimpleKeychain/issues/8)
- Xcode analysis raises 'nil value' issue [\#7](https://github.com/auth0/SimpleKeychain/issues/7)

**Merged pull requests:**

- TouchId: Determine reason for failed dataForKey: call [\#9](https://github.com/auth0/SimpleKeychain/pull/9) ([Yspadadden](https://github.com/Yspadadden))

## [0.2.2](https://github.com/auth0/SimpleKeychain/tree/0.2.2) (2014-12-10)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.2.1...0.2.2)

**Closed issues:**

- dyld: Symbol not found: \_kSecAttrAccessControl [\#5](https://github.com/auth0/SimpleKeychain/issues/5)

**Merged pull requests:**

- Value stored into 'NSMutableDictionary' cannot be nil [\#6](https://github.com/auth0/SimpleKeychain/pull/6) ([nsarno](https://github.com/nsarno))

## [0.2.1](https://github.com/auth0/SimpleKeychain/tree/0.2.1) (2014-12-04)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.2.0...0.2.1)

**Merged pull requests:**

- Fixed issue with TouchId and hasValueForKey: [\#4](https://github.com/auth0/SimpleKeychain/pull/4) ([Yspadadden](https://github.com/Yspadadden))

## [0.2.0](https://github.com/auth0/SimpleKeychain/tree/0.2.0) (2014-11-01)
[Full Changelog](https://github.com/auth0/SimpleKeychain/compare/0.1.0...0.2.0)

**Merged pull requests:**

- Relative URL Fix [\#2](https://github.com/auth0/SimpleKeychain/pull/2) ([jstart](https://github.com/jstart))

## [0.1.0](https://github.com/auth0/SimpleKeychain/tree/0.1.0) (2014-10-21)
**Merged pull requests:**

- Generate KeyPair in Keychain [\#1](https://github.com/auth0/SimpleKeychain/pull/1) ([hzalaz](https://github.com/hzalaz))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
