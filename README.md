# 🎵 TuneZ Music App

<div align="center">
  <img src="assets/vectors/tunez_logo.svg" alt="TuneZ Logo" width="120" height="120">
  
  **Millions of songs. Free on TuneZ.**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.6.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.6.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
</div>

## 📖 Overview

TuneZ Music App is a comprehensive music streaming application built with Flutter, offering a rich musical experience with millions of songs. The app supports cross-platform deployment (iOS, Android, Web) with a modern interface and diverse features.

## ✨ Key Features

### 🔐 Authentication & Account Management
- **Sign up/Sign in** with email and password
- **Social login** with Google and Facebook
- **User profile management**
- **Email verification** and account security

### 🎶 Music Experience
- **High-quality music playback** with just_audio
- **Background playback** support
- **Full playback controls** (play, pause, skip, repeat, shuffle)
- **Lyrics display** and detailed track information
- **Dynamic color palette** based on album artwork

### 📚 Library & Playlists
- **Create and manage** personal playlists
- **Favorite library** with saved songs
- **Follow favorite artists**
- **Detailed listening history**
- **Smart music recommendations**

### 🔍 Search & Discovery
- **Advanced search** for songs, albums, artists
- **Music discovery** by genres
- **Latest music trends**
- **Personalized recommendations**

### 🌟 Premium & Subscriptions
- **Premium packages** with advanced features
- **Integrated payments**
- **Student and family plans**
- **Ad-free music experience**

### 📱 Additional Features
- **Music upload** for artists
- **Music sharing** via deep links
- **Offline mode** (Premium)
- **Responsive UI** for multiple devices
- **Dark/Light theme support**

## 🛠️ Technologies Used

### Frontend
- **Flutter 3.6.0+** - Cross-platform UI framework
- **Dart** - Programming language
- **BLoC Pattern** - State management
- **just_audio** - Audio playback engine
- **flutter_svg** - Vector graphics support

### Backend & Services  
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Custom REST API** - Music streaming backend

### Main Dependencies
```yaml
dependencies:
  flutter_bloc: ^9.0.0          # State management
  firebase_core: ^3.12.0        # Firebase core services
  firebase_auth: ^5.5.0         # Authentication
  cloud_firestore: ^5.6.4       # Database
  just_audio: ^0.9.36           # Audio player
  just_audio_background: ^0.0.1-beta.15  # Background audio
  google_sign_in: ^6.2.2        # Google authentication
  flutter_facebook_auth: ^7.1.1 # Facebook authentication
  dio: ^5.4.0                   # HTTP client
  shared_preferences: ^2.1.1    # Local storage
  palette_generator: ^0.3.3     # Dynamic color extraction
  video_player: ^2.9.3          # Video playback
  chewie: ^1.10.0               # Video player UI
  connectivity_plus: ^6.1.3     # Network connectivity
  image_picker: ^1.0.7          # Image selection
  file_picker: ^10.0.0          # File selection
```

## 🚀 Installation & Setup

### System Requirements
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / VS Code
- Firebase project setup

### Step 1: Clone the repository
```bash
git clone https://github.com/your-username/TuneZ-Music-App-FE.git
cd TuneZ-Music-App-FE
```

### Step 2: Install dependencies
```bash
flutter pub get
```

### Step 3: Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add Android/iOS apps to your project
3. Download configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Place files in respective directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### Step 4: Environment Configuration
Create a `.env` file in the root directory:
```env
API_BASE_URL=your_api_base_url
FIREBASE_API_KEY=your_firebase_api_key
GOOGLE_CLIENT_ID=your_google_client_id
FACEBOOK_APP_ID=your_facebook_app_id
# Add other environment variables as needed
```

### Step 5: Run the application
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Run on web
flutter run -d chrome

# Run on specific device
flutter devices
flutter run -d device_id
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── common/                   # Shared widgets and utilities
│   └── widgets/             # Reusable UI components
├── core/                    # Core configuration
│   ├── configs/             # App configuration
│   │   ├── assets/          # Asset management
│   │   ├── theme/           # App theming
│   │   └── bloc/            # Global BLoC providers
│   └── lib/                 # Core libraries
├── data/                    # Data layer
│   └── services/            # API services and data sources
└── presentation/            # UI layer (Clean Architecture)
    ├── splash/              # Splash screen
    ├── intro/               # Onboarding flow
    ├── login/               # Authentication UI
    ├── register/            # User registration
    ├── main/                # Main navigation
    ├── dashboard/           # Home dashboard
    ├── search/              # Search functionality
    ├── library/             # User music library
    ├── music/               # Music player interface
    ├── premium/             # Premium subscription
    ├── upload/              # Music upload (artists)
    ├── artistDetails/       # Artist profile pages
    ├── playlistDetail/      # Playlist management
    ├── history/             # Listening history
    ├── settingAccount/      # Account settings
    └── user_music/          # User's uploaded music
```

## 🎨 Screenshots

| Home Screen | Music Player | Library |
|:---:|:---:|:---:|
| ![Home](assets/images/screenshot_home.png) | ![Player](assets/images/screenshot_player.png) | ![Library](assets/images/screenshot_library.png) |

| Search | Premium | Artist Profile |
|:---:|:---:|:---:|
| ![Search](assets/images/screenshot_search.png) | ![Premium](assets/images/screenshot_premium.png) | ![Artist](assets/images/screenshot_artist.png) |

## 🔧 Development

### Code Style & Guidelines
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` for code analysis
- Format code with `dart format`
- Implement proper error handling and logging

### Architecture
- **Clean Architecture** with separation of concerns
- **BLoC Pattern** for state management
- **Repository Pattern** for data access
- **Dependency Injection** with Provider/GetIt

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run tests with coverage
flutter test --coverage
```

### Build for Production

#### Android
```bash
# APK build
flutter build apk --release

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Fully Supported | API Level 21+ |
| iOS | ✅ Fully Supported | iOS 12.0+ |
| Web | ✅ Supported | Modern browsers |
| Windows | 🔄 In Development | Windows 10+ |
| macOS | 🔄 In Development | macOS 10.14+ |
| Linux | 🔄 In Development | Ubuntu 18.04+ |

## 🚀 Deployment

### Google Play Store
1. Build app bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Complete store listing and privacy policy

### Apple App Store
1. Build iOS app: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect

### Web Hosting
1. Build web app: `flutter build web --release`
2. Deploy to Firebase Hosting, Netlify, or similar

## 🤝 Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Development Process
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following our coding standards
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Bug Reports
Please use the [Issue Tracker](https://github.com/your-username/TuneZ-Music-App-FE/issues) to report bugs or request features.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌍 Localization

Currently supported languages:
- 🇺🇸 English
- 🇻🇳 Vietnamese

Want to add your language? Check our [Localization Guide](docs/localization.md).

## 📞 Contact & Support

- **Email**: support@tunezmusic.com
- **Website**: [https://tunezmusic.com](https://tunezmusic.com)
- **Documentation**: [https://docs.tunezmusic.com](https://docs.tunezmusic.com)
- **GitHub Issues**: [Report Issues](https://github.com/your-username/TuneZ-Music-App-FE/issues)
- **Discord Community**: [Join Our Discord](https://discord.gg/tunezmusic)

## 🙏 Acknowledgments

Special thanks to:
- [Flutter Team](https://flutter.dev) for the amazing framework
- [Firebase](https://firebase.google.com) for backend services
- [just_audio](https://pub.dev/packages/just_audio) for excellent audio playback
- [BLoC Library](https://bloclibrary.dev) for state management
- All our amazing [contributors](https://github.com/your-username/TuneZ-Music-App-FE/graphs/contributors)

## 🔮 Roadmap

### Upcoming Features
- [ ] AI-powered music recommendations
- [ ] Social features (friend activity, shared playlists)
- [ ] Live radio stations
- [ ] Podcast support
- [ ] Smart home integration (Google Home, Alexa)
- [ ] Car mode interface
- [ ] Desktop applications
- [ ] Advanced equalizer

### Version History
- **v0.1.0** - Initial release with core music streaming features
- **v0.2.0** - Added premium subscriptions and offline mode
- **v0.3.0** - Introduced artist upload functionality
- **v1.0.0** - Stable release (coming soon)

---

<div align="center">
  
  **Made with ❤️ by the TuneZ Team**
  
  ⭐ **Star this repo if you found it helpful!** ⭐
  
  [Download on App Store](https://apps.apple.com/app/tunez-music) • [Get it on Google Play](https://play.google.com/store/apps/details?id=com.tunez.music)
  
</div>
