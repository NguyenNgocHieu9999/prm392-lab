# Lab10_Full

The final integrated Flutter application that combines mock validation, REST API authentication, SharedPreferences session persistence, Firebase Google Sign-In, and Local Notification alerts (satisfying LO7).

## How to Run the App
1. Navigate into this project directory:
   ```bash
   cd Lab10_Full
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## Test REST API Credentials (DummyJSON)
- **Username**: `emilys`
- **Password**: `emilyspass`

## Firebase & Google Sign-In Configuration
If your Firebase credentials or the `google-services.json` file are not yet configured:
1. The app will catch the error on startup and enable **Google Demo Mode** automatically.
2. Pressing **Google Sign-In** under Demo Mode will simulate the Google flow and log you in as a demo user.
3. To configure the real Firebase connection, add your SHA-1 key to Firebase console and copy the `google-services.json` file into:
   `Lab10_Full/android/app/google-services.json`
   Toggle the "Google Demo Mode" switch off in the app, clean build, and run.

## Integrated Notifications Flow (LO7 Requirement)
- Upon **successful login** (either REST API or Google Sign-In), a local push notification triggers:
  - **Title**: `API Sign in Successful!` or `Google Sign in Successful!`
  - **Body**: `Welcome back, <Name>...`
- Upon **logout**, a notification triggers:
  - **Title**: `Session Terminated`
  - **Body**: `You have successfully signed out and cleared active login sessions.`
- A manual trigger is also available in the home dashboard to test notifications.
