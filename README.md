<img src="resources/social_preview.png" width="100%" />

# Table of contents

- [Table of contents](#table-of-contents)
- [Backstory](#backstory)
- [Screenshots](#screenshots)
- [Development](#development)
- [Contribution](#contribution)
- [iOS Limitations](#ios-limitations)

# Backstory

Some time ago I've started developing the [Material Lightmeter](https://play.google.com/store/apps/details?id=com.vodemn.lightmeter&hl=en&gl=US) app. Unfortunately, the last update of this app was almost a year prior to creation of this repo. So after reading some positive review on Google Play saying that "this is an excellent app, too bad it is no longer updated", I've decided to make an update and also make this app open source. Maybe someone sometime will decide to contribute to this project.

But as the existing repo contained some sensitive data, that I've pushed due to lack of experience, I had to make a new one. And if creating a new repo, why not rewrite the app from scratch?

Without further delay behold my new Lightmeter app inspired by Material You (a.k.a. M3)

# Screenshots

<p float="center">
  <img src="https://lh3.googleusercontent.com/8Sd-pmNcQ0xAr5opuTeJKWr2OXeQvCoFSdVDSoKQSHHKeNmqF71hqeAdm3yjunY12zY" width="18.8%" />
  <img src="https://lh3.googleusercontent.com/rqBv8pT0AdcBy0xEgQY2unV-YEQ5KfUkandAxJ62yYCiSF72HClA_tkb4JT_3UPaIfFP" width="18.8%" />
  <img src="https://lh3.googleusercontent.com/-SnYbYSugVfdwYi6m_rd9CzpCZMCIfudhnq0zRIlzEtLSXhrwziWVd2hotygfqiSofI" width="18.8%" />
  <img src="https://lh3.googleusercontent.com/UXxptL_dAIJDtrmpEZuSz39Iq4HuPb3ZPeuANfE9XH0De0uZQT83LNdu1AObBPobpg" width="18.8%" />
  <img src="https://lh3.googleusercontent.com/15g_SPV8knDLFbz1_-wGNJFsJeyVWZ_y--TGHpk75MaaIdMDyTXY2_TL-Aw8bpOhpw" width="18.8%" />
</p>

# Development

### 1. Install Flutter

To build this app you need to install Flutter 3.10.0 stable. [How to install](https://docs.flutter.dev/get-started/install).

### 2. (Optional) Install Firebase

Out of the box Firebase Crashlytics won't work. If you want to add Crashlytics to your local build please follow [this guide](https://firebase.google.com/docs/flutter/setup).

### 3. Get packages

Fetch all the neccessary dependencies and generate translation files by running the following commands:
```console
flutter pub get
flutter pub run intl_utils:generate
```

### 4. Build

You can build an apk by running the following command from the root of the repository:
```console
flutter build apk --release --flavor $FLAVOR --dart-define cameraPreviewAspectRatio=2/3 -t lib/main_$FLAVOR.dart
```
Just replace `$FLAVOR` with `dev` or `prod`.

# Contribution

To report a bug or suggest a new feature open a new [issue](https://github.com/vodemn/m3_lightmeter/issues).

In case you want to help develop this project feel free to open a Pull Request, but you need to follow this [style guide](doc/style_guide.md).

# iOS Limitations

A list of features, that Android version of the app has and that iOS does not.

## Incident light metering

Apple does not provide API for reading Lux stream form the ambient light sensor. Lux can be calculated based on front camera image stream, but this would be a reflected light. So there is no way incident light metering can be implemented on iOS.

## Volume buttons action

This can be [implemented](https://stackoverflow.com/questions/70161271/ios-override-hardware-volume-buttons-same-as-zello) but the app will be rejected due to [2.5.9](https://developer.apple.com/app-store/review/guidelines/#software-requirements)