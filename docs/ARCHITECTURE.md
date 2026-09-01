# 🏗️ Architecture du Projet

## Vue d'ensemble

Real-Time Conversation Translator est une application mobile avec backend qui permet la communication en temps réel entre deux utilisateurs parlant des langues différentes.

## Architecture Générale

```
┌──────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                            │
│                  (Mobile App - Flutter)                      │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  • UI/UX Components                                  │   │
│  │  • Voice Input/Output Management                     │   │
│  │  • Local State Management (Provider)                 │   │
│  │  • WebSocket Connection Management                   │   │
│  │  • Local Storage (SQLite)                            │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬───────────────────────────────────────────┘
                   │
          (REST API + WebSocket)
                   │
┌──────────────────▼───────────────────────────────────────────┐
│                    API LAYER                                 │
│                  (Express.js Backend)                        │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  • Authentication & Authorization                    │   │
│  │  • REST API Endpoints                                │   │
│  │  • WebSocket Server (Socket.IO)                      │   │
│  │  • Request Validation & Middleware                   │   │
│  │  • Error Handling & Logging                          │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────┬───────────────────────────────────────────┘
                   │
        ┌──────────┴──────────┬──────────────┐
        │                     │              │
┌───────▼─────────┐ ┌────────▼──────┐ ┌────▼──────────┐
│ Service Layer   │ │ Data Layer    │ │ External APIs│
│                 │ │               │ │               │
│ • Translation   │ │ • PostgreSQL  │ │ • Google      │
│ • Speech        │ │ • MongoDB     │ │ • Azure       │
│ • Connection    │ │ • Redis Cache │ │ • DeepL       │
│ • User Mgmt     │ │               │ │               │
└─────────────────┘ └───────────────┘ └───────────────┘
```

## Composants Principaux

### 1. Application Mobile (Flutter)

#### Structure
```
mobile/flutter/lib/
├── main.dart                    # Point d'entrée
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── language_selection_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── conversation_list_screen.dart
│   ├── connection/
│   │   ├── qr_code_screen.dart
│   │   ├── code_input_screen.dart
│   │   └── link_screen.dart
│   ├── chat/
│   │   ├── chat_screen.dart
│   │   ├── message_item.dart
│   │   └── recording_widget.dart
│   └── settings/
│       ├── settings_screen.dart
│       ├── language_settings.dart
│       └── privacy_settings.dart
├── widgets/
│   ├── custom_button.dart
│   ├── audio_player_widget.dart
│   ├── message_bubble.dart
│   └── connection_indicator.dart
├── services/
│   ├── api_service.dart
│   ├── websocket_service.dart
│   ├── speech_service.dart
│   ├── translation_service.dart
│   ├── audio_service.dart
│   ├── storage_service.dart
│   └── auth_service.dart
├── models/
│   ├── user_model.dart
│   ├── conversation_model.dart
│   ├── message_model.dart
│   └── language_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── conversation_provider.dart
│   ├── message_provider.dart
│   └── connection_provider.dart
└── utils/
    ├── constants.dart
    ├── validators.dart
    └── helpers.dart
```

#### Responsabilités
- Gestion de l'interface utilisateur
- Capture et lecture audio
- Gestion de l'état local
- Communication avec le backend
- Stockage local des données
- Authentification utilisateur

### 2. Backend (Node.js/Express)

#### Structure
```
backend/src/
├── index.js                     # Point d'entrée
├── config/
│   ├── database.js
│   ├── redis.js
│   ├── env.js
│   └── constants.js
├── routes/
│   ├── auth.routes.js
│   ├── users.routes.js
│   ├── conversations.routes.js
│   ├── messages.routes.js
│   └── translations.routes.js
├── controllers/
│   ├── auth.controller.js
│   ├── users.controller.js
│   ├── conversations.controller.js
│   ├── messages.controller.js
│   └── translations.controller.js
├── services/
│   ├── translation/
│   │   ├── google.translator.js
│   │   ├── azure.translator.js
│   │   ├── deepl.translator.js
│   │   └── translator.factory.js
│   ├── speech/
│   │   ├── google.speech.js
│   │   ├── azure.speech.js
│   │   └── speech.factory.js
│   ├── websocket/
│   │   ├── socket.handler.js
│   │   ├── room.manager.js
│   │   └── message.emitter.js
│   ├── connection/
│   │   ├── connection.manager.js
│   │   ├── qr.code.generator.js
│   │   └── invite.code.generator.js
│   ├── user.service.js
│   ├── conversation.service.js
│   ├── message.service.js
│   └── cache.service.js
├── models/
│   ├── user.model.js
│   ├── conversation.model.js
│   ├── message.model.js
│   └── session.model.js
├── middleware/
│   ├── auth.middleware.js
│   ├── error.handler.js
│   ├── request.validator.js
│   ├── rate.limiter.js
│   └── cors.middleware.js
├── utils/
│   ├── logger.js
│   ├── jwt.handler.js
│   ├── encryption.js
│   └── helpers.js
└── tests/
    ├── unit/
    └── integration/
```

#### Responsabilités
- Gestion de l'authentification
- Orchestration de la traduction
- Gestion des connexions WebSocket
- Gestion des conversations et messages
- Persistance des données
- Gestion des sessions utilisateur

### 3. Bases de Données

#### PostgreSQL (Données Persistantes)
```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  first_name VARCHAR,
  last_name VARCHAR,
  preferred_language VARCHAR(5),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Conversations
CREATE TABLE conversations (
  id UUID PRIMARY KEY,
  user_a_id UUID NOT NULL,
  user_b_id UUID NOT NULL,
  language_a VARCHAR(5),
  language_b VARCHAR(5),
  status VARCHAR(20), -- active, archived, closed
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (user_a_id) REFERENCES users(id),
  FOREIGN KEY (user_b_id) REFERENCES users(id)
);

-- Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY,
  conversation_id UUID NOT NULL,
  sender_id UUID NOT NULL,
  original_text TEXT,
  translated_text TEXT,
  original_language VARCHAR(5),
  translated_language VARCHAR(5),
  message_type VARCHAR(20), -- text, audio
  audio_url VARCHAR,
  created_at TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id),
  FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- Connection Codes
CREATE TABLE connection_codes (
  id UUID PRIMARY KEY,
  code VARCHAR(6) UNIQUE,
  conversation_id UUID,
  created_by UUID,
  expires_at TIMESTAMP,
  used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);
```

#### Redis (Cache & Sessions)
- Sessions utilisateur
- Tokens refresh
- Cache de traductions fréquentes
- État des conversations en temps réel
- Rate limiting

## Flux de Données

### Flux de Traduction

```
1. Utilisateur A parle en français
   ↓
2. App A enregistre l'audio
   ↓
3. App A envoie audio au backend
   ↓
4. Backend utilise Speech-to-Text → Texte français
   ↓
5. Backend traduit → Texte japonais (via Translation Service)
   ↓
6. Backend génère synthèse vocale → Audio japonais
   ↓
7. Backend envoie via WebSocket à App B
   ↓
8. App B reçoit, affiche texte et lit audio
   ↓
9. Inverse pour la réponse de B à A
```

### Flux de Connexion

```
Utilisateur A:
1. Crée une conversation
2. Génère QR Code (Backend génère code unique)
3. Affiche QR Code

Utilisateur B:
1. Scanne QR Code
2. Envoie code au Backend
3. Backend valide et établit connexion
4. Les deux appareils reçoivent confirmation
5. Connexion WebSocket établie
```

## Pattern de Communication

### WebSocket Events

```javascript
// Client → Server
'message:send'          // Envoyer un message
'typing:start'          // Commence à taper
'typing:stop'           // Arrête de taper
'user:online'           // Utilisateur en ligne
'user:offline'          // Utilisateur hors ligne
'translation:request'   // Demande traduction

// Server → Client
'message:receive'       // Réception message
'message:translated'    // Message traduit
'user:status'          // Statut utilisateur
'connection:established' // Connexion établie
'error:translation'     // Erreur traduction
```

## Sécurité

### Authentication
- JWT (JSON Web Tokens)
- Refresh tokens
- Expiration 7 jours

### Encryption
- HTTPS/TLS pour REST API
- WSS (WebSocket Secure) pour WebSocket
- Chiffrement des données sensibles en base de données

### Validation
- Validation côté serveur de tous les inputs
- Rate limiting par IP et par utilisateur
- CORS configuration stricte

## Scalabilité

### Considérations
- **Horizontal Scaling** : Utiliser Redis pour partager l'état des sessions
- **Load Balancing** : Nginx/HAProxy pour distribuer les requêtes
- **CDN** : CloudFront pour les assets statiques
- **Database Replication** : PostgreSQL replication pour haute disponibilité
- **Caching** : Redis pour les traductions fréquentes

## Déploiement

### Infrastructure
- Docker containers pour isolation
- Kubernetes pour orchestration (optionnel)
- AWS/GCP/Azure pour hosting
- GitHub Actions pour CI/CD

### Monitoring
- Sentry pour error tracking
- Datadog pour performance monitoring
- CloudWatch pour logs
