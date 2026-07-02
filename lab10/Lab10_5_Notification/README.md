# Lab10_5_Notification

A Flutter project demonstrating integration of local push notifications (to satisfy LO7 requirements).

## How to Run the App
1. Navigate into this project directory:
   ```bash
   cd Lab10_5_Notification
   ```
2. Run the application:
   ```bash
   flutter run
   ```

## Testing Notifications (Android 13+ / API 33+)
1. When the app launches, it automatically prompts you to grant notification permissions.
2. If denied or skipped, press the **Request Permission** button to request it again.
3. Once permissions are granted, press **Trigger Notification**.
4. The system will trigger a local push notification alert showing:
   - **Title**: `Lab 10 Notification`
   - **Body**: `Hello from local notifications! LO7 criteria completed.`
