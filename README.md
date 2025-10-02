
# TIER Flutter (Android-focused)

This is a minimal Flutter app converted from a Base44 web app extract. It is mobile-first and stores data locally using `shared_preferences`.

## Features implemented
- Dashboard with mood entry (slider) and recent appointments preview
- Calendar page (list grouped by date)
- Schedule page to create appointments (shows confirmation after scheduling)
- Resources page with static items
- Navigation: bottom navigation + drawer for mobile friendliness
- Local storage only (shared_preferences)

## How to run (Android)
1. Install Flutter SDK and Android SDK.
2. Open this folder in Android Studio or VS Code.
3. Run `flutter pub get`.
4. Run on Android emulator or device: `flutter run`.

Files of interest:
- `lib/main.dart` — app entry & routing
- `lib/models/appointment.dart` — appointment model
- `lib/services/storage_service.dart` — local persistence using shared_preferences
- `lib/pages/*` — UI pages
