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
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios createLocalSnapshots
```
fastlane ios createLocalSnapshots
```
Runs the UI and Unit tests ignoring the test failures just to create local non device agnostic screenshot.

Enforces creating all snapshots by automatically overriding the record flag.

This is the manual counterpart to the CI lane 'createUITestSnapshots'.
### ios deleteSnapshots
```
fastlane ios deleteSnapshots
```
Deletes the snapshot reference images folder.
### ios createUnitTestImages
```
fastlane ios createUnitTestImages
```
Runs the Unit tests ignoring the test failures just to create local screenshot.

Enforces creating all snapshots by automatically overriding the record flag.
### ios createUITestImages
```
fastlane ios createUITestImages
```
Runs the UI tests ignoring the test failures just to create local screenshot.

Enforces creating all snapshots by automatically overriding the record flag.
### ios createUITestSnapshots
```
fastlane ios createUITestSnapshots
```
Runs the UI and Unit tests ignoring the test failures just to create screenshot and pushing them to origin.

Enforces creating all snapshots by automatically overriding the record and deviceAgnostic flag.

CI lane, changes the project's signing.
### ios startTestsInfo
```
fastlane ios startTestsInfo
```
Posts a slack message to inform about start of the build and test pipeline.
### ios build
```
fastlane ios build
```
Builds the Makula target for debug and release.

CI lane, changes the project's signing.
### ios unitTests
```
fastlane ios unitTests
```
Runs the Unit tests in the simulator.

CI lane, changes the project's signing.
### ios uiTests
```
fastlane ios uiTests
```
Runs the UI tests in the simulator.

CI lane, changes the project's signing.
### ios lint
```
fastlane ios lint
```
Lints the project.

CI lane, changes the project's signing.
### ios release
```
fastlane ios release
```
Deploy a new version to the App Store for the client

CI lane, changes the project's signing.
### ios prepare
```
fastlane ios prepare
```
Imports the signing certificate and provisioning profiles if needed

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
