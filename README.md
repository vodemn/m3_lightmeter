<p align="center">
  <img src="assets/launcher_icon_circle.png" width="100" height="100">
</p>
<p align="center", style="font-size:60px;">
  <b>Material Lightmeter</b>
</p>

## Backstory

Some time ago I've started developing the [Material Lightmeter](https://play.google.com/store/apps/details?id=com.vodemn.lightmeter&hl=en&gl=US) app. Unfortunately, the last update of this app was almost a year prior to creation of this repo. So after reading some positive review on Google Play saying that "this is an excellent app, too bad it is no longer updated", I've decided to make an update and also make this app open source. Maybe someone sometime will decide to contribute to this project.

But as the existing repo contained some sensitive data, that I've pushed due to lack of experience, I had to make a new one. And if creating a new repo, why not rewrite the app from scratch?)

Without further delay behold my new Lightmeter app inspired by Material You (a.k.a. M3)

## Table of contents

- [Backstory](#backstory)
- [Table of contents](#table-of-contents)
- [Legacy features](#legacy-features)
  - [Metering](#metering)
  - [Adjust](#adjust)
  - [General](#general)
  - [Theme](#theme)
- [Build](#build)

## Legacy features

The list of features that the old lightmeter app has and that have to be implemeneted in the M3 lightmeter.

### Metering
- [x] ISO selecting
- [ ] Reciprocity for different films
- [x] Reflected light metering
- [ ] Incident light metering

### Adjust
- [ ] Light sources EV calibration
- [ ] Customizable aperture range
- [ ] Customizable shutter speed range
- [x] ND filter select

### General
- [ ] Caffeine
- [x] Vibration
- [ ] Volume button actions

### Theme
- [x] Dark theme
- [ ] Picking primary color
- [ ] Russian language

## Build

```
flutter build apk --flavor dev --dart-define cameraPreviewAspectRatio=2/3 -t lib/main_dev.dart
```
