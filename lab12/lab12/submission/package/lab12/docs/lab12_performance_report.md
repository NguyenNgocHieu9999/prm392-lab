# Lab 12 Performance Optimization Report

## Exercise 12.1 - Optimize List Rebuilds

Implemented:

- Extracted the inline task row into `lib/widgets/task_tile.dart`.
- Updated `lib/screens/task_list_screen.dart` to use `Selector<TaskProvider, List<Task>>` for the list.
- Added a separate summary selector for completed/total task counts.
- Added `const` constructors/widgets where the UI is static.
- Assigned stable list item keys with `ValueKey(task.id)`.

Result:

- Task actions are handled through `context.read<TaskProvider>()`, so button taps do not subscribe each tile to broad provider rebuilds.
- The list and summary rebuild only when their selected provider values change.
- Task rows are isolated in a small widget, making rebuild behavior easier to inspect in Flutter DevTools.

## Exercise 12.2 - Image and Asset Optimization

Implemented:

- Added a single optimized PNG asset: `assets/images/taskly_icon.png`.
- Asset dimensions: 128 x 128.
- Asset file size: 3,428 bytes.
- Declared only the used asset in `pubspec.yaml`.
- Pre-cached the frequently displayed icon in `TaskListScreen.didChangeDependencies()`:

```dart
precacheImage(const AssetImage(_taskIconPath), context);
```

Removed unused assets/dependencies:

- Removed `cupertino_icons` because Taskly only uses Material icons.
- No unused project assets were present before this lab.

## Exercise 12.3 - App Size Analysis

Command:

```powershell
flutter build apk --analyze-size --target-platform android-arm64
```

Measured result:

- Analyzed APK artifact: `build/app/outputs/flutter-apk/app-release.apk`
- Analyzed APK size: 15.5 MB reported by Flutter, 16 MB total compressed in the size summary.
- DevTools size JSON: `C:\Users\Admin\.flutter-devtools\apk-code-size-analysis_01.json`

Top size contributors from the Flutter report:

1. `lib/arm64-v8a` native libraries: 15 MB compressed.
2. Dart AOT symbols inside native library: 4 MB decompressed, led by `package:flutter` at 2 MB.
3. `classes.dex`: 231 KB compressed.

Optimization suggestions:

- Keep asset declarations narrow; avoid adding whole asset folders unless every file is used.
- Continue relying on icon tree shaking; Flutter reduced `MaterialIcons-Regular.otf` from 1,645,184 bytes to 1,512 bytes.
- Keep dependencies minimal; `provider` is small in this report at about 13 KB.
- Use AppBundle distribution for Play Store when the Android toolchain is fully configured, because it lets Google Play deliver ABI-specific downloads.

## Exercise 12.4 - Final Optimization and Deployment

Completed:

- Removed template debug/demo code.
- Avoided `print()` debug logs.
- Added `const` where applicable.
- Removed unused `cupertino_icons` dependency.
- Ran `flutter clean`.
- Built a verified release APK:

```powershell
flutter build apk --release
```

Release artifact:

- `build/app/outputs/flutter-apk/app-release.apk`
- Size on disk: 46,872,793 bytes, about 44.7 MB.

Verification:

- `flutter analyze`: no issues found.
- `flutter test`: all tests passed.
- `flutter build apk --release`: successful.

Notes:

- `flutter build appbundle --release` produced an `.aab` file but exited with a native debug-symbol stripping failure, so the APK is the verified release artifact for this submission.
- `flutter doctor -v` reported missing Android command-line tools and unknown Android license status. Installing command-line tools and accepting licenses should be done before relying on AppBundle output.
- No Android emulator or physical device was available in this workspace, so release-mode device screenshot/profile observations could not be captured here.

## Performance Checklist

- [x] Task row extracted into `TaskTile`.
- [x] Task list uses `Selector<TaskProvider, List<Task>>`.
- [x] Stable `ValueKey(task.id)` assigned to each task row.
- [x] Static widgets marked `const` where practical.
- [x] Small 128 x 128 PNG asset added.
- [x] Frequently displayed asset pre-cached.
- [x] Unused dependency removed.
- [x] APK size analysis completed for `android-arm64`.
- [x] Release APK built successfully.
- [x] Analyzer and widget tests passed.

## Deployment Summary

Taskly is ready for APK-based deployment because the app now has scoped provider rebuilds, isolated task rows, a small pre-cached asset, no debug prints, no unused icon dependency, a passing analyzer/test suite, and a successfully generated release APK.
