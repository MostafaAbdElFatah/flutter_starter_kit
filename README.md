# Flutter Starter Kit

A production-ready Flutter starter kit featuring Clean Architecture, Dio networking, Secure Storage, and essential features.

## Features

- **Clean Architecture**: Separation of concerns into Presentation, Domain, and Data layers.
- **State Management**: `flutter_bloc` for predictable state management.
- **Networking**: `Dio` with interceptors, error handling, and unified API responses.
- **Storage**: Secure storage for tokens and SharedPreferences for flags.
- **Routing**: `go_router` for declarative routing.
- **Dependency Injection**: `get_it` for scalable service location.
- **Theming**: Light and Dark mode support.
- **Ready-to-use**: Splash screen and Onboarding flow included.

## Getting Started

1.  **Clone the repository**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Architecture Overview

```
lib/
  core/         # Shared utilities, network, storage, etc.
  features/     # Feature-based modules
    auth/
    home/
    splash/
    onboarding/
```

## Configuration

- **API Base URL**: Update `lib/core/constants/app_constants.dart`
- **Theme**: Customize `lib/core/theme/app_theme.dart`
