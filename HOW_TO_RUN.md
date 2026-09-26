# How to Run VineCare Flutter App — Complete Beginner Guide

---

## What is Flutter?

Flutter is a toolkit made by Google that lets you write one app that runs on both
Android and iOS (and even web/desktop). You write code in a language called **Dart**,
which is similar to Java or TypeScript. Flutter compiles it into a native app.

Think of it like this:
- Your code files are in `lib/` (the "source code")
- `pubspec.yaml` is like `package.json` — it lists all dependencies
- Flutter SDK is the "compiler + runtime" that turns your code into an app

---

## STEP 1 — Install Flutter SDK

### Windows (your machine)

1. Go to https://docs.flutter.dev/get-started/install/windows
2. Download the Flutter SDK zip (around 1 GB)
3. Extract it to a simple path — recommended: `C:\flutter`
   - ⚠️ Do NOT put it in `C:\Program Files` (spaces in path cause issues)
4. Add Flutter to your PATH:
   - Press `Win + S` → search "Environment Variables"
   - Click "Edit the system environment variables"
   - Click "Environment Variables" button
   - Under "System variables", find `Path` → click Edit
   - Click New → add `C:\flutter\bin`
   - Click OK on all dialogs
5. Open a **new** Command Prompt and run:
   ```
   flutter doctor
   ```
   This checks what's installed. You'll see checkmarks ✅ and warnings ✗.

---

## STEP 2 — Install Android Studio (to get an Android emulator)

Flutter doesn't need Android Studio for code editing, but you need it to get:
- The Android SDK (the tools to build Android apps)
- An Android emulator (a virtual phone on your PC)

1. Download from https://developer.android.com/studio
2. Install with default settings
3. Open Android Studio → go through the setup wizard
4. In Android Studio: go to **Tools → Device Manager → Create Device**
   - Choose "Pixel 7" (or any phone)
   - Choose a system image — pick **API 34** (Android 14), click Download if needed
   - Click Finish
5. Start the emulator by clicking the ▶️ play button next to the device

After this, run `flutter doctor` again. You should now see:
```
[✓] Android toolchain
[✓] Android Studio
```

---

## STEP 3 — Install VS Code (recommended code editor)

1. Download from https://code.visualstudio.com
2. Install the **Flutter** extension:
   - Open VS Code → press `Ctrl+Shift+X` (Extensions)
   - Search "Flutter" → install the official Flutter extension by Dart Code
   - This also installs the Dart extension automatically
3. Restart VS Code

---

## STEP 4 — Open the Project

1. Open VS Code
2. Go to **File → Open Folder**
3. Navigate to `C:\Users\Digvijay Kor\Claude\Projects\vine-care`
4. Click "Select Folder"

You should see the file tree on the left with all the `lib/` files.

---

## STEP 5 — Install Dependencies

Open the VS Code terminal: press **Ctrl + `** (backtick)

Run:
```bash
flutter pub get
```

This reads `pubspec.yaml` and downloads all the packages (like `go_router`, `google_fonts`, etc.) into a hidden `.dart_tool/` folder. It's like `npm install`.

You should see: `Got dependencies!`

---

## STEP 6 — Run the App

Make sure your Android emulator is running (you started it in Step 2).

In the VS Code terminal:
```bash
flutter run
```

Flutter will:
1. Build the app (takes 1–2 minutes the first time)
2. Install it on the emulator
3. Launch it

You should see the VineCare **Splash screen** appear on the emulator!

### Shortcut keys while the app is running:
- Press `r` in the terminal → **Hot reload** (updates UI instantly after code changes)
- Press `R` → **Hot restart** (full restart, useful for logic changes)
- Press `q` → Quit

---

## STEP 7 — Navigating the Demo App

The app runs entirely on **demo data** — no backend needed.

### Login Screen
- Email is pre-filled: `admin@kokotosestate.gr`
- Type **anything** in the password field and tap **Sign In**
- Since there's no backend, it automatically logs you in with a dev token

### What each screen shows:
| Tab | What you'll see |
|-----|----------------|
| 🏠 Home | Dashboard with KPIs (12 blocks, 47 flights, 3 alerts), phenology progress bar, 2 recent drone flights |
| 🌾 Farms | 4 vineyard blocks (A1 Gewurztraminer, A2 Assyrtiko, B1 Merlot, B3 Chardonnay). Tap any to see details |
| 🚁 Flights | Drone upload screen — pick images from your device, select a block, set altitude |
| 🌱 Phenology | Growing season timeline showing Berry Development stage with NDVI metrics |
| 🔔 Alerts | 6 notifications (3 unread) — NDVI alert, heat stress warning, phenology update |

Tap the avatar (top right on dashboard) → Profile & Settings screen

---

## Understanding the File Structure

```
vine-care/
│
├── pubspec.yaml          ← Package list (like package.json)
│
├── lib/                  ← ALL your app code lives here
│   ├── main.dart         ← Entry point — app starts here
│   │
│   ├── core/             ← App-wide settings
│   │   ├── app_colors.dart   ← Every color used (extracted from Figma)
│   │   ├── app_theme.dart    ← Dark theme setup
│   │   └── app_routes.dart   ← Navigation/routing (which screen goes where)
│   │
│   ├── models/           ← Data structures + demo data
│   │   ├── block.dart        ← A vineyard block (Block A1, B3, etc.)
│   │   ├── flight.dart       ← A drone flight record
│   │   └── notification_item.dart ← A notification
│   │
│   ├── services/
│   │   └── api_service.dart  ← HTTP calls to backend (not used yet — fallback to demo)
│   │
│   ├── widgets/          ← Reusable UI components
│   │   ├── vc_bottom_nav.dart   ← The bottom tab bar (🏠🌾🚁🌱🔔)
│   │   ├── kpi_card.dart        ← The "12 Blocks" / "47 Flights" boxes
│   │   ├── flight_card.dart     ← A single drone flight row
│   │   ├── block_card.dart      ← A single vineyard block row
│   │   └── status_pill.dart     ← "Processed" / "Pending" badges
│   │
│   └── screens/          ← One file per screen
│       ├── splash_screen.dart
│       ├── login_screen.dart
│       ├── main_shell.dart       ← Wraps all tab screens with the bottom nav
│       ├── dashboard_screen.dart
│       ├── farms_screen.dart
│       ├── block_detail_screen.dart
│       ├── drone_upload_screen.dart
│       ├── phenology_screen.dart
│       ├── notifications_screen.dart
│       └── profile_screen.dart
│
├── android/              ← Android-specific config (you rarely touch this)
└── ios/                  ← iOS-specific config (you rarely touch this)
```

**Rule of thumb:**
- Want to change a color? → `lib/core/app_colors.dart`
- Want to change demo data? → `lib/models/block.dart` (or flight.dart, notification_item.dart)
- Want to change what a screen looks like? → the matching file in `lib/screens/`
- Want to add a new screen? → create a file in `lib/screens/`, then add a route in `lib/core/app_routes.dart`

---

## Connecting to Backend Later

When your EC2 instance is deployed and you have the server IP or domain, open:
```
lib/services/api_service.dart
```

Change line 14:
```dart
// FROM:
static const String _baseUrl = 'http://vine-care-frontend-alb';

// TO (example):
static const String _baseUrl = 'http://YOUR-EC2-IP-OR-DOMAIN';
```

The app will then make real API calls. Until then, the login fallback and mock data keep everything working for demos.

---

## Common Issues

| Problem | Fix |
|---------|-----|
| `flutter: command not found` | Flutter not in PATH — redo Step 1 step 4 |
| `No connected devices` | Start your Android emulator first (Step 2) |
| `flutter pub get` fails | Check your internet connection; corporate firewalls sometimes block pub.dev |
| App crashes on launch | Run `flutter clean` then `flutter pub get` then `flutter run` |
| Emulator is slow | In Android Studio → Device Manager → Edit → increase RAM to 2048 MB |

---

## Building a Release APK (to install on a real Android phone)

```bash
flutter build apk --release
```

The APK file will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

Copy this file to your Android phone and install it (you need to enable "Install from unknown sources" in your phone settings).
