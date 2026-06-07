# Flutter Tourism App File Structure

This document outlines the proposed file structure for the AI-powered tourism application.

```
lib/
|-- main.dart                 # App entry point
|-- app/                      # Core application setup (routing, themes, etc.)
|   |-- app.dart
|   |-- routes/
|   |   |-- app_routes.dart
|   |   |-- app_pages.dart
|   |-- themes/
|   |   |-- app_theme.dart
|   |-- bindings/             # Dependency injection bindings
|       |-- initial_binding.dart
|-- core/                     # Core utilities, constants, base classes
|   |-- constants/
|   |   |-- app_constants.dart
|   |   |-- api_endpoints.dart
|   |-- utils/
|   |   |-- logger.dart
|   |   |-- helpers.dart
|   |-- network/
|   |   |-- api_client.dart
|   |   |-- network_exceptions.dart
|   |-- ai/                     # AI model integration/logic
|   |   |-- crowd_predictor.dart
|   |   |-- safety_identifier.dart
|   |-- services/             # Core services (location, permissions)
|       |-- location_service.dart
|       |-- permission_service.dart
|-- data/                     # Data layer (repositories, models, sources)
|   |-- models/
|   |   |-- user_model.dart
|   |   |-- place_model.dart
|   |   |-- passport_model.dart
|   |   |-- credit_transaction_model.dart
|   |-- repositories/
|   |   |-- auth_repository.dart
|   |   |-- user_repository.dart
|   |   |-- place_repository.dart
|   |   |-- passport_repository.dart
|   |   |-- credit_repository.dart
|   |-- datasources/
|   |   |-- local/              # Local data storage (e.g., SQLite, SharedPreferences)
|   |   |   |-- db_helper.dart
|   |   |   |-- local_storage.dart
|   |   |-- remote/             # Remote API interactions
|   |       |-- auth_api.dart
|   |       |-- user_api.dart
|   |       |-- place_api.dart
|   |       |-- passport_api.dart
|   |       |-- credit_api.dart
|-- features/                 # Feature modules
|   |-- auth/                 # Authentication (Login, Signup)
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- login_controller.dart
|   |   |   |   |-- signup_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- login_screen.dart
|   |   |   |   |-- signup_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- auth_button.dart
|   |-- home/                 # Main dashboard/home screen
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- home_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- home_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- recommendation_card.dart
|   |   |       |-- credit_summary.dart
|   |-- map/                  # Map view, place recommendations
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- map_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- map_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- place_marker.dart
|   |   |       |-- crowd_indicator.dart
|   |-- passport/             # Passport scanning and management
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- passport_scan_controller.dart
|   |   |   |   |-- passport_manage_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- passport_scan_screen.dart
|   |   |   |   |-- passport_manage_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- scan_overlay.dart
|   |-- credits/              # Credit history and redemption
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- credit_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- credit_history_screen.dart
|   |   |   |   |-- redemption_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- credit_transaction_item.dart
|   |   |       |-- redeem_option.dart
|   |-- profile/              # User profile management
|   |   |-- presentation/
|   |   |   |-- controllers/
|   |   |   |   |-- profile_controller.dart
|   |   |   |-- screens/
|   |   |   |   |-- profile_screen.dart
|   |   |   |-- widgets/
|   |   |       |-- profile_details.dart
|-- generated/                # Generated code (e.g., localization, routes)
|-- assets/                   # Static assets (images, fonts, etc.)
|   |-- images/
|   |-- fonts/
|   |-- translations/         # Localization files
|-- test/                     # Unit and widget tests
```

## Explanation:

*   **`lib/`**: Contains all the Dart code for the application.
    *   **`main.dart`**: The main entry point of the Flutter application.
    *   **`app/`**: Core application setup including routing (using GetX or similar), themes, and initial dependency injection bindings.
    *   **`core/`**: Shared utilities, constants, base classes, network clients, AI logic integration, and core services like location or permissions used across multiple features.
    *   **`data/`**: Handles all data operations. It's divided into:
        *   **`models/`**: Defines the data structures (e.g., User, Place).
        *   **`repositories/`**: Abstract interfaces defining data operations (e.g., fetching user data).
        *   **`datasources/`**: Concrete implementations for fetching data, separated into `local` (device storage) and `remote` (API calls).
    *   **`features/`**: Contains the specific features of the app (e.g., Authentication, Home, Map, Passport, Credits, Profile). Each feature is a self-contained module, often following a structure like:
        *   **`presentation/`**: UI layer (Screens/Views, Controllers/ViewModels, Widgets).
        *   **`data/` / `domain/`**: Optional layers for feature-specific data or business logic if it doesn't fit in the core `data` layer.
    *   **`generated/`**: Code generated by build tools (e.g., for localization, routing).
*   **`assets/`**: Stores static assets like images, fonts, and translation files.
*   **`test/`**: Contains unit, widget, and integration tests for the application.

This structure promotes modularity, separation of concerns, and testability, making the codebase easier to manage and scale.
