# Contributing

We appreciate feedback and contribution to SimpleKeychain! Before you get started, please read the following:

- [Auth0's general contribution guidelines](https://github.com/auth0/open-source-template/blob/master/GENERAL-CONTRIBUTING.md)
- [Auth0's code of conduct](https://github.com/auth0/open-source-template/blob/master/CODE-OF-CONDUCT.md)

> ⚠️ Tests must be added for all new functionality. Existing tests must be updated for all changed/fixed functionality, where applicable. All tests must complete without errors. All new functionality must be documented as well.

## Environment setup

We use [Carthage](https://github.com/Carthage/Carthage) to manage SimpleKeychain's dependencies. 

1. Clone this repository and enter its root directory.
2. Run `carthage bootstrap --use-xcframeworks` to fetch and build the dependencies.
3. Open `SimpleKeychain.xcodeproj` in Xcode.
