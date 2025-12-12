# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DPlanner is a Flutter mobile application for club/group management with features including reservations, posts, and member management.

## Requirements

- Flutter 3.24.5
- Dart 3.5.4
- Kotlin 1.9.0 (Android)
- CocoaPods 1.16.2 (iOS)

## Common Commands

```bash
# Run the app
flutter run

# Build for release
flutter build apk          # Android
flutter build ios          # iOS

# Analyze code for errors
flutter analyze

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean
```

## Refactoring in Progress

The codebase is being refactored from `/lib` (legacy) to `/lib_new` (new architecture). **The view layer refactoring is still in progress.**

### Legacy Architecture (`/lib`)
- Flat structure with `pages/`, `widgets/`, `controllers/`, `services/`, `models/`
- Uses GetX with 4 global controllers initialized in `main.dart`
- API services use static methods with `http` package
- Base URL: `http://3.39.102.31:8080`

### New Architecture (`/lib_new`)
Uses clean architecture with GetX:

```
lib_new/
├── main.dart
├── config/
│   ├── bindings/      # AppBindings - DI setup for providers and services
│   ├── routings/      # Routes class and appPages list
│   ├── themes/        # AppTheme definitions
│   └── constants/     # AppColors, ad unit IDs
└── app/
    ├── base/          # Base exceptions
    ├── data/
    │   ├── model/     # Domain models organized by feature (club/, post/, etc.)
    │   └── provider/
    │       └── api/   # API providers extending BaseApiProvider (GetConnect)
    │                  # Includes interceptors/ for auth, logging, response handling
    ├── service/       # Business logic services (GetxService)
    ├── ui/
    │   ├── base/      # Shared UI components (widgets/, pages/)
    │   └── pages/     # Feature pages, each with:
    │                  # - {feature}_page.dart (GetView<Controller>)
    │                  # - {feature}_controller.dart
    │                  # - {feature}_bindings.dart
    │                  # - {feature}_validator.dart (optional)
    │                  # - widgets/ (page-specific widgets)
    │                  # - views/ (sub-views with own controllers)
    └── utils/         # Utility functions (token, compression, etc.)
```

### Key Architectural Differences

| Aspect | Legacy (`/lib`) | New (`/lib_new`) |
|--------|-----------------|------------------|
| API Client | `http` package, static methods | `GetConnect` with interceptors |
| Base URL | `http://3.39.102.31:8080` | `http://api.dplanner.co.kr` |
| DI | Manual `Get.put()` in main | `AppBindings` with `Get.lazyPut()` |
| Controllers | Global (ClubController, etc.) | Page-scoped via bindings |
| Routes | String literals in `routes.dart` | `Routes` class constants |
| Page Structure | Single file pages | Page + Controller + Bindings pattern |

### View Layer Refactoring Status

**Completed pages** (exist in `lib_new/app/ui/pages/`):
- login, eula_agree, club_list, club_create, club_create_success
- club_find, club_join, club_join_success
- timetable (most complex - has sub-views with own controllers)

**Pending pages** (need to be migrated from `lib/pages/`):
- post_list, post_create, post_edit, post_detail
- my, my_profile, my_post_list, my_reservation_list
- club_profile, club_profile_edit, club_manage_menu
- club_member_list, club_manager_list, club_resource_list, club_reservation_list
- alert_message_list, app_setting_menu
- notification

### Page Structure Pattern (New)

Each page follows this pattern:
```dart
// {feature}_bindings.dart
class FeatureBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureController>(() => FeatureController());
  }
}

// {feature}_controller.dart
class FeatureController extends GetxController {
  final SomeService _service = Get.find<SomeService>();
  // Business logic
}

// {feature}_page.dart
class FeaturePage extends GetView<FeatureController> {
  @override
  Widget build(BuildContext context) {
    // Use controller.xxx
  }
}
```

### Export Convention

`lib_new/app/ui/pages/pages.dart` exports all page files. When adding new pages, add exports here:
```dart
export '{feature}/{feature}_page.dart';
export '{feature}/{feature}_bindings.dart';
```

## Authentication

Supports OAuth providers: Kakao, Naver, Google, Apple
- Tokens stored in `FlutterSecureStorage`
- JWT-based authentication with refresh token mechanism
- Token validation via `TokenUtils` (new) or `decode_token.dart` (legacy)

## Coding Conventions

### View Files
- View/Page 파일에는 `build` 메소드만 유지
- Helper 메소드(`_buildXxx`)를 만들지 말고 `build` 내에 인라인으로 작성
- 복잡한 로직은 Controller로 분리

## Styling

Colors: `AppColors` (new) or `AppColor` (legacy) - primary purple #7646D8
Font: Pretendard (custom font family)