# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

This is an XRP Monitor Flutter application that provides real-time XRP cryptocurrency tracking. The app features multiple tabs for monitoring XRP price charts, news, Twitter feeds, YouTube videos, and user settings.

## Development Commands

### Setup & Configuration
```bash
# Initial project setup
./configure.sh
# On Windows: configure.bat

# Clean generated files
./clean.sh
# On Windows: clean.bat
```

### Code Generation
```bash
# Watch mode for continuous code generation (recommended during development)
./code_generator.sh
# On Windows: code_generator.bat

# One-time code generation
fvm dart run build_runner build --delete-conflicting-outputs
```

### Flutter Commands
```bash
# Install dependencies
fvm flutter pub get

# Run the app
fvm flutter run

# Build for release
fvm flutter build apk
fvm flutter build ios

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Architecture

### State Management
- **Riverpod**: Primary state management solution using `flutter_riverpod` and `hooks_riverpod`
- **Code Generation**: Uses `riverpod_generator` for automatic provider generation
- **Hooks**: Integrates Flutter Hooks for widget lifecycle management

### Routing
- **Auto Route**: Uses `auto_route` for declarative routing with code generation
- **Main Routes**: 
  - `/` - TabsRootScreen (main container)
  - `/monitor` - HomeRoute (XRP price monitoring)
  - `/news` - NewsRoute (XRP news)
  - `/tweets` - TweetRoute (XRP Twitter feed)
  - `/videos` - YoutubeRoute (XRP YouTube videos)
  - `/profile` - ProfileRoute (settings)

### Project Structure
```
lib/
├── constants/          # App-wide constants and enums
├── core/               # Core functionality
│   ├── models/         # Data models with Freezed
│   ├── route/          # Auto Route configuration
│   └── services/       # Core services (API, auth, session)
├── service/            # Business logic services
│   ├── authentication/ # Auth services and models
│   ├── file_service/   # File handling services
│   └── storage/        # Local storage services
├── ui/                 # UI components
│   ├── screen/         # Screen widgets
│   ├── themes/         # App themes
│   └── utils/          # UI utilities
└── widgets/            # Reusable widgets
    ├── appbar/         # App bar components
    ├── base/           # Base widget controllers
    └── dialog/         # Dialog widgets
```

### Code Generation
The project heavily uses code generation for:
- **Freezed**: Immutable data classes (`*.freezed.dart`)
- **JSON Serialization**: JSON serialization (`*.g.dart`)
- **Auto Route**: Route generation (`*.gr.dart`)
- **Riverpod**: Provider generation

Always run `./code_generator.sh` in watch mode during development to automatically regenerate code.

### Key Dependencies
- **UI**: `flutter_screenutil`, `flutter_hooks`, `lottie`, `card_swiper`
- **Networking**: `dio`, `http`
- **Storage**: `shared_preferences`
- **Firebase**: `firebase_messaging`, `flutter_local_notifications`
- **Utilities**: `permission_handler`, `device_info_plus`, `url_launcher`

### Development Tools
- **FVM**: Flutter Version Management (commands prefixed with `fvm`)
- **Build Runner**: Code generation in watch mode
- **Linting**: Uses `flutter_lints` and `riverpod_lint`

### Commit Convention
This project uses conventional commits with emojis:
- ✨ Feat: New features
- 🐛 Fix: Bug fixes  
- ⭐️ Style: Code formatting
- ♻️ Refactor: Code refactoring
- 📝 Docs: Documentation updates
- 🔧 Chore: Configuration changes

## Tips
- Always use FVM commands (`fvm flutter`, `fvm dart`) for consistency
- Keep code generator running in watch mode during development
- Follow the established folder structure when adding new features
- Use Freezed for all data models to maintain immutability
- Implement proper error handling in all API services