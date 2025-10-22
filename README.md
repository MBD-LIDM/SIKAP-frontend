# SIKAP - Student Wellbeing & Anti-Bullying Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6.2-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.6.2-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Version](https://img.shields.io/badge/version-0.1.0-blue)

A Flutter-based mobile application designed to promote student wellbeing, mental health awareness, and provide anti-bullying support.

[Features](#-features) • [Getting Started](#-getting-started) • [Installation](#-installation) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [About](#-about)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Project Structure](#-project-structure)
- [Development](#-development)
  - [Code Style](#code-style)
  - [Testing](#testing)
  - [Build & Release](#build--release)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 🎯 About

SIKAP (Sistem Informasi Kesejahteraan dan Anti-Perundungan) is a comprehensive student wellbeing platform that combines mental health monitoring, anti-bullying reporting, and wellbeing resources into a single, user-friendly mobile application.

### Mission
To create a safe, supportive digital environment where students can:
- Monitor and track their mental wellbeing
- Report and address bullying incidents confidentially
- Access mental health resources and support
- Build a healthier school community

---

## ✨ Features

### 🏠 Dashboard
- **Home Overview**: Quick access to all features and recent activities
- **User-friendly Interface**: Clean, intuitive design for all age groups

### 😊 Mood Check
- Daily mood tracking and journaling
- Visual mood history and patterns
- Personalized insights and recommendations

### 🛡️ Bullying Reporting
- Confidential incident reporting system
- Anonymous submission options
- Real-time case tracking
- Evidence upload capabilities

### 💚 Wellbeing Resources
- Mental health articles and guides
- Self-help tools and coping strategies
- Professional support contacts
- Crisis helpline information

### 👤 Account Management
- User profile customization
- Privacy settings and controls
- Notification preferences
- Activity history

---

## 📱 Screenshots

> *Coming soon - Add your app screenshots here*

---

## 🛠 Tech Stack

### Framework & Language
- **[Flutter](https://flutter.dev/)** - UI framework for cross-platform development
- **[Dart](https://dart.dev/)** - Programming language

### Dependencies
- **google_fonts** (^6.1.0) - Custom typography
- **flutter_svg** (^2.0.9) - SVG rendering support

### Dev Dependencies
- **flutter_lints** (^5.0.0) - Dart linting rules
- **flutter_test** - Testing framework

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.6.2 or higher)
  ```bash
  flutter --version
  ```
- **Dart SDK** (3.6.2 or higher)
- **Java JDK** 17, 21, or 25 (**Required for Android builds**)
  ```bash
  java -version
  ```
  > ⚠️ **Important**: This project requires Java 17 or newer. **Java 21 LTS or Java 25 is recommended** for best performance.
  > 
  > - **Java 25** (Latest) - Best performance, full Gradle 9.1.0 support - [Download](https://adoptium.net/)
  > - **Java 21 LTS** (Recommended) - Long-term support, stable - [Download](https://adoptium.net/)
  > - **Java 17 LTS** (Minimum) - Minimum requirement - [Download](https://adoptium.net/)
  > 
  > See [GRADLE_UPGRADE.md](./GRADLE_UPGRADE.md) for detailed compatibility information.
- **Android Studio** / **Xcode** (for iOS development)
- **VS Code** or **Android Studio** with Flutter plugins
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MBD-LIDM/SIKAP-frontend.git
   cd SIKAP-frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Make sure all required dependencies are installed.

### Running the App

#### Development Mode

**Android:**
```bash
flutter run
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

**Specific Device:**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

#### Debug Mode
```bash
flutter run --debug
```

#### Release Mode
```bash
flutter run --release
```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── core/                     # Core functionality
│   └── theme/               # App theming
│       ├── app_theme.dart
│       └── README.md
│
└── features/                # Feature modules
    ├── accounts/            # User account management
    ├── bullying/            # Bullying reporting system
    ├── home/                # Dashboard/home screen
    ├── mood_check/          # Mood tracking feature
    └── wellbeing_resources/ # Mental health resources
```

### Architecture Pattern

This project follows **Clean Architecture** principles with a feature-first organization:

- **features/**: Each feature is self-contained with its own layers
  - `presentation/`: UI components (pages, widgets)
  - `domain/`: Business logic (entities, use cases)
  - `data/`: Data sources (repositories, models, APIs)
- **core/**: Shared utilities, themes, and constants

---

## 💻 Development

### Code Style

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

**Run linter:**
```bash
flutter analyze
```

**Format code:**
```bash
flutter format .
```

### Testing

**Run all tests:**
```bash
flutter test
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

**View coverage report:**
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Build & Release

#### Android

**Build APK:**
```bash
flutter build apk --release
```

**Build App Bundle:**
```bash
flutter build appbundle --release
```

#### iOS

**Build iOS:**
```bash
flutter build ios --release
```

#### Web

**Build Web:**
```bash
flutter build web --release
```

---

## 📚 Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Gradle Upgrade Guide](./GRADLE_UPGRADE.md) - **Build configuration and Java requirements**
- [API Documentation](./docs/API.md) *(coming soon)*
- [User Guide](./docs/USER_GUIDE.md) *(coming soon)*

---

## 🤝 Contributing

We welcome contributions from the community! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style and architecture
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact

**Project Maintainer:** MBD-LIDM  
**Repository:** [SIKAP-frontend](https://github.com/MBD-LIDM/SIKAP-frontend)

For questions, suggestions, or support, please [open an issue](https://github.com/MBD-LIDM/SIKAP-frontend/issues).

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors who help improve this project
- Educational institutions supporting student wellbeing initiatives

---

<div align="center">

**Made with ❤️ for student wellbeing in Indonesia**

⭐ Star this repo if you find it helpful!

</div>
