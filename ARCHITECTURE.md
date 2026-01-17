# 🏗️ System Architecture

## High-Level Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Mobile Client (Flutter)              │
│                    Dark Theme UI Layer                    │
│  [Login] → [Chat List] → [Chat Screen] → [Media Upload] │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ HTTP/WebSocket
                     │ REST API + JWT Auth
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Backend Server (Golang + Gin)              │
│                   Port: 8080                             │
├─────────────────────────────────────────────────────────┤
│                    Routes Layer                          │
│  ├─ /api/register (POST)                                 │
│  ├─ /api/login (POST)                                    │
│  ├─ /api/messages (GET/POST)                             │
│  ├─ /api/upload (POST - Multipart)                       │
│  └─ /ws (WebSocket)                                      │
├─────────────────────────────────────────────────────────┤
│                  Business Logic Layer                    │
│  ├─ Authentication Handler                               │
│  ├─ Chat Handler (Messages)                              │
│  └─ File Handler (Upload/Download)                       │
├─────────────────────────────────────────────────────────┤
│                  Data Layer (GORM ORM)                   │
│  ├─ User Repository                                      │
│  ├─ Message Repository                                   │
│  └─ Transaction Management                               │
├─────────────────────────────────────────────────────────┤
│                  Database (SQLite)                       │
│  ├─ Users Table (id, username, email, password, avatar) │
│  ├─ Messages Table (id, sender, receiver, content, file) │
│  └─ Indexes for Performance                              │
└─────────────────────────────────────────────────────────┘
                     │
                     │ File System
                     ▼
            ┌─────────────────┐
            │  Uploads Dir    │
            │  (Images/Video) │
            └─────────────────┘
```

## Component Architecture

### 1. Frontend (Flutter)

#### Layer Structure
```
Flutter App
├── UI Layer (Screens)
│   ├── LoginScreen
│   ├── ChatListScreen
│   └── ChatScreen
│
├── Business Logic Layer
│   ├── ApiService (HTTP Client)
│   └── Providers (State Management)
│
├── Data Layer
│   ├── Models (User, Message)
│   └── Local Storage (SharedPreferences)
│
└── Infrastructure
    ├── Image Picker
    ├── Video Player
    └── Network Client
```

#### Data Flow
```
User Input → UI Screen → Provider → ApiService → Backend
                                         ↓
                        Response → Provider → UI Update
```

### 2. Backend (Golang)

#### Request Handling Pipeline
```
HTTP Request
     ↓
CORS Middleware
     ↓
Auth Middleware (JWT verification)
     ↓
Router (Gin)
     ↓
Handler (Business Logic)
     ↓
Repository (Database queries)
     ↓
Database (SQLite)
```

#### Authentication Flow
```
1. Register
   ├─ Hash password with bcrypt
   ├─ Create user in database
   ├─ Generate JWT token
   └─ Return token + user data

2. Login
   ├─ Find user by email
   ├─ Compare password hash
   ├─ Generate JWT token
   └─ Return token + user data

3. Protected Routes
   ├─ Extract JWT from Authorization header
   ├─ Verify JWT signature
   ├─ Extract user_id from claims
   └─ Process request
```

#### Messaging Flow
```
Send Message
├─ Validate receiver exists
├─ Create message record
├─ Save to database
├─ Broadcast via WebSocket (if receiver online)
└─ Return message data

Receive Message
├─ Connect WebSocket with user_id
├─ Wait for incoming messages
├─ Receive JSON message
├─ Broadcast to receiver connection
└─ Maintain connection until disconnect
```

## Data Models

### User Model
```go
type User struct {
    ID        string    // UUID
    Username  string    // Unique
    Email     string    // Unique
    Password  string    // Hashed (bcrypt)
    Avatar    string    // URL
    CreatedAt time.Time
    UpdatedAt time.Time
}
```

### Message Model
```go
type Message struct {
    ID        string    // UUID
    SenderID  string    // User ID
    Receiver  string    // User ID
    Content   string    // Message text
    FileURL   string    // File path (optional)
    FileType  string    // text, image, video
    FileName  string    // Original filename
    CreatedAt time.Time
}
```

## API Endpoints

### Authentication
```
POST /api/register
  Body: {username, email, password}
  Response: {token, user}
  Status: 201 Created

POST /api/login
  Body: {email, password}
  Response: {token, user}
  Status: 200 OK
```

### Messages (Protected)
```
GET /api/messages/:user_id
  Header: Authorization: Bearer <token>
  Response: [{id, sender_id, receiver, content, file_url, created_at}]
  Status: 200 OK

POST /api/messages
  Header: Authorization: Bearer <token>
  Body: {receiver_id, content}
  Response: {id, sender_id, receiver, content, created_at}
  Status: 201 Created

POST /api/upload
  Header: Authorization: Bearer <token>
  Body: FormData {file, receiver_id}
  Response: {id, file_url, file_type, created_at}
  Status: 201 Created
```

### WebSocket
```
GET /ws?user_id=<id>
  Upgrade: websocket
  Message: {sender_id, receiver_id, content, timestamp}
  Status: 101 Switching Protocols
```

## Security Architecture

### Authentication
- **JWT Tokens**: 24-hour expiration
- **Token Storage**: Secure storage in SharedPreferences
- **Token Validation**: Verified on each protected request

### Password Security
- **Hashing**: bcrypt with default cost (10)
- **Comparison**: Constant-time comparison
- **Storage**: Never stored in plain text

### Communication
- **HTTPS**: Recommended for production
- **CORS**: Controlled access from frontend
- **Input Validation**: Sanitized inputs

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_username ON users(username);
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
    created_at TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver) REFERENCES users(id)
);

CREATE INDEX idx_conversation ON messages(sender_id, receiver);
CREATE INDEX idx_created_at ON messages(created_at);
```

## File Storage

```
uploads/
├── images/
│   ├── <uuid>.jpg
│   ├── <uuid>.png
│   └── ...
├── videos/
│   ├── <uuid>.mp4
│   ├── <uuid>.mov
│   └── ...
└── metadata.json (optional, for indexing)
```

## Performance Considerations

### Database Optimization
- Indexes on frequently queried columns
- Lazy loading of messages
- Pagination support

### Caching Strategy
- User profiles cached on client
- Message history pagination
- Image caching via cached_network_image

### Network Optimization
- Gzip compression (future)
- Image optimization before upload
- WebSocket for real-time updates

## Scalability Path

### Current (SQLite)
- Single server
- File-based database
- Good for MVP/prototype

### Phase 2 (PostgreSQL)
- Multiple backend instances
- Load balancer
- Shared database

### Phase 3 (Advanced)
- Redis for caching
- Message queue (RabbitMQ/Kafka)
- CDN for file delivery
- Microservices architecture

## Error Handling

### Backend Responses
```json
// Success
{"status": 200, "data": {...}}

// Error
{"status": 400, "error": "Invalid request"}
```

### HTTP Status Codes
- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 409: Conflict (duplicate user)
- 500: Internal Server Error

## Deployment Architecture

### Development
```
Localhost:3000 (Frontend) → Localhost:8080 (Backend) → SQLite
```

### Production
```
Google Play / AppStore → CDN → Load Balancer → 
    Backend Instance 1 ─┐
    Backend Instance 2 ─┼─→ PostgreSQL ← Backups
    Backend Instance 3 ─┘
```

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|-----------|----------|
| Frontend | Flutter | Mobile UI |
| Backend | Go + Gin | REST API |
| Database | SQLite (→ PostgreSQL) | Data persistence |
| Auth | JWT | User authentication |
| Real-time | WebSocket | Instant messaging |
| Hashing | bcrypt | Password security |
| ORM | GORM | Database abstraction |
| HTTP Client | http package | API requests |
| Storage | Local File System | Media files |

---

**Architecture designed for scalability and maintainability! 🏗️**
