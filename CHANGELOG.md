# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.7.0] - 2022-02-24
- Dark mode support

## [v1.6.0] - 2021-12-07

### Fixed
- Fix crash on RN 0.66

## [v1.5.1] - 2021-11-25

### Changed
- Depend on React-Core in iOS podspec

## [v1.5.0] - 2021-11-18

### Added
- Support Android 11 (API level 30)
- Update Android SDK v1.7.0
- Update iOS SDK v1.6.8

## [v1.4.4] - 2021-10-31

### Fixed
- iOS flag to open login screen on root VC issue with reply to comment
- Android flag to open login screen on root Activity issue with logged in user

### Changed
- Update Android SDK version to 1.6.3
- Update iOS SDK version to 1.6.7

## [v1.4.3] - 2021-10-26

### Added
- Update iOS SDK v1.6.6

### Fixed
- SpotIM component UIViewControllerHierarchyIncosistencyException issue

### Changed
- Sample app improvements - navigation and simulate login

## [v1.4.2] - 2021-10-21

### Fixed
- [Android] Login Screen "hiding" below "Create Comment" instead of on top - flag for open the login screen on the root Activity.

## [v1.4.1] - 2021-10-14

### Fixed
- [iOS] Login Screen "hiding" below "Create Comment" instead of on top - flag for open the login screen on the root VC.


## [v1.4.0] - 2021-10-10

### Fixed
- Analytics event duplications
- Memory leak when re-render SpotIm View
- SpotIm component should be update when changing postId prop

### Changed
- SDK initialization with SpotIMAPI module in root component constructor
- Remove spotId from SpotIm component props
- Android - no need to add android SDK dependency and to initialize the SDK from the native code

## [v1.3.0] - 2021-09-29

- Update iOS SDK v1.6.2
- Update Android SDK v1.6.1
- Analytics Event callback

## [v1.2.1] - 2021-09-12

- Update the react native iOS podspec file with iOS SDK v1.5.13
- Remove Google-Mobile-Ads-SDK dependency from podspec

## [v1.2.0] - 2021-05-27

- Update the react native iOS podspec file with iOS SDK v1.5.4 (move to Xcframework solution)
- Support for Xcode 14.5

## [v1.1.0] - 2021-02-10

- Update the react native iOS podspec file with iOS SDK v1.1.1
- `s.dependency "Google-Mobile-Ads-SDK", '~> 7.69.0'`



## [v1.0.14] - 2020-11-2
- Fixed crash when commiting the pre-conversation fragment after onSaveInstanceState called

## [v1.0.13] - 2020-10-21
### Fixed
- Android height issues
- Android crash when switching fast between screens that contain the SpotIm view
- iOS Crash when API returns an error

[Unreleased]: https://github.com/SpotIM/spotim-react-native-sdk/compare/v1.0.13...master
[1.0.13]: https://github.com/SpotIM/spotim-react-native-sdk/compare/1.0.12...v1.0.13
