# 📱 Messenger - Full Stack Chat Application

A beautiful, feature-rich dark-themed messenger application built with **Golang backend** and **Flutter frontend**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-Active-success.svg)

## 🌟 Features

✅ **User Authentication**
- Registration with email and password
- Secure JWT token-based authentication
- Password hashing with bcrypt

✅ **Messaging**
- Real-time text messaging
- WebSocket support for instant notifications
- Message history
- Typing indicators (coming soon)

✅ **Media Sharing**
- 📸 Image upload and sharing
- 🎥 Video upload and sharing
- File streaming and caching

✅ **User Experience**
- 🎨 Custom dark theme with golden accents
- 📱 Responsive mobile UI
- ⚡ Fast and smooth animations
- 🔔 Real-time notifications

## 🎨 Design

**Color Palette:**
- **Primary Gold**: `#df9f1f`
- **Light Gold**: `#eecd8a`
- **Dark Brown**: `#1c1404`
- **Brown**: `#503c32`
- **Gray**: `#848483` / `#adacab`

## 📋 Tech Stack

### Backend
- **Language**: Go 1.21+
- **Framework**: Gin (HTTP) + Gorilla WebSocket
- **Database**: SQLite with GORM ORM
- **Authentication**: JWT (golang-jwt)
- **Security**: bcrypt for password hashing

### Frontend
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: http package
- **Storage**: SharedPreferences
- **Media**: image_picker, video_player

## 🚀 Quick Start

### Prerequisites
- Go 1.21 or higher
- Flutter SDK 3.0 or higher
- Git

### Backend Setup

```bash
cd backend
go mod download
go run main.go
```

Server will start on `http://localhost:8080`

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

## 📁 Project Structure

```
messenger/
├── backend/                 # Golang API server
│   ├── main.go             # Entry point
│   ├── middleware.go       # JWT authentication
│   ├── models/             # Data models (User, Message)
│   ├── handlers/           # API handlers (auth, chat)
│   ├── db/                 # Database setup
│   ├── go.mod              # Go dependencies
│   └── README.md           # Backend documentation
│
├── frontend/                # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart       # App entry point
│   │   ├── models/         # Data models
│   │   ├── services/       # API service
│   │   └── screens/        # UI screens
│   ├── pubspec.yaml        # Flutter dependencies
│   └── README.md           # Frontend documentation
│
└── README.md               # This file
```

## 🔌 API Endpoints

### Authentication
```
POST   /api/register       # Create account
POST   /api/login          # Login
```

### Messages (Protected)
```
GET    /api/messages/:user_id    # Get chat history
POST   /api/messages             # Send text message
POST   /api/upload               # Upload image/video
GET    /api/conversations        # Get all chats
```

### WebSocket
```
GET    /ws?user_id=<id>   # Real-time connection
```

## 📱 Building APK

### Development APK
```bash
cd frontend
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

Output: `frontend/build/app/outputs/flutter-apk/app-release.apk`

## 🔐 Security

- ✅ Password hashing with bcrypt
- ✅ JWT token-based authentication
- ✅ CORS enabled
- ✅ Input validation
- ⚠️ **Note**: Change JWT secret in production!

## 🛠️ Development

### Backend Development
```bash
cd backend
go run main.go          # Development server
go build -o messenger   # Production build
```

### Frontend Development
```bash
cd frontend
flutter run                    # Hot reload
flutter run -v                # Verbose mode
flutter analyze               # Code analysis
```

## 📚 Documentation

- [Backend README](./backend/README.md) - Detailed API documentation
- [Frontend README](./frontend/README.md) - UI and build instructions

## 🐛 Known Issues

- Real-time typing indicators not yet implemented
- User search feature coming soon
- Group chats in development

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎯 Roadmap

- [ ] User search functionality
- [ ] Group chats
- [ ] Message reactions/emojis
- [ ] Call integration
- [ ] Message encryption
- [ ] User presence status
- [ ] Message edit/delete
- [ ] Read receipts
- [ ] Push notifications
- [ ] Dark/Light theme toggle

## 📞 Support

For issues and questions:
- Create an GitHub Issue
- Check existing documentation
- Review API logs

## 👨‍💻 Author

**Artem2335**
- GitHub: [@Artem2335](https://github.com/Artem2335)
- Email: art20072975@gmail.com

---

**Made with ❤️ by Artem**
