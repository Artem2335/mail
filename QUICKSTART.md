# 🚀 Quick Start Guide

## Prerequisites

- **Go 1.21+** - [Download](https://golang.org/dl/)
- **Flutter SDK** - [Download](https://flutter.dev/docs/get-started/install)
- **Git** - [Download](https://git-scm.com/)

## 5-Minute Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/Artem2335/mail.git
cd mail
```

### Step 2: Start Backend Server

```bash
cd backend
go mod download
go run main.go
```

✅ **Server running on**: `http://localhost:8080`

You should see:
```
🚀 Server running on http://localhost:8080
```

### Step 3: Run Flutter App (in another terminal)

```bash
cd frontend
flutter pub get
flutter run
```

✅ **App is now running!**

## Test the App

### Create Account

1. Open the app
2. Click "Sign Up"
3. Fill in:
   - Username: `testuser`
   - Email: `test@example.com`
   - Password: `password123`
4. Click "Register"

### Send Message

1. You're now logged in
2. Tap on a contact (e.g., "Alex Johnson")
3. Type a message and tap send
4. Message appears in chat!

### Share Media

1. In chat, tap the attachment icon
2. Select "Send Image" or "Send Video"
3. Choose from gallery
4. Wait for upload

## Building APK

```bash
cd frontend
flutter build apk --release
```

APK file: `build/app/outputs/flutter-apk/app-release.apk`

## Troubleshooting

### Port 8080 already in use

```bash
# On macOS/Linux
lsof -i :8080

# Kill process
kill -9 <PID>
```

### Flutter not found

```bash
# Add to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Database locked

Ensure only one backend instance is running:
```bash
pkill -f "go run main.go"
```

### API connection error

1. Verify backend is running on port 8080
2. Check firewall settings
3. Update API URL in `frontend/lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP:8080/api';
   ```

## Project URLs

- **Backend**: http://localhost:8080
- **API Docs**: See [backend/README.md](./backend/README.md)
- **Frontend Docs**: See [frontend/README.md](./frontend/README.md)

## Features

✅ User Registration & Login
✅ Real-time Messaging
✅ Image Sharing
✅ Video Sharing
✅ Dark Theme
✅ WebSocket Support
✅ JWT Authentication

## Next Steps

1. 📄 Read full documentation in README.md
2. 👩‍🐫 Explore the code structure
3. 🤝 Contribute or customize
4. 🚀 Deploy to production

## Need Help?

- 📁 Check documentation files
- 🐛 Found a bug? Open an issue
- 🤔 Have questions? Check README files

---

**That's it! You're ready to go! 🚀**
