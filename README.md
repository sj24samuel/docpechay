# 🌱 Pechay Disease Detection App

A Flutter application for **real-time pechay plant disease detection** using a TensorFlow Lite model.  
The app integrates with **Firebase** for authentication, Firestore for storing user scans, Firebase Storage for images, and captures **GPS location** for each detection.

---

## 🚀 Quick Start

```bash
# 1. Install Flutter (stable channel) and add it to PATH
# 2. Verify installation
flutter doctor -v

# 3. Clone this repository
git clone https://github.com/sj24samuel/docpechay.git
cd pechay-disease-detection

# 4. Install dependencies
flutter pub get

# 5. Run the app
flutter run

```

## 📋 Prerequisites

- Flutter SDK: stable (3.x or newer) → Install Guide
- Dart: included with Flutter
- Git
- VScode
- Android
- Android Studio with SDK + Platform Tools
- Java JDK 17 (LTS) (recommended for Gradle builds)

## Firebase Setup

- Download Config File and Generate Private Key
```bash
https://console.firebase.google.com/u/0/project/drpechay-2025/settings/serviceaccounts/adminsdk
```
- Add Config File to ```android/app/google-services.json```

## Permissions

Android → android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

iOS → ios/Runner/Info.plist
<key>NSCameraUsageDescription</key>
<string>We need camera access for plant disease detection.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location access to tag your scans with GPS data.</string>

## Build Release
flutter build apk
flutter build appbundle    # for Google Play Store



