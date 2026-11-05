# PC Bazar

An Android marketplace app for buying and selling PC parts (GPUs, monitors, keyboards, mice), built with Flutter. Final Year Project.

Product listings are checked by the fraud detection API in [`../ai_fraud_detection`](../ai_fraud_detection).

## Features
- Onboarding, sign up and login
- Home screen with categories: GPUs, monitors, keyboards, mice
- Search, featured items and favorites
- Cart and "Buy now" checkout with Cash on Delivery
- Add a product listing with image upload and an AI fraud check (`safe`, `medium_risk`, `high_risk`)
- Admin screen to review orders (confirm or reject)
- Notifications and profile (change password)

## Tech Stack
- Flutter, Dart
- `http` for calling the fraud detection API
- `image_picker` for product images
- Python/Flask fraud detection service (`ai_fraud_detection` folder)

## How to Run
1. Install [Flutter](https://docs.flutter.dev/get-started/install)
2. Get packages and run the app:
   ```bash
   flutter pub get
   flutter run
   ```
3. Demo login: `demo@pcbazaar.com` / `123456`

### Fraud detection API (optional)
Start the API from the [`ai_fraud_detection`](../ai_fraud_detection) folder (`python app.py`, runs on port 5000). The app calls `http://localhost:5000/check_fraud`. On the Android emulator, `localhost` points to the emulator itself, so change the URL to `http://10.0.2.2:5000/check_fraud` in `lib/services/fraud_detection_service.dart` and `lib/add_product_page.dart`.

## Notes
- The app uses a local in-memory demo backend (`lib/backend.dart`), so data is not saved after the app restarts.
- `supabase_flutter` is listed in `pubspec.yaml` but the app does not connect to a Supabase project.

## Project Structure
```
lib/
├── main.dart
├── backend.dart          # in-memory demo backend
├── services/             # fraud detection API client
├── models/
└── *_page.dart           # app screens
assets/                   # images and logos
android/                  # Android project
```
