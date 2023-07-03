<p align="center">
  <img src="assets/launcher_icon_circle.png" width="100" height="100">
</p>
<p align="center", style="font-size:60px;">
  <b>Material Lightmeter</b>
</p>

# Table of contents

- [Table of contents](#table-of-contents)
- [Backstory](#backstory)
- [Build](#build)
- [Contribution](#contribution)
- [iOS Limitations](#ios-limitations)

# Backstory

Some time ago I've started developing the [Material Lightmeter](https://play.google.com/store/apps/details?id=com.vodemn.lightmeter&hl=en&gl=US) app. Unfortunately, the last update of this app was almost a year prior to creation of this repo. So after reading some positive review on Google Play saying that "this is an excellent app, too bad it is no longer updated", I've decided to make an update and also make this app open source. Maybe someone sometime will decide to contribute to this project.

But as the existing repo contained some sensitive data, that I've pushed due to lack of experience, I had to make a new one. And if creating a new repo, why not rewrite the app from scratch?)

Without further delay behold my new Lightmeter app inspired by Material You (a.k.a. M3)

# Build

As part of this project is private, you will be able to run this app from the _main_dev.dart_ file (i.e. --flavor dev). Also to avoid fatal errors the _main_prod.dart_ file is excluded from analysis.

# Contribution

To report a bug or suggest a new feature open a new [issue](https://github.com/vodemn/m3_lightmeter/issues).

In case you want to help develop this project you need to follow this [style guide](doc/style_guide.md).

# iOS Limitations

A list of features, that Android version of the app has and that iOS does not.

## Incident light metering
Apple does not provide API for reading Lux stream form the ambient light sensor. Lux can be calculated based on front camera image stream, but this would be a reflected light. So there is no way incident light metering can be implemented on iOS.

## Volume buttons action
This can be [implemented](https://stackoverflow.com/questions/70161271/ios-override-hardware-volume-buttons-same-as-zello) but the app will be rejected due to [2.5.9](https://developer.apple.com/app-store/review/guidelines/#software-requirements)