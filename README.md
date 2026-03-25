# Tracking App
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/Mohamed-Ehab-Elsawy/Tracking-App)

## Overview

A robust Flutter application designed for delivery drivers to manage and track orders efficiently. The app features a clean, feature-driven architecture and integrates with Firebase for real-time data synchronization and notifications. It supports drivers through the entire delivery lifecycle, from signing up and logging in to viewing pending orders, managing their profiles, and viewing their order history.

## Features

- **Driver Authentication**: Secure login, a comprehensive application form for new drivers, and a full-featured password reset flow (email verification, OTP, and password update).
- **Order Management**: A real-time dashboard of pending orders, allowing drivers to view and manage incoming delivery requests.
- **Order History**: A complete history of all past orders, categorized by status (e.g., 'completed', 'canceled').
- **Detailed Order View**: In-depth details for each order, including pickup and delivery addresses, item specifics, and payment information.
- **Profile Management**: Drivers can view and edit their personal information, update their phone number and email, and change their password.
- **Photo Upload**: Functionality to upload and update profile pictures directly from the device's camera or gallery.
- **Multi-language Support**: Fully localized for both English and Arabic using `easy_localization`.
- **Push Notifications**: Integrated with Firebase Cloud Messaging (FCM) to deliver real-time notifications to drivers.

## Architecture

This project follows the principles of **Clean Architecture**, promoting a separation of concerns that makes the codebase scalable, maintainable, and testable.

- **`lib/core`**: Contains shared application-wide components, including:
    - API client (`Dio`, `Retrofit`)
    - Dependency Injection setup (`GetIt`, `Injectable`)
    - Theming and constants
    - Routing logic
    - Error handling and custom widgets
- **`lib/features`**: The application is divided into distinct feature modules (e.g., `auth`, `home`, `orders`, `profile`). Each feature is structured into three layers:
    - **Domain**: Contains the core business logic, including entities, use cases, and repository interfaces. This layer is independent of any framework.
    - **Data**: Implements the repositories defined in the domain layer. It's responsible for fetching data from remote (API) and local sources.
    - **Presentation**: The UI layer, which includes views (widgets) and state management logic (BLoC/Cubit), responsible for presenting data to the user and handling user input.

## Tech Stack & Dependencies

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it` & `injectable`
- **Networking**: `dio` & `retrofit`
- **Routing**: `MaterialApp`'s `onGenerateRoute`
- **Localization**: `easy_localization`
- **Environment Variables**: `envied`
- **Backend Services**: Firebase (Firestore, Cloud Messaging)
- **CI/CD**: GitHub Actions

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK (version 3.10.4 or higher recommended)
- An editor like VS Code or Android Studio

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/Mohamed-Ehab-Elsawy/Tracking-App.git
    cd Tracking-App
    ```

2.  **Set up Firebase:**
    - For **Android**, place your `google-services.json` file in `android/app/`.
    - For **iOS**, place your `GoogleService-Info.plist` file in `ios/Runner/`.



3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the code generator:**
    This command generates necessary files for dependency injection, networking, and environment variables.
    ```sh
    dart run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

The project is organized into a feature-first directory structure to ensure modularity and scalability.

```
lib/
├── core/               # Shared logic, widgets, and utilities
│   ├── api/            # API client, models, DI module
│   ├── bloc/           # Base BLoC observer and states
│   ├── constants/      # App-wide constants
│   ├── di/             # Dependency injection setup
│   ├── error_handling/ # Custom exception handling
│   ├── local/          # Local storage (SharedPreferences)
│   ├── presentation/   # Reusable widgets and UI components
│   ├── route/          # App routing logic
│   ├── services/       # Firebase services (FCM, Firestore)
│   └── theme/          # App theming and styling
│
└── features/           # Feature-based modules
    ├── auth/           # Authentication (login, apply, etc.)
    ├── home/           # Home screen with pending orders
    ├── orders/         # Order history and details
    ├── profile/        # User profile management
    └── ...             # Other feature modules
```

## Continuous Integration & Deployment (CI/CD)

This project utilizes GitHub Actions to automate several development workflows:
- **Linting & Formatting**: Enforces a consistent code style across the project on every pull request.
- **Unit & Widget Testing**: Automatically runs all tests to ensure code quality and prevent regressions.
- **Branch & PR Title Validation**: Ensures that branch names and pull request titles follow a conventional format (`type/scope`).
- **Firebase Distribution**: Automatically builds and distributes the app to QA testers via Firebase App Distribution when a PR is labeled `ReadyForTesting`.
