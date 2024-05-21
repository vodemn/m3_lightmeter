# Screenshots

The easiest way to create several sets of identical screenshots for Android and iOS is to generate them instead of taking them manually. Generating screenshots will save time and effort while also providing a consistent output.

## Context

As a user I want to see the most relevant screenshots in the store, so that I can see the actual state of the app.

## Screenshot cases

- Metering screen

  1. Reflected light metering mode\*
  2. Incident light metering mode\* \*\*
  3. Opened ISO picker

- Settings screen

  1. Just the screen

- Equipment profiles screen

  1. Just the screen
  2. Opened equipment profile ISO picker

- Timer screen

  1. Just the screen

> \*also in dark mode

> \*\*Android only

## Run the generator

Release screenshots will be stored in the _screenshots/generated/\<platform\>/_ folder.

Raw screenshots will be stored in the _screenshots/generated/raw/\<platform\>/_ folder.

### Generate raw screenshots

#### Android

```console
sh screenshots/generate_android_screenshots.sh
```

#### iOS

Apple requires screenshots a specific list of devices, so we can implement a custom generator to cover all those devices.

Can be run on Simulator.

```console
sh screenshots/generate_ios_screenshots.sh
```

### Apply store constraints and text data

```console
sh screenshots/scripts/convert_to_store_screenshots.sh
```

## List of devices

### Android

- Pixel 6

### iOS

- iPhone 13 Pro
- iPad Pro (12.9-inch) (6th generation)
