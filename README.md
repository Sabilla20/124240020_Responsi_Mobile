# Keripikroll (Responsi Praktikum Mobile)

## Setup
1. Pastikan Flutter SDK sudah terpasang.
2. Di folder project ini jalankan (untuk membuat folder android/ios dll):
   `flutter create .`
3. `flutter pub get`
4. Android: pastikan `android/app/src/main/AndroidManifest.xml` punya
   `<uses-permission android:name="android.permission.INTERNET"/>` di atas tag `<application>`.
5. `flutter run`

## Login
- Username: `admin`
- Password: `12345`

## Struktur
- `lib/services/api_service.dart`      : fetch & parse API Kitsu
- `lib/services/favorite_service.dart` : CRUD favorit via Hive
- `lib/models/anime.dart`              : model
- `lib/pages/`                         : login, main (bottom nav), home, detail, favorite, profile
