# Lab10_3_AutoLogin_Logout

A Flutter project demonstrating session persistence using `SharedPreferences`.

## How to Run the App
1. Navigate into this project directory:
   ```bash
   cd Lab10_3_AutoLogin_Logout
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## Testing Auto-Login & Session Recovery
1. Sign in with the test API account:
   - **Username**: `emilys`
   - **Password**: `emilyspass`
2. Once on the home dashboard, force close the app.
3. Relaunch the app. The app will launch the Splash Screen, recognize the saved credentials, and route directly to the Home dashboard without asking for sign-in again.
4. Click the **Logout** button, which deletes the keys from SharedPreferences and returns the user to the Sign-In screen.
