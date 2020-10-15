fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios dependencies
```
fastlane ios dependencies
```
Installs dependencies using Carthage
### ios bootstrap
```
fastlane ios bootstrap
```
Bootstrap the development environment
### ios test
```
fastlane ios test
```
Runs all the tests
### ios ci
```
fastlane ios ci
```
Runs all the tests in a CI environment
### ios pod_lint
```
fastlane ios pod_lint
```
Cocoapods library lint
### ios release
```
fastlane ios release
```
Releases the library to Cocoapods & Github Releases and updates README/CHANGELOG

You need to specify the type of release with the `bump` parameter with the values [major|minor|patch]

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
