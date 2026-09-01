# 🚀 Guide d'Installation et Configuration

## Prérequis

### Système
- **OS** : macOS, Linux ou Windows (WSL2)
- **Node.js** : 16+ LTS
- **Docker** : 20+ (optionnel mais recommandé)
- **Flutter SDK** : 3.0+
- **Java SDK** : 11+ (pour Android)
- **Xcode** : 13+ (pour iOS)

### Comptes et Clés d'API
- Google Cloud Account (Speech-to-Text, Translation)
- Azure Account (optional, for redundancy)
- DeepL API Key (optional)
- PostgreSQL Database (local or remote)
- Redis Server (local or remote)

## Installation Backend

### 1. Cloner le repository

```bash
git clone https://github.com/satokaze12/real-time-conversation-translator.git
cd real-time-conversation-translator/backend
```

### 2. Installer les dépendances

```bash
npm install
# ou
yarn install
```

### 3. Configuration des variables d'environnement

```bash
cp .env.example .env
```

Éditer `.env` avec vos configurations :

```env
NODE_ENV=development
PORT=3000
DB_URL=postgresql://user:password@localhost:5432/translator_db
JWT_SECRET=your_super_secret_key
GOOGLE_TRANSLATE_API_KEY=your_key
```

### 4. Initialiser la base de données

```bash
# Créer la base de données
creatdb translator_db

# Exécuter les migrations
npm run migrate

# Remplir les données de test (optionnel)
npm run seed
```

### 5. Démarrer le serveur

```bash
# Développement avec nodemon
npm run dev

# Production
npm run build
npm start
```

Le serveur devrait être accessible sur `http://localhost:3000`

### 6. Tester l'API

```bash
# Test simple
curl http://localhost:3000/health

# Ou utiliser Postman/Insomnia avec la collection fournie
import docs/postman_collection.json
```

## Installation Mobile (Flutter)

### 1. Installer Flutter

```bash
# macOS avec Homebrew
brew install flutter

# ou télécharger depuis https://flutter.dev/docs/get-started/install
```

### 2. Configurer les appareils

```bash
# Voir les appareils disponibles
flutter devices

# Lancer un émulateur Android
flutter emulators --launch android_emulator

# Ou connecter un appareil physique via USB
```

### 3. Cloner et configurer le projet mobile

```bash
cd real-time-conversation-translator/mobile/flutter

# Obtenir les dépendances
flutter pub get

# Générer les fichiers de configuration
flutter pub run build_runner build
```

### 4. Configurer l'API Backend

Éditer `lib/services/api_service.dart` :

```dart
const String API_BASE_URL = 'http://localhost:3000/api';
const String WEBSOCKET_URL = 'ws://localhost:3000';
```

### 5. Construire et lancer l'app

```bash
# Lancer sur un appareil/émulateur
flutter run

# Ou en mode debug avec hot reload
flutter run -v

# Build APK pour Android
flutter build apk --release

# Build IPA pour iOS
flutter build ios --release
```

## Configuration avec Docker (Optionnel)

### Utiliser Docker Compose pour tout

```bash
cd real-time-conversation-translator

# Créer et démarrer les conteneurs
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les conteneurs
docker-compose down
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: translator_db
    ports:
      - '5432:5432'
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - '6379:6379'

  backend:
    build: ./backend
    ports:
      - '3000:3000'
    environment:
      NODE_ENV: development
      DB_URL: postgresql://postgres:postgres@postgres:5432/translator_db
      REDIS_URL: redis://redis:6379
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app

volumes:
  postgres_data:
```

## Tests

### Tests Backend

```bash
cd backend

# Lancer tous les tests
npm test

# Avec couverture de code
npm run test:coverage

# Tests d'intégration
npm run test:integration
```

### Tests Mobile

```bash
cd mobile/flutter

# Lancer les tests
flutter test

# Avec couverture
flutter test --coverage
```

## Troubleshooting

### Backend

**"Cannot connect to database"**
```bash
# Vérifier que PostgreSQL est lancé
sudo service postgresql status

# Vérifier la connection string
psql postgresql://user:password@localhost:5432/translator_db
```

**"Port 3000 already in use"**
```bash
# Trouver le processus
lsof -i :3000

# Tuer le processus
kill -9 <PID>

# Ou utiliser un autre port
PORT=3001 npm run dev
```

### Mobile

**"SDK is not found"**
```bash
flutter doctor --android-licenses
```

**"Cannot connect to backend"**
```dart
// Vérifier l'API_BASE_URL dans api_service.dart
// Sur émulateur Android : 10.0.2.2:3000
// Sur émulateur iOS : localhost:3000 ou 127.0.0.1:3000
```

## Prochaines Étapes

1. Consulter [ARCHITECTURE.md](./ARCHITECTURE.md) pour comprendre la structure
2. Lire [API.md](./API.md) pour les endpoints disponibles
3. Jeter un œil aux fichiers d'exemple dans `examples/`
4. Consulter les tests pour des exemples d'utilisation
