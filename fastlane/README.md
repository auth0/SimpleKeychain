fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
### dependencies
```
fastlane dependencies
```
Installs dependencies using Carthage
### bootstrap
```
fastlane bootstrap
```
Bootstrap the development environment
### release
```
fastlane release
```
Releases the library to Cocoapods & Github Releases and updates README/CHANGELOG

You need to specify the type of release with the `bump` parameter with the values [major|minor|patch]

----

## iOS
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

----

## tvos
### tvos test
```
fastlane tvos test
```
Runs all the tests
### tvos ci
```
fastlane tvos ci
```
Runs all the tests in a CI environment

----

## Mac
### mac test
```
fastlane mac test
```
Runs all the tests
### mac ci
```
fastlane mac ci
```
Runs all the tests in a CI environment

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
