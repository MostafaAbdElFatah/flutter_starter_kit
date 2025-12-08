# Flutter Starter Kit Documentation

## Overview
This project is a production-ready Flutter Starter Kit designed with scalability, maintainability, and best practices in mind. It follows **Clean Architecture** principles and utilizes a robust tech stack to provide a solid foundation for building complex mobile applications.

## Architecture
The project adheres to **Clean Architecture**, separating concerns into three distinct layers:

1.  **Presentation Layer**:
    *   **Widgets/Pages**: UI components.
    *   **State Management**: Uses `flutter_bloc` (Cubits) to manage state.
    *   **Logic**: Handles user interaction and communicates with the Domain layer.

2.  **Domain Layer** (Inner Layer):
    *   **Entities**: Pure Dart objects representing core business data.
    *   **Repositories (Interfaces)**: Abstract definitions of data operations.
    *   **UseCases**: Encapsulate specific business rules and application logic (e.g., [LoginUseCase](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/features/auth/domain/usecases/login_usecase.dart#12-28), `GetLanguageUseCase`).

3.  **Data Layer**:
    *   **Data Sources**: Implementations for fetching data (Remote API, Local Storage).
    *   **Models**: Data Transfer Objects (DTOs) that handle JSON serialization/deserialization.
    *   **Repositories (Implementations)**: Concrete implementations of Domain repositories, coordinating data sources.

## Project Structure
The codebase is organized by feature, with a shared `core` module.

```
lib/
├── app.dart                # Main App widget (Theme, Router, Localization)
├── main.dart               # Entry point (DI setup, App launch)
├── core/                   # Shared utilities and infrastructure
│   ├── assets/             # Localization keys, image paths
│   ├── config/             # App configuration (Env, BaseURL)
│   ├── constants/          # Global constants
│   ├── di/                 # Dependency Injection setup (GetIt, Injectable)
│   ├── errors/             # Custom failures and exceptions
│   ├── extensions/         # Dart extensions
│   ├── infrastructure/     # Third-party wrappers (if any)
│   ├── network/            # Dio setup, Interceptors
│   ├── router/             # GoRouter configuration
│   ├── storage/            # Hive and SecureStorage services
│   ├── theme/              # App themes (Light/Dark)
│   ├── usecases/           # Base UseCase class
│   └── utils/              # Helper functions (Logger, etc.)
└── features/               # Feature modules
    ├── auth/               # Authentication (Login, Register)
    ├── home/               # Home screen
    ├── onboarding/         # Onboarding flow
    ├── settings/           # App settings (Language, Environment)
    └── splash/             # Splash screen
```

## Key Features & Modules

### 1. Dependency Injection (DI)
*   **Package**: `get_it`, `injectable`
*   **Setup**: [lib/core/di/di.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/di/di.dart)
*   **Usage**: Classes are annotated with `@injectable`, `@singleton`, or `@lazySingleton`. `build_runner` generates the registration code.

### 2. Networking
*   **Package**: [dio](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/network/dio_module.dart#14-42)
*   **Setup**: [lib/core/network/dio_module.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/network/dio_module.dart)
*   **Features**:
    *   **Interceptors**: [APIInterceptor](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/network/api_interceptor.dart#15-59) handles headers (Authorization, API Key) and error handling.
    *   **Configuration**: Base URL and timeouts are configurable via `AppConfig`.

### 3. Storage
*   **Packages**: `hive`, `flutter_secure_storage`
*   **Services**:
    *   [StorageService](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/storage/storage_service.dart#25-80): Key-value storage using Hive (for non-sensitive data like settings).
    *   [SecureStorageService](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/storage/secure_storage_service.dart#15-61): Encrypted storage (for tokens, credentials).

### 4. Navigation
*   **Package**: `go_router`
*   **Setup**: [lib/core/router/app_router.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/router/app_router.dart)
*   **Routes**: Defined as named routes for type safety and clarity.

### 5. Localization
*   **Package**: `easy_localization`
*   **Assets**: JSON files in `assets/translations/`.
*   **Keys**: Generated/Managed in [lib/core/assets/localization_keys.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/assets/localization_keys.dart).

### 6. Configuration & Environments
*   **Service**: `ConfigService`
*   **Features**:
    *   Supports **Dev**, **Stage**, and **Prod** environments.
    *   Runtime environment switching via **Settings**.
    *   Custom Base URL support for testing.

## Setup & Running

### Prerequisites
*   Flutter SDK (latest stable recommended)
*   Dart SDK

### Installation
1.  **Get Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Generate Code** (DI, JSON, Mocks):
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### Running the App
*   **Development**:
    ```bash
    flutter run
    ```
    (Note: The app defaults to the Dev environment configuration).

## Testing
The project includes a comprehensive unit testing setup.

*   **Location**: [test/](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/.env.test) (mirrors `lib/` structure).
*   **Tools**: `flutter_test`, `mockito`.
*   **Helper**: [test/helpers/test_helper.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/test/helpers/test_helper.dart) contains common mocks and setup.

### Running Tests
```bash
flutter test
```

## How to Add a New Feature

Follow this checklist to add a new feature (e.g., `Profile`) while maintaining Clean Architecture:

1.  **Create Directory Structure**:
    ```
    lib/features/profile/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── cubit/
        ├── pages/
        └── widgets/
    ```

2.  **Domain Layer**:
    *   Define **Entities** in `domain/entities/`.
    *   Define **Repository Interface** in `domain/repositories/`.
    *   Create **UseCases** in `domain/usecases/`.

3.  **Data Layer**:
    *   Create **Models** (DTOs) in `data/models/` (extend Entities, add `fromJson`/`toJson`).
    *   Define **DataSources** (Remote/Local) in `data/datasources/`.
    *   Implement **Repository** in `data/repositories/`.

4.  **Dependency Injection**:
    *   Annotate DataSources, Repositories, and UseCases with `@injectable` / `@lazySingleton`.
    *   Run `flutter pub run build_runner build` to register them.

5.  **Presentation Layer**:
    *   Create **Cubit** in `presentation/cubit/` (inject UseCases).
    *   Create **Page** in `presentation/pages/`.
    *   Add route to [lib/core/router/app_router.dart](file:///Users/m.abdelfatah/.gemini/antigravity/scratch/flutter_starter_kit/lib/core/router/app_router.dart).

6.  **Testing**:
    *   Mirror the structure in `test/features/profile/`.
    *   Write unit tests for DataSources, Repositories, UseCases, and Cubits.
