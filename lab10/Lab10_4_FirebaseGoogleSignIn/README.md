# Lab10_4_FirebaseGoogleSignIn

A Flutter project demonstrating integration with Firebase Authentication and Google Sign-In.

## How to Run the App
1. Navigate into this project directory:
   ```bash
   cd Lab10_4_FirebaseGoogleSignIn
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## Demo Mode / Simulation Mode
If the Firebase project setup is not complete (meaning the `google-services.json` file is missing or invalid), the app automatically handles the error and enters **Demo Mode** by default. Toggle the "Demo Mode" switch to preview the UI flow, profile rendering, and routing as a mock user.

## Real Firebase Setup Guide (To Test Real Google Sign-In)
To connect this project to your own Firebase project:
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project and add an Android app. Use the package name: `com.example.lab10.lab10_4_firebasegooglesignin`.
3. Generate your SHA-1 fingerprint. On Windows:
   ```bash
   keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
   ```
   (Password is `android` by default). Copy the SHA-1 fingerprint and paste it into the Firebase console app settings.
4. Download the `google-services.json` file and place it under:
   `Lab10_4_FirebaseGoogleSignIn/android/app/google-services.json`
5. Go to Firebase → Build → Authentication → Sign-in method, enable **Google** sign-in, and select your support email.
6. Open `Lab10_4_FirebaseGoogleSignIn/android/build.gradle` and verify that the classpath for Google Services is present in buildscript dependencies (we have already added it or it will be resolved by the flutter framework).
7. Rebuild the app:
   ```bash
   flutter clean
   flutter run
   ```
