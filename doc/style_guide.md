
This repo uses [Effective Dart Style](https://dart.dev/guides/language/effective-dart/style) and [Style guide for Flutter repo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#formatting) with some alterations.

## Table of contents

- [Table of contents](#table-of-contents)
- [Folder structure guidelines](#folder-structure-guidelines)
  - [Inverse file naming](#inverse-file-naming)
  - [Always use a functional prefix in widgets file names](#always-use-a-functional-prefix-in-widgets-file-names)
  - [All files must be grouped according to their function](#all-files-must-be-grouped-according-to-their-function)
  - [Place elements used by one screen in the folder of this screen](#place-elements-used-by-one-screen-in-the-folder-of-this-screen)
  - [Place elements used within one logical group in the _shared_ folder inside this group folder](#place-elements-used-within-one-logical-group-in-the-shared-folder-inside-this-group-folder)
  - [Always place component in its own folder](#always-place-component-in-its-own-folder)
- [Formatting](#formatting)
  - [Prefer maximum line length of 120 characters](#prefer-maximum-line-length-of-120-characters)
  - [Omit trailing comma after single parameter](#omit-trailing-comma-after-single-parameter)

## Folder structure guidelines

### Inverse file naming

We use inverse names for files, but a regular one for folders.
```
.
└── settigns/
    ├── fractional_stops/
    │   └── widget_list_tile_fractional_stops.dart
    ├── ...
    └── screen_settings.dart
```

```dart
/// widget_list_tile_fractional_stops.dart

class FractionalStopsListTile extends StatelessWidget {...}
```

```dart
/// screen_settings.dart

class SettingsScreen extends StatelessWidget {...}
```

### Always use a functional prefix in widgets file names

Basically this rule comes from the previous one but covers specifically widgets.
It is pretty obvious that for example `FooIcon` and `BarButton` are widgets and respective file names *icon_foo.dart* and *button_bar.dart* reflect it. But we still add *widget_* prefix to all widgets to maintain consistency while omitting `Widget` in the class names (i.e. `FooIconWidget`).

### All files must be grouped according to their function

That basically means, that all files should be placed in the folders according to their functional prefix even if there is only one file.

### Place elements used by one screen in the folder of this screen

Place all widgets, utils, etc. used by a single screen in corresponding folders on the same level with other screen files.

```
.
└── screens/
    └── metering/
        ├── components/
        │   ├── bottom_controls/
        │   │   └── ...
        │   └── topbar/
        │       └── ...
        └── screen_metering.dart
```

### Place elements used within one logical group in the _shared_ folder inside this group folder

Components used by multiple screens or by other components within one logical group should be placed in the _shared_ folder on the same level with the corresponding screens/components.

In the example below the `DialogPicker` is used by `FractionalStopsListTile` and `ThemeTypeListTile`.

```
.
└── settigns/
    ├── fractional_stops/
    │   └── widget_list_tile_fractional_stops.dart
    ├── shared/
    │   └── dialog_picker/
    │       └── widget_dialog_picker.dart
    └── theme_type/
        └── widget_list_tile_theme_type.dart
```

### Always place component in its own folder

Folder structure for the most basic widget looks like this:
- *<widget_name>*
    - bloc_*<widget_name>*.dart
    - provider_*<widget_name>*.dart
    - widget_*<widget_name>*.dart

But sometimes widgets don't need a bloc and provider and therefore there is only one file left - the widget itself.
Even in this case a single file has to be placed in its own folder:
- *<widget2_name>*
    - widget_*<widget2_name>*.dart
 
```
/// BAD
components/
├── haptics/
│   ├── bloc_list_tile_haptics.dart
│   ├── provider_list_tile_haptics.dart
│   └── widget_list_tile_haptics.dart
└── widget_list_tile_theme_type.dart
                
/// GOOD
components/
├── haptics/
│   ├── bloc_list_tile_haptics.dart
│   ├── provider_list_tile_haptics.dart
│   └── widget_list_tile_haptics.dart
└── theme_type/
    └── widget_list_tile_theme_type.dart
```

## Formatting

### Prefer maximum line length of 120 characters

Just an alteration of the Style guide [rule](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#prefer-a-maximum-line-length-of-80-characters) changing the maximum line length from 80 to 120 characters.

### Omit trailing comma after single parameter

```dart
/// BAD
const SizedBox(
  width: 16.0,
)

/// ALSO BAD
const SizedBox(width: 16.0, height: 16.0)

/// GOOD
const SizedBox(width: 16.0)

/// ALSO GOOD
const SizedBox(
  width: 16.0,
  height: 16.0,
)
```