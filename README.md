# hello_flutter_lab1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Exercise 4 – Reflection Questions

1. What is the purpose of the `flutter doctor` command?
   - `flutter doctor` checks your development environment and reports any missing dependencies, tools, or setup issues for Flutter, Android, iOS, and desktop platforms.

2. What file acts as the entry point of a Flutter application?
   - The entry point is typically `lib/main.dart`, which contains the `main()` function and starts the app by calling `runApp()`.

3. Explain the difference between Hot Reload and Hot Restart.
   - Hot Reload injects updated source code into the running app while keeping its current state, allowing fast UI changes.
   - Hot Restart rebuilds the app from scratch and resets its state, which is useful after changing global variables or app initialization logic.

4. How does `runApp()` build the widget tree?
   - `runApp()` attaches the given root widget to the Flutter engine, which then inflates and composes the widget tree, creating elements and render objects for display.

5. Describe how Flutter’s architecture enables cross-platform development.
   - Flutter uses a single Dart codebase, its own rendering engine, and a rich widget library. This lets the same app code run on Android, iOS, web, and desktop with consistent UI and behavior.

### Expected Results

- Successful setup of the Flutter environment
- Ability to create and run Flutter projects
- Understanding of widgets, layout, and hot reload
- Complete screenshots for all required steps
