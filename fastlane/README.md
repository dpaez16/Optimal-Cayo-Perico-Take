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
### ios tests
```
fastlane ios tests
```
Runs unit tests and UI tests
### ios coverage
```
fastlane ios coverage
```
Code coverage
### ios beta
```
fastlane ios beta
```
Uploads beta app to testflight
### ios build_ipa_file
```
fastlane ios build_ipa_file
```
Make IPA file

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
