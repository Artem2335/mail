# Messenger Backend

Golang backend for the Messenger application using Gin framework and SQLite database.

## Features

- 🔐 JWT Authentication (Registration & Login)
- 💬 Real-time messaging with WebSocket
- 📸 Image and video upload support
- 👥 User profile management
- 🗄️ SQLite database
- ✅ Input validation

## Prerequisites

- Go 1.21 or higher
- Git

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/Artem2335/mail.git
cd mail/backend
```

### 2. Install dependencies

```bash
go mod download
```

### 3. Run the server

```bash
go run main.go
```

The server will start on `http://localhost:8080`

## API Endpoints

### Authentication (No Token Required)

- `POST /api/register` - Register a new user
  ```json
  {
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepassword123"
  }
  ```

- `POST /api/login` - Login user
  ```json
  {
    "email": "john@example.com",
    "password": "securepassword123"
  }
  ```

### Protected Routes (Token Required)

Add header: `Authorization: Bearer <token>`

- `GET /api/profile/:id` - Get user profile
- `GET /api/messages/:user_id` - Get messages with a user
- `POST /api/messages` - Send a text message
  ```json
  {
    "receiver_id": "user_id",
    "content": "Hello!"
  }
  ```

- `POST /api/upload` - Upload image/video
  - Form data with `file` and `receiver_id`

- `GET /api/conversations` - Get all conversations

### WebSocket

- `GET /ws?user_id=<user_id>` - WebSocket connection for real-time messaging

## Database Schema

### Users Table

```sql
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  avatar VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Messages Table

```sql
CREATE TABLE messages (
  id VARCHAR(36) PRIMARY KEY,
  sender_id VARCHAR(36) NOT NULL,
  receiver VARCHAR(36) NOT NULL,
  content TEXT,
  file_url VARCHAR(500),
  file_type VARCHAR(50),
  file_name VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(id),
  FOREIGN KEY (receiver) REFERENCES users(id)
);
```

## Project Structure

```
backend/
├── main.go              # Entry point
├── middleware.go        # JWT authentication middleware
├── go.mod              # Go module file
├── models/
│   ├── user.go         # User model
│   └── message.go      # Message model
├── handlers/
│   ├── auth.go         # Authentication handlers
│   └── chat.go         # Chat/messaging handlers
├── db/
│   └── database.go     # Database initialization
└── uploads/            # Uploaded files directory
```

## Security Notes

⚠️ **Important:** Change the JWT secret in `handlers/auth.go` before production:

```go
var jwtSecret = "your-secure-random-string-here"
```

## Building for Production

```bash
# Build the executable
go build -o messenger-server

# Run
./messenger-server
```

## Troubleshooting

### CORS Issues

The server includes CORS middleware. If you're still having issues, ensure the frontend is making requests to `http://localhost:8080/api`

### Database Locked

If you see SQLite database locked errors, ensure only one instance of the server is running.

### Port Already in Use

To use a different port, modify `main.go`:
```go
router.Run(":8000")  // Change port here
```

## License

MIT
