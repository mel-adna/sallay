# Engineering Summary

## Overview
Sallay is built using Flutter, adhering to a clean architecture pattern. It prioritizes privacy and offline capability by using local storage (Hive) and on-device prayer time calculation (Adhan).

## Key Components

### Core Services
- **PrayerTimeService**: Wraps the `adhan` package to calculate prayer times based on location and date.
- **LocationService**: Handles permission requests and retrieves device coordinates using `geolocator`.
- **StorageService**: Uses `hive` for fast, key-value storage of prayer logs and user settings.
- **NotificationService**: Manages scheduled local notifications using `flutter_local_notifications`.

### UI Layer
- **Onboarding**: Introduces the app's value proposition and handles initial setup.
- **Home**: The main dashboard for viewing prayer times and logging status.
- **Weekly Summary**: Visualizes prayer compliance using `fl_chart`.
- **Settings**: Allows configuration of language, calculation methods, and notifications.

## Edge Cases & Future Considerations

1.  **Location Permission Denied**:
    - *Current*: The app may fail to get prayer times if location is strictly required.
    - *Recommendation*: Implement a manual city selection fallback.

2.  **Timezone Changes**:
    - *Current*: Notifications are scheduled based on local time.
    - *Recommendation*: Listen to system timezone changes and reschedule notifications.

3.  **Background Execution**:
    - *Current*: Notifications are scheduled in advance.
    - *Recommendation*: Use `workmanager` for more reliable background tasks if complex logic is needed (e.g., dynamic location updates).

4.  **Data Backup**:
    - *Current*: Local only.
    - *Recommendation*: Implement encrypted cloud backup (e.g., Firebase or custom backend) as an opt-in feature.

## Next Steps
- Implement the manual city selector.
- Add more granular notification settings (e.g., different sounds for different prayers).
- Enhance accessibility with more detailed semantic labels.
- Add widget support for home screen.
