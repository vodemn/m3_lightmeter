<img src="resources/social_preview.png" width="100%" />

![](https://github.com/vodemn/m3_lightmeter/actions/workflows/pr_check.yml/badge.svg)
![](https://github.com/vodemn/m3_lightmeter/actions/workflows/create_release.yml/badge.svg)

# Table of contents

- [Table of contents](#table-of-contents)
- [Backstory](#backstory)
- [Screenshots](#screenshots)
- [Development](#development)
- [Support](#support)
- [iOS Limitations](#ios-limitations)

# Backstory

Some time ago I've started developing the [Material Lightmeter](https://play.google.com/store/apps/details?id=com.vodemn.lightmeter&hl=en&gl=US) app. Unfortunately, the last update of this app was almost a year prior to creation of this repo. So after reading some positive review on Google Play saying that "this is an excellent app, too bad it is no longer updated", I've decided to make an update and also make this app open source. Maybe someone sometime will decide to contribute to this project.

But as the existing repo contained some sensitive data, that I've pushed due to lack of experience, I had to make a new one. And if creating a new repo, why not rewrite the app from scratch?

Without further delay behold my new Lightmeter app inspired by Material You (a.k.a. M3)

# Screenshots

<p float="center">
  <img src="screenshots/generated/android/android/light_metering-reflected.png" width="18.8%" />
  <img src="screenshots/generated/android/android/light_settings.png" width="18.8%" />
  <img src="screenshots/generated/android/android/light_timer.png" width="18.8%" />
  <img src="screenshots/generated/android/android/light_equipment-profiles.png" width="18.8%" />
  <img src="screenshots/generated/android/android/dark_metering-reflected.png" width="18.8%" />
</p>

# Development

### 1. Install Flutter

To build this app you need to install Flutter 3.13.9 stable. [How to install](https://docs.flutter.dev/get-started/install).

### 2. Project setup

#### Restore _constants.dart_ file

Create a file _lib/constants.dart_ and paste the following content:

```dart
const String contactEmail = '';
const String iapServerUrl = '';
const String issuesReportUrl = '';
const String sourceCodeUrl = '';
```

#### Stub IAP package

As part of the app's functionallity is in the private repo, you have to replace these lines in _pubspec.yaml_:

```yaml
m3_lightmeter_iap:
  git:
    url: "https://github.com/vodemn/m3_lightmeter_iap"
    ref: main
```

with these:

```yaml
m3_lightmeter_iap:
  path: iap
```

You can do it simply by running the script:

```console
sh .github/scripts/stub_iap.sh
```

> If you are using VSCode, you can open the workspace like so: _File -> Open Workspace from File -> m3_lightmeter.code-workspace_. Otherwise you have to run `flutter pub get` command from the iap folder.

Then you can fetch all the neccessary dependencies and generate translation files by running the following commands:

```console
flutter pub get
flutter pub run intl_utils:generate
```

### 3. (Optional) Install Firebase

Out of the box Firebase Crashlytics won't work. If you want to add Crashlytics to your local build please follow [this guide](https://firebase.google.com/docs/flutter/setup).

### 4. Build

- Checkout [Build .apk](.github/workflows/build_apk.yml) workflow for Android
- Checkout [Build .ipa](.github/workflows/build_ipa.yml) workflow for iOS

# Support

To report a bug or suggest a new feature open a new [issue](https://github.com/vodemn/m3_lightmeter/issues). To contribute to the project feel free to open a Pull Request, but you need to follow this [style guide](doc/style_guide.md).

In case you have any other questions please contact me via [email](mailto:contact.vodemn@gmail.com?subject="Lightmeter").

# iOS Limitations

A list of features, that Android version of the app has and that iOS does not.

## Incident light metering

Apple does not provide API for reading Lux stream form the ambient light sensor. Lux can be calculated based on front camera image stream, but this would be a reflected light. So there is no way incident light metering can be implemented on iOS.

## Volume buttons action

This can be [implemented](https://stackoverflow.com/questions/70161271/ios-override-hardware-volume-buttons-same-as-zello) but the app will be rejected due to [2.5.9](https://developer.apple.com/app-store/review/guidelines/#software-requirements)
