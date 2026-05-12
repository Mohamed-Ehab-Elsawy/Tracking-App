# 🚚 Tracking App

> A robust Flutter application designed for delivery drivers to manage and track orders efficiently — built with Clean Architecture, BLoC state management, Firebase, and full Arabic/English localization.

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10%2B-blue?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Clean%20Architecture-✓-success)](#architecture)
[![State Management](https://img.shields.io/badge/BLoC-orange)](#packages-used)
[![CI/CD](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=githubactions&logoColor=white)](#cicd)

---

## 📖 Description

**Tracking App** is a production-ready Flutter mobile application that supports delivery drivers through the entire delivery lifecycle — from sign-up and login, to viewing pending orders, tracking pickup locations, managing their profile, and reviewing their full order history. The app integrates with Firebase for real-time data synchronization and push notifications, and supports both English and Arabic via `easy_localization`.

---

## ✨ Features

- **Driver Authentication** — Secure login, a comprehensive application form for new drivers, and a full-featured password reset flow (email verification, OTP, and password update).
- **Order Management** — A real-time dashboard of pending orders, allowing drivers to view and manage incoming delivery requests.
- **Order History** — A complete history of all past orders, categorized by status (e.g., 'completed', 'canceled').
- **Detailed Order View** — In-depth details for each order, including pickup and delivery addresses, item specifics, and payment information.
- **Profile Management** — Drivers can view and edit their personal information, update their phone number and email, and change their password.
- **Photo Upload** — Functionality to upload and update profile pictures directly from the device's camera or gallery.
- **Multi-language Support** — Fully localized for both English and Arabic using `easy_localization`.
- **Push Notifications** — Integrated with Firebase Cloud Messaging (FCM) to deliver real-time notifications to drivers.

---

## 📸 Screenshots

<table>
  <tr>
    <td align="center"><b>Onboarding</b></td>
    <td align="center"><b>Login</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/d4a06ee1-4fdc-4e8f-b6e9-f8dd47d859dd" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/95299b3d-9c5e-4442-bcf1-99beb24cf531" /></td>
  </tr>
  <tr>
    <td align="center"><b>Login (Filled)</b></td>
    <td align="center"><b>Login (Email Error)</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/03022184-2153-44f7-826a-5021d7adb8e8" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/052df8f1-aedc-4bc4-8839-f44270dfd5f7" /></td>
  </tr>
  <tr>
    <td align="center"><b>Login (Password Error)</b></td>
    <td align="center"><b>Forget Password</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/70be6f25-4a9f-48ca-9f99-698769936cd4" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/f3d6f3c3-3c46-4a69-a261-7c78123f8670" /></td>
  </tr>
  <tr>
    <td align="center"><b>Forget Password (Alt)</b></td>
    <td align="center"><b>Reset Password</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/064fdd01-0d29-483e-8362-a944a69368d0" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/459ff225-10a0-4a6b-a191-10054189224b" /></td>
  </tr>
  <tr>
    <td align="center"><b>Reset Password (Step 2)</b></td>
    <td align="center"><b>Success</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/4bf03f94-2e19-47c0-aa59-d1cf5e05fb5c" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/4587bbb7-0652-4461-836c-583397fccbde" /></td>
  </tr>
  <tr>
    <td align="center"><b>Home</b></td>
    <td align="center"><b>Order</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/37ea2894-b58c-4bd7-a0e0-3054173f4751" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/a4376b48-8259-4f9f-8409-3f1209ac94cc" /></td>
  </tr>
  <tr>
    <td align="center"><b>Order Details</b></td>
    <td align="center"><b>Order Details (Step 1)</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/232cbb3f-09c1-4a03-8cb1-0f8eea89df0f" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/a64004a3-7775-4993-b458-884241a108f1" /></td>
  </tr>
  <tr>
    <td align="center"><b>Order Details (Step 1 Alt)</b></td>
    <td align="center"><b>Order Details (Step 2)</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/f39780d5-5630-467b-a57e-01fd8dc801d8" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/accc326f-af93-4ecb-8b27-f61df9025bf5" /></td>
  </tr>
  <tr>
    <td align="center"><b>Order Details (Step 3)</b></td>
    <td align="center"><b>Order Details (Step 4)</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/80001d15-43a2-4aed-95c8-874d5c0746dd" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/de7e904f-918a-4380-9ae6-cf7e31ef3a57" /></td>
  </tr>
  <tr>
    <td align="center"><b>Order Details (Step 5)</b></td>
    <td align="center"><b>Pickup Location</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/2ed66767-1b8e-42e6-a6b2-c5b8b73b5efb" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/88657b98-02db-422c-93d1-008d91b529a3" /></td>
  </tr>
  <tr>
    <td align="center"><b>Profile</b></td>
    <td align="center"><b>Edit Profile</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/e9cfd02d-e355-41c5-b958-e028432043dc" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/1faf9980-8e64-41df-96b5-6079f520258b" /></td>
  </tr>
  <tr>
    <td align="center"><b>Edit Profile (Alt)</b></td>
    <td align="center"><b>Logout</b></td>
  </tr>
  <tr>
    <td><img width="375" src="https://github.com/user-attachments/assets/1f7b9be4-2529-4010-a8ee-b05c67adaa17" /></td>
    <td><img width="375" src="https://github.com/user-attachments/assets/10ced63c-f8a9-4b6f-bf6a-b9220783fc9d" /></td>
  </tr>
</table>

---

## 🏛️ Architecture

This project follows **Clean Architecture** principles with a **Feature-First** directory layout, ensuring a clear separation of concerns, high testability, and easy scalability.

```
lib/
├── core/
│   ├── api/              # Dio client, Retrofit setup, interceptors
│   ├── bloc/             # Base BLoC observer and shared states
│   ├── constants/        # App-wide constants
│   ├── di/               # Dependency injection setup (GetIt, Injectable)
│   ├── error_handling/   # Custom exception & failure handling
│   ├── local/            # Local storage (SharedPreferences, SecureStorage)
│   ├── presentation/     # Reusable widgets and UI components
│   ├── route/            # App routing logic
│   ├── services/         # Firebase services (FCM, Firestore)
│   └── theme/            # App theming and styling
│
└── features/
    ├── auth/             # Login, sign-up, forgot/reset password
    ├── home/             # Home dashboard with pending orders
    ├── orders/           # Order history and detailed order view
    ├── profile/          # Profile view, edit, photo upload
    └── ...               # Other feature modules
```

| Layer | Responsibility |
|---|---|
| **presentation** | UI layer — Screens, Widgets, BLoC/Cubit. Depends only on `domain`. |
| **domain** | Business logic — Entities, Use Cases, Repository interfaces. Framework-independent. |
| **data** | Data layer — API calls, models, repository implementations via Dio + Retrofit. |
| **core** | Shared infrastructure — DI, base classes, routing, Firebase services, utilities. |

---

## 📦 Packages Used

### 🧠 State Management & Architecture
| Package | Purpose |
|---|---|
| `flutter_bloc` | BLoC / Cubit pattern state management |
| `get_it` | Service locator for dependency injection |
| `injectable` | Code-gen annotations for `get_it` wiring |
| `equatable` | Value equality for BLoC states and events |

### 🌐 Networking
| Package | Purpose |
|---|---|
| `dio` | HTTP client for API requests |
| `retrofit` | Type-safe REST API client generator |
| `pretty_dio_logger` | Human-readable request/response logging |
| `json_annotation` | JSON serialization annotations |
| `http` | Standard HTTP client (used with FCM / googleapis) |

### 🔥 Firebase & Notifications
| Package | Purpose |
|---|---|
| `firebase_core` | Firebase SDK initialization |
| `firebase_messaging` | Firebase Cloud Messaging (FCM) push notifications |
| `cloud_firestore` | Real-time NoSQL Firestore database |
| `googleapis_auth` | Google API OAuth2 authentication |

### 🔐 Security & Environment
| Package | Purpose |
|---|---|
| `flutter_secure_storage` | Encrypted storage for auth tokens |
| `shared_preferences` | Lightweight key-value local storage |
| `envied` | Secure environment variable management (API base URLs) |

### 🌍 Localization
| Package | Purpose |
|---|---|
| `easy_localization` | Full English & Arabic multi-language support |

### 🗺️ Location & Maps
| Package | Purpose |
|---|---|
| `location` | Access device GPS location |
| `geocoding` | Convert coordinates to human-readable addresses |

### 🎨 UI & UX
| Package | Purpose |
|---|---|
| `flutter_svg` | SVG image rendering |
| `flutter_native_splash` | Native splash screen generation |
| `skeletonizer` | Skeleton loading placeholder UI |
| `lottie` | Lottie animation support |
| `cached_network_image` | Efficient network image caching |
| `loading_indicator` | Animated loading indicators |
| `pinput` | Customizable OTP / PIN input field |
| `awesome_dialog` | Beautiful dialog boxes |
| `badges` | Badge widgets for notification counts |
| `google_fonts` | Google Fonts (Inter) integration |
| `country_picker` | Country selection picker widget |
| `url_launcher` | Launch URLs, phone numbers, and maps |
| `image_picker` | Pick images from camera or gallery |
| `package_info_plus` | Read app version and package name |
| `cupertino_icons` | iOS-style icon set |

### 🛠️ Code Generation (Dev)
| Package | Purpose |
|---|---|
| `build_runner` | Code generation runner |
| `injectable_generator` | Generates DI registration code |
| `retrofit_generator` | Generates Retrofit API client code |
| `json_serializable` | Generates `fromJson` / `toJson` methods |
| `envied_generator` | Generates secure env variable accessors |
| `flutter_launcher_icons` | Auto-generate app launcher icons |

### 🧪 Testing (Dev)
| Package | Purpose |
|---|---|
| `bloc_test` | Utilities for testing BLoC/Cubit |
| `mockito` | Mock objects for unit testing |
| `flutter_lints` | Recommended Dart linting rules |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>= 3.10.4`
- Dart SDK `>= 3.10.4`
- A Firebase project with Android/iOS apps configured

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Mohamed-Ehab-Elsawy/Tracking-App.git
cd Tracking-App

# 2. Set up Firebase
#    - Place google-services.json in android/app/
#    - Place GoogleService-Info.plist in ios/Runner/

# 3. Install dependencies
flutter pub get

# 4. Run code generation (REQUIRED)
dart run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

> **Tip:** For active development, use `watch` mode to auto-regenerate files on change:
> ```bash
> dart run build_runner watch --delete-conflicting-outputs
> ```

---

## 🧪 Running Tests

```bash
flutter test
```

---

## ⚙️ CI/CD

This project uses **GitHub Actions** to automate development workflows:

| Workflow | Description |
|---|---|
| **Lint & Format** | Enforces consistent code style on every pull request |
| **Unit & Widget Tests** | Automatically runs all tests to prevent regressions |
| **Branch & PR Validation** | Ensures branch names and PR titles follow `type/scope` convention |
| **Firebase Distribution** | Builds and distributes to QA testers via Firebase App Distribution when a PR is labeled `ReadyForTesting` |

---

## 📱 Platform Support

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
## 👥 Contributors
 
<div align="center">
 
A huge thank you to every developer who has poured their effort into this project! 🙏
 

<br/>
 
<table>
  <tr>
    <td align="center">
         <a href="https://github.com/Mohamed-Ehab-Elsawy">
        <img src="https://github.com/Mohamed-Ehab-Elsawy.png" width="90" style="border-radius:50%"/><br/>
        <sub><b>Mohamed Ehab Elsawy</b></sub>
      </a>
      <br/>
      <sub>🏆 Flutter Developer </sub>
      <br/>
      <br/>
      <img src="https://img.shields.io/badge/Owner-FF6B6B?style=flat-square"/>
    </td>
    <td align="center">
      <a href="https://github.com/Mahamed-Kamal">
        <img src="https://github.com/Mahamed-Kamal.png" width="90" style="border-radius:50%"/><br/>
        <sub><b>Mahamed Kamal</b></sub>
      </a>
      <br/>
          <sub>🏆 Flutter Developer </sub>
      <br/>
      <br/>
      <img src="https://img.shields.io/badge/Contributor-4ECDC4?style=flat-square"/>
    </td>
    <td align="center">
      <a href="https://github.com/AbdelrahmanAyman1">
        <img src="https://github.com/AbdelrahmanAyman1.png" width="90" style="border-radius:50%"/><br/>
        <sub><b>Abdelrahman Ayman</b></sub>
      </a>
      <br/>
          <sub>🏆 Flutter Developer </sub>
      <br/>
      <br/>
      <img src="https://img.shields.io/badge/Contributor-4ECDC4?style=flat-square"/>
    </td>
    <td align="center">
      <a href="https://github.com/Abdo0Salah">
        <img src="https://github.com/Abdo0Salah.png" width="90" style="border-radius:50%"/><br/>
        <sub><b>Abdo Salah</b></sub>
      </a>
      <br/>
          <sub>🏆 Flutter Developer </sub>
      <br/>
      <br/>
      <img src="https://img.shields.io/badge/Contributor-4ECDC4?style=flat-square"/>
    </td>
    <td align="center">
         <a href="https://github.com/OmarWheed">
        <img src="https://github.com/OmarWheed.png" width="90" style="border-radius:50%"/><br/>
        <sub><b>Omar Wheed</b></sub>
      </a>
      <br/>
          <sub>🏆 Flutter Developer </sub>
      <br/>
      <br/>
      <img src="https://img.shields.io/badge/Contributor-4ECDC4?style=flat-square"/>
    </td>
  </tr>
</table>
 
<br/>
