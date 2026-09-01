# 📡 API Documentation

## Base URL

```
Production: https://api.translator-app.com/api/v1
Development: http://localhost:3000/api/v1
```

## Authentication

Tous les endpoints (sauf auth) nécessitent un JWT token dans l'header :

```bash
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### Authentication

#### Register

```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123",
  "firstName": "John",
  "lastName": "Doe",
  "preferredLanguage": "en"
}

Response 201:
{
  "id": "uuid",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "token": "jwt_token",
  "refreshToken": "refresh_token"
}
```

#### Login

```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}

Response 200:
{
  "id": "uuid",
  "email": "user@example.com",
  "token": "jwt_token",
  "refreshToken": "refresh_token"
}
```

#### Refresh Token

```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token"
}

Response 200:
{
  "token": "new_jwt_token",
  "refreshToken": "new_refresh_token"
}
```

### Conversations

#### Create Conversation

```http
POST /conversations
Authorization: Bearer <token>
Content-Type: application/json

{
  "targetUserId": "uuid",
  "myLanguage": "en",
  "theirLanguage": "fr"
}

Response 201:
{
  "id": "uuid",
  "userA": { "id": "uuid", "email": "user@example.com" },
  "userB": { "id": "uuid", "email": "other@example.com" },
  "languageA": "en",
  "languageB": "fr",
  "status": "active",
  "createdAt": "2026-09-01T00:00:00Z"
}
```

#### Get Conversations

```http
GET /conversations
Authorization: Bearer <token>

Response 200:
{
  "conversations": [
    {
      "id": "uuid",
      "participantName": "John Doe",
      "participantAvatar": "url",
      "lastMessage": "Hello!",
      "lastMessageTime": "2026-09-01T12:30:00Z",
      "unreadCount": 0,
      "status": "active"
    }
  ],
  "total": 5
}
```

#### Get Conversation Details

```http
GET /conversations/{conversationId}
Authorization: Bearer <token>

Response 200:
{
  "id": "uuid",
  "userA": { "id": "uuid", "name": "John", "avatar": "url" },
  "userB": { "id": "uuid", "name": "Jane", "avatar": "url" },
  "languageA": "en",
  "languageB": "fr",
  "status": "active",
  "createdAt": "2026-09-01T00:00:00Z",
  "messages": [
    {
      "id": "uuid",
      "sender": { "id": "uuid", "name": "John" },
      "originalText": "Hello!",
      "translatedText": "Bonjour!",
      "originalLanguage": "en",
      "translatedLanguage": "fr",
      "messageType": "text",
      "createdAt": "2026-09-01T12:30:00Z"
    }
  ]
}
```

### Messages

#### Send Message

```http
POST /conversations/{conversationId}/messages
Authorization: Bearer <token>
Content-Type: multipart/form-data

Form Data:
  conversationId: uuid
  messageType: "text" | "audio"
  originalText: "Hello!"
  originalLanguage: "en"
  audioFile: <binary> (if messageType is "audio")

Response 201:
{
  "id": "uuid",
  "conversationId": "uuid",
  "sender": { "id": "uuid", "name": "John" },
  "originalText": "Hello!",
  "translatedText": "Bonjour!",
  "originalLanguage": "en",
  "translatedLanguage": "fr",
  "messageType": "text",
  "audioUrl": "url_to_audio" (if available),
  "createdAt": "2026-09-01T12:30:00Z"
}
```

#### Get Messages

```http
GET /conversations/{conversationId}/messages?limit=50&offset=0
Authorization: Bearer <token>

Response 200:
{
  "messages": [...],
  "total": 150,
  "hasMore": true
}
```

#### Translate Message

```http
POST /messages/translate
Authorization: Bearer <token>
Content-Type: application/json

{
  "text": "Hello!",
  "sourceLanguage": "en",
  "targetLanguage": "fr"
}

Response 200:
{
  "originalText": "Hello!",
  "translatedText": "Bonjour!",
  "sourceLanguage": "en",
  "targetLanguage": "fr"
}
```

### Connection Codes

#### Generate QR Code

```http
POST /connection/generate-qr
Authorization: Bearer <token>

Response 201:
{
  "qrCode": "base64_encoded_image",
  "code": "123456",
  "expiresAt": "2026-09-01T01:00:00Z"
}
```

#### Generate Invite Code

```http
POST /connection/generate-code
Authorization: Bearer <token>

Response 201:
{
  "code": "123456",
  "expiresAt": "2026-09-01T01:00:00Z",
  "link": "https://translator-app.com/join/123456"
}
```

#### Join with Code

```http
POST /connection/join
Authorization: Bearer <token>
Content-Type: application/json

{
  "code": "123456"
}

Response 200:
{
  "conversationId": "uuid",
  "message": "Successfully joined conversation"
}
```

### Users

#### Get Profile

```http
GET /users/profile
Authorization: Bearer <token>

Response 200:
{
  "id": "uuid",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "avatar": "url",
  "preferredLanguage": "en",
  "createdAt": "2026-09-01T00:00:00Z"
}
```

#### Update Profile

```http
PUT /users/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "preferredLanguage": "en",
  "avatar": "base64_image" (optional)
}

Response 200:
{
  "id": "uuid",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "avatar": "url",
  "preferredLanguage": "en"
}
```

#### Delete Account

```http
DELETE /users/account
Authorization: Bearer <token>

Response 204: No Content
```

## WebSocket Events

### Connection

```javascript
// Client connects
socket.on('connect', () => {
  socket.emit('user:join', {
    conversationId: 'uuid',
    userId: 'uuid'
  });
});

// Server confirms
socket.on('user:joined', (data) => {
  console.log('User joined:', data);
});
```

### Messages

```javascript
// Send message
socket.emit('message:send', {
  conversationId: 'uuid',
  text: 'Hello!',
  language: 'en'
});

// Receive message
socket.on('message:received', (data) => {
  console.log('New message:', data.translatedText);
});
```

### Typing Indicators

```javascript
// Start typing
socket.emit('typing:start', { conversationId: 'uuid' });

// Stop typing
socket.emit('typing:stop', { conversationId: 'uuid' });

// Receive typing status
socket.on('typing:update', (data) => {
  console.log('User is typing:', data.isTyping);
});
```

### Status

```javascript
// User online
socket.emit('user:online', { conversationId: 'uuid' });

// Receive status
socket.on('user:status', (data) => {
  console.log('User status:', data.status); // 'online' or 'offline'
});
```

## Error Responses

### Common Error Codes

```json
{
  "400": {
    "code": "INVALID_REQUEST",
    "message": "Request validation failed"
  },
  "401": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing authentication token"
  },
  "403": {
    "code": "FORBIDDEN",
    "message": "You don't have permission to access this resource"
  },
  "404": {
    "code": "NOT_FOUND",
    "message": "Resource not found"
  },
  "429": {
    "code": "RATE_LIMITED",
    "message": "Too many requests, please try again later"
  },
  "500": {
    "code": "SERVER_ERROR",
    "message": "Internal server error"
  },
  "503": {
    "code": "SERVICE_UNAVAILABLE",
    "message": "Translation service temporarily unavailable"
  }
}
```

## Rate Limiting

- **Default**: 100 requests per 15 minutes per IP
- **Authenticated**: 1000 requests per 15 minutes per user
- **Translation API**: 50 translations per minute per user

Headers returned:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1630000000
```

## Pagination

Utiliser `limit` et `offset` pour paginer :

```http
GET /conversations?limit=20&offset=0
GET /conversations/{id}/messages?limit=50&offset=100
```

Response format:
```json
{
  "data": [...],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "hasMore": true
  }
}
```
