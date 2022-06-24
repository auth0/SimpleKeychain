fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios pod_lint

```sh
[bundle exec] fastlane ios pod_lint
```

Cocoapods library lint

### ios ci

```sh
[bundle exec] fastlane ios ci
```

Runs all the tests in a CI environment

### ios release

```sh
[bundle exec] fastlane ios release
```

Tags the release and pushes the Podspec to CocoaPods

### ios build_docs

```sh
[bundle exec] fastlane ios build_docs
```

Generate API documentation

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
