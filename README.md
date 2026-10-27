# Flow QR Reader - README

Flow QR Reader is a Flutter application built with Clean Architecture and
Cubit for state management. It runs on a role-selectable physical scanner
unit (Brew / Call / Pickup — see `device_role_picker_screen`). Input comes
from a hardware keyboard-wedge barcode/QR scanner, not a camera — the
native side listens for keystrokes and forwards scanned text over a
`MethodChannel` into the Dart scan stream.

## 1. Project Goals

- Let an operator pick this unit's role once (persisted locally) via
  `DeviceRoleGate`.
- Publish each scan to the correct MQTT topic for that role.
- Run full-screen, kiosk-style (`SystemUiMode.immersiveSticky`, no system
  bars).
- Self-heal: auto-relaunch if the app process dies.

## 2. Environment and Requirements

### 2.1 SDK

- Flutter: 3.32.8 (locked in `.fvmrc`)
- Dart SDK: `>=3.8.0 <4.0.0` (from pubspec)

### 2.2 Required Toolchain Versions

- FVM: recommended (for team-wide Flutter version consistency)
- Java (JDK): 17+ (JDK 17 LTS recommended)
- Gradle Wrapper: 8.12 (`android/gradle/wrapper/gradle-wrapper.properties`)
- Android Gradle Plugin (AGP): 8.9.1 (`android/settings.gradle.kts`)
- Kotlin Android Plugin: 2.1.0 (`android/settings.gradle.kts`)
- compileSdk / minSdk / targetSdk: 36 / 23 / 35 (org-wide fleet standard —
  minSdk 23 covers the oldest device in the fleet, an Android 6 FrameTV).
  minSdk is enforced redundantly in three places in
  `android/app/build.gradle` (`defaultConfig`, `afterEvaluate`, and
  `androidComponents.beforeVariants`) — Flutter's own Gradle plugin was
  seen silently overriding a single declaration, so keep all three in sync
  if this ever needs to change.

### 2.3 Verify Local Environment

```bash
fvm use 3.32.8
fvm flutter --version
fvm dart --version
java -version
```

Optional Android check:

```bash
cd android
./gradlew -version
```

### 2.4 Core Packages

- flutter_bloc
- get_it + injectable
- freezed
- mqtt_client

## 3. Quick Setup

```bash
fvm use
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter analyze --no-fatal-infos
```

## 4. Testing

```bash
fvm flutter test
```

No real test suite exists yet — only the default `test/widget_test.dart`
scaffold.

## 5. Running by Environment

The project has two real entrypoints:

- Dev: `lib/main_dev.dart`
- Prod: `lib/main_prod.dart`

`lib/main.dart` is the plain Flutter-template default and does **not**
initialize DI — always run via one of the two entrypoints above.

```bash
# Run
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart

# Build APK
flutter build apk --flavor dev -t lib/main_dev.dart --debug
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

Both entrypoints: `WidgetsFlutterBinding.ensureInitialized()` →
`LocalSubnetResolver.resolve()` (unawaited) → `setupLocator(Env.dev()/
Env.prod())` → `SystemChrome.setEnabledSystemUIMode(immersiveSticky)` →
`runApp(ScannerApp)` (home = `DeviceRoleGate`).

Output APK filename: `CafeBeta_QrReader_<flavor>_<version>.<buildNumber>.apk`
(see `android/app/build.gradle`'s `applicationVariants.all` block). Use
`./scripts/build_apk.sh <flavor>` instead of the raw `flutter build apk`
command above to get this filename plus auto-versioning by date + same-day
build count (see section 7.4) and a copy exported to `~/Documents/
CafeBeta_QrReader`.

### 5.1 Auto-start and watchdog

Two native components keep the kiosk unit running unattended:

- `BootReceiver.kt` — on `ACTION_BOOT_COMPLETED`, launches `MainActivity`
  **and** starts `WatchdogService`.
- `WatchdogService.kt` — a foreground `Service` (persistent notification)
  that checks every 30s whether `MainActivity` is actually running and
  relaunches it if not.

Both require `RECEIVE_BOOT_COMPLETED` (declared in `AndroidManifest.xml`).

### 5.2 Role selection

The chosen role (Brew / Call / Pickup) is persisted on-device via a native
`SharedPreferences` bridge (`device_role_data_source.dart`) — a device's
role survives an app update but must be re-selected if the persisted
deviceId format ever changes (it's a plain string comparison, not
schema-versioned).

## 6. Folder Structure

```text
lib/
  core/
    constants/         # network topics, device identity
    di/                # get_it + injectable config
    env/               # environment model
  data/
    repositories/       # repository implementations
    sources/
      local/             # device role persistence
      remote/            # MQTT datasource
  domain/
    entities/            # device role entity
    repositories/         # repository contracts
    usecases/             # business use cases
  presentation/
    cubit/                # state management (Cubit + State)
    screens/              # DeviceRoleGate, device_role_picker_screen
    widgets/              # reusable widgets
```

## 7. Project Rules

### 7.1 Clean Architecture

- Presentation calls use cases, not data sources directly.
- Cubit does not access data layer classes directly.
- Domain does not depend on Flutter widgets.

### 7.2 Generated Files

Do not edit directly — edit the source and re-run build_runner:

- `*.freezed.dart`
- `di.config.dart`

### 7.3 index.dart Barrel Export Rule

Each feature/layer folder exposes its public files through `index.dart`.
Add new public files to the matching `index.dart` in the same change.

### 7.4 Version Naming Rule

`pubspec.yaml` version format: `MAJOR.MINOR.YYMMDD+YYMMDDBUILD`

```yaml
version: 0.10.261027+26102701
```

- `MAJOR`: breaking release line
- `MINOR`: feature milestone line
- `YYMMDD`: release date, repeated at the start of the build number
- `BUILD`: same-day build count — bump by hand before every same-day rebuild

## 8. Common Troubleshooting

### 8.1 App starts but DI is missing

Running `lib/main.dart` does not initialize DI. Use an environment
entrypoint instead:

```bash
flutter run -t lib/main_dev.dart
```

### 8.2 Scanner input not detected

This app reads a hardware keyboard-wedge scanner, not a camera — confirm
the physical scanner is paired/connected as a keyboard input device, and
that the method channel name (`com.sg.scanner/scanner`) matches on both
the native and Dart sides (this channel name is an arbitrary string, kept
unchanged across the applicationId rename).

### 8.3 Duplicate injectable registrations

Make sure no two classes are registered as the same abstract type under the
same scope.

## 9. References

- Flutter docs: https://docs.flutter.dev/
- Bloc library: https://bloclibrary.dev/
- Freezed: https://pub.dev/packages/freezed
- Injectable: https://pub.dev/packages/injectable
- GetIt: https://pub.dev/packages/get_it
- mqtt_client: https://pub.dev/packages/mqtt_client
