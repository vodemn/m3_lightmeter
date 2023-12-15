# Screenshots

The easiest way to create several sets of identical screenshots for Android and iOS is to generate them instead of taking them manually. Generating screenshots will save time and effort while also providing a consistent output.

## Context

As a user I want to see the most relevant screenshots in the store, so that I can see the actual state of the app.

## Screenshot cases

- Metering screen

  1. Reflected light metering mode*
  2. Incident light metering mode* **
  3. Opened ISO picker

- Settings screen

  1. Just the screen
  2. Opened metering screen layout features dialog

- Equipment profiles screen

  1. Just the screen
  2. Opened equipment profile ISO picker

> *also in dark mode

> **Android only

## Run the generator

```console
sh screenshots/generate_screenshots.sh
```

Screenshots will be stored in the _screenshots/_ folder.
