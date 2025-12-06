# Sallay (صلاي)

Sallay is a premium, privacy-focused Islamic prayer companion app designed to help you maintain your daily prayers with ease and elegance. Built with Flutter, it prioritizes a minimalist aesthetic, offline functionality, and user privacy.

## ✨ Key Features

### 🕌 Prayer Times & Adhan
- **Accurate Times**: Calculates prayer times based on your location using high-precision astronomical algorithms (`adhan` package).
- **Multiple Methods**: Supports various calculation methods (Muslim World League, Umm Al-Qura, Egyptian, Karachi, North America, and more).
- **Manual Location**: Automatically detects location via GPS or allows manual city selection for privacy or travel.

### 🧭 Qibla Compass
- **Real-time Direction**: Integrated compass to accurately point towards the Kaaba from anywhere in the world.
- **Visual Feedback**: Smooth, animated UI for easy orientation.

### 📊 Prayer Tracking & Stats
- **Habit Building**: Log your prayers with a single tap.
- **Current Streak**: Track your daily prayer streak to stay motivated.
- **Visual Stats**: View your weekly progress with beautiful charts and summary statistics.
- **Undo Capability**: Made a mistake? Easily unmark a prayer.

### 🔔 Smart Notifications
- **Custom Alerts**: Enable or disable notifications for specific prayers.
- **Pre-Alerts**: Get reminded 10, 15, or 30 minutes before the next prayer to prepare.

### 💾 Backup & Restore
- **Data Portability**: Export your prayer logs and settings to a local JSON file.
- **Privacy First**: Restore your data anytime without needing a cloud account.

### 📱 Premium Experience
- **Home Screen Widget**: View the next prayer time directly from your home screen.
- **Dark Mode**: Sleek, battery-saving dark theme designed for comfort in low light.
- **Localization**: Fully localized in **English** and **Arabic** (RTL support included).
- **Privacy First**: All data is stored locally on your device. No tracking, no ads, no cloud sync required.

## 🛠️ Tech Stack
- **Framework**: Flutter
- **State Management**: `setState` (Clean & Simple)
- **Local Storage**: `hive` (Fast NoSQL database)
- **Location**: `geolocator` & `geocoding`
- **Charts**: `fl_chart`
- **Compass**: `flutter_compass`
- **Notifications**: `flutter_local_notifications`

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   ```bash
   flutter run
   ```

3. **Build for Release**:
   ```bash
   flutter build apk --release
   ```

---
*Sallay - Your companion for daily prayers.*
# sallay
# sallay
