# Messenger Frontend

Flutter mobile application for the Messenger with a beautiful dark theme.

## Features

- 🎨 Dark theme with custom color palette
- 📱 Responsive UI design
- 🔐 User authentication (Registration & Login)
- 💬 Real-time text messaging
- 📸 Image sharing
- 🎥 Video sharing
- 👤 User profiles
- 📱 Works on iOS and Android

## Color Palette

- **Primary**: #df9f1f (Gold)
- **Secondary**: #eecd8a (Light Gold)
- **Background**: #1c1404 (Dark Brown)
- **Surface**: #503c32 (Brown)
- **Border**: #848483 (Gray)
- **Accent**: #adacab (Light Gray)

## Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Android SDK (for Android build)
- Xcode (for iOS build on macOS)

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Artem2335/mail.git
cd mail/frontend
```

### 2. Get dependencies

```bash
flutter pub get
```

### 3. Run on emulator/device

```bash
# List available devices
flutter devices

# Run the app
flutter run
```

## Building for Android (APK)

### Build Debug APK

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Build Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (Google Play)

```bash
flutter build appbundle --release
```

## Building for iOS

```bash
flutter build ios --release
```

Then open the generated Xcode project and build from there.

## Project Structure

```
frontend/
├── lib/
│   ├── main.dart                 # App entry point and theme
│   ├── models/
│   │   ├── user.dart            # User model
│   │   └── message.dart         # Message model
│   ├── services/
│   │   └── api_service.dart     # API communication
│   └── screens/
│       ├── login_screen.dart    # Registration & Login
│       ├── chat_list_screen.dart # Chat list
│       └── chat_screen.dart     # Individual chat
├── pubspec.yaml                  # Dependencies
└── README.md
```

## Configuration

### Update Backend URL

In `lib/services/api_service.dart`, update the base URL:

```dart
static const String baseUrl = 'http://localhost:8080/api';
```

For production:
```dart
static const String baseUrl = 'https://your-production-api.com/api';
```

## Dependencies

- **http** - HTTP client
- **web_socket_channel** - WebSocket support
- **shared_preferences** - Local storage
- **image_picker** - Image/video selection
- **video_player** - Video playback
- **cached_network_image** - Image caching

## Running on Different Platforms

### Android Emulator

```bash
flutter emulators --launch Pixel_4
flutter run
```

### iOS Simulator

```bash
open -a Simulator
flutter run
```

### Physical Device

1. Enable developer mode on your device
2. Connect via USB
3. Run: `flutter run`

## Troubleshooting

### Flutter not found

```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Dependencies not resolving

```bash
flutter clean
flutter pub get
```

### Hot reload not working

Kill the app and run:
```bash
flutter run
```

### API Connection Issues

- Ensure backend is running on port 8080
- Check firewall settings
- Use your machine's IP instead of localhost for physical devices

## Features Walkthrough

### Login/Registration

1. Open the app
2. Click "Sign Up" to create a new account
3. Fill in username, email, and password
4. Click "Register"
5. Or use existing credentials to login

### Sending Messages

1. Select a contact from the chat list
2. Type your message in the input field
3. Click the send button

### Sharing Media

1. In chat, click the attachment icon
2. Select "Send Image" or "Send Video"
3. Choose a file from your gallery
4. Wait for upload to complete

## Performance Optimization

- Images are cached for faster loading
- Messages are loaded lazily
- File uploads show progress
- Minimal rebuild with proper state management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT
