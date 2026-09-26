# VineCare Flutter App — Setup Guide

## Prerequisites
- Flutter SDK ≥ 3.1.0 (run `flutter doctor` to verify)
- Android Studio + Android SDK (for Android)
- Xcode 14+ (for iOS, macOS only)

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── app_colors.dart          # All design tokens (from Figma)
│   ├── app_theme.dart           # MaterialApp theme
│   └── app_routes.dart          # GoRouter navigation
├── models/
│   ├── block.dart               # Vineyard block model + mock data
│   ├── flight.dart              # Drone flight model + mock data
│   └── notification_item.dart   # Notification model + mock data
├── services/
│   └── api_service.dart         # HTTP client for all 3 microservices
├── widgets/
│   ├── vc_bottom_nav.dart       # Persistent bottom navigation
│   ├── kpi_card.dart            # Dashboard KPI tiles
│   ├── flight_card.dart         # Flight list item
│   ├── block_card.dart          # Block list item
│   └── status_pill.dart        # Processed/Pending/Failed badges
└── screens/
    ├── splash_screen.dart       # Animated splash with progress bar
    ├── login_screen.dart        # Auth form → calls /data/api/auth/login/
    ├── main_shell.dart          # Shell with bottom nav
    ├── dashboard_screen.dart    # KPIs + phenology + recent flights
    ├── farms_screen.dart        # Block list with search + variety filter
    ├── block_detail_screen.dart # Block map + stats + flight history
    ├── drone_upload_screen.dart # Image picker → S3 upload
    ├── phenology_screen.dart    # Timeline + metrics
    ├── notifications_screen.dart# Tabbed notifications list
    └── profile_screen.dart      # User info + settings + sign out
```

## Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Add Inter fonts (download from fonts.google.com/specimen/Inter)
#    Place in: assets/fonts/
#    - Inter-Regular.ttf
#    - Inter-Medium.ttf
#    - Inter-SemiBold.ttf
#    - Inter-Bold.ttf
#    - Inter-ExtraBold.ttf

# 3. Create assets/images/ directory (for future static assets)
mkdir assets/images

# 4. Run on Android emulator
flutter run -d android

# 5. Run on iOS simulator (macOS only)
flutter run -d ios

# 6. Build release APK
flutter build apk --release

# 7. Build iOS IPA (requires Xcode + Apple Developer account)
flutter build ios --release
```

## API Configuration

Update `lib/services/api_service.dart` line 14:
```dart
static const String _baseUrl = 'http://dualstack.YOUR-ALB-DNS.eu-central-1.elb.amazonaws.com';
```

**Microservice routing (via ALB):**
| Service | ALB Path Prefix | Internal Port |
|---------|----------------|---------------|
| Data Collection | `/data/*` | 8000 |
| Notifications | `/notifications/*` | 8001 |
| Phenology | `/phenology/*` | 8002 |

## Dev Mode
The login screen falls back to a mock token (`dev-token-bypass`) if the API is unreachable, so you can develop/test the UI without a live backend.

## Screens

| Screen | Route | Backend |
|--------|-------|---------|
| Splash | `/splash` | None (auto-nav) |
| Login | `/login` | `/data/api/auth/login/` |
| Dashboard | `/dashboard` | `/data/api/dashboard/` |
| Farms | `/farms` | `/data/api/blocks/` |
| Block Detail | `/farms/:blockId` | `/data/api/blocks/:id/` |
| Drone Upload | `/flights` | `/data/api/flights/upload/` |
| Phenology | `/phenology` | `/phenology/api/current/` |
| Notifications | `/notifications` | `/notifications/api/list/` |
| Profile | `/profile` | Local + token clear |
