# ChatLinkr Backend

🚀 **Production-ready backend for ChatLinkr messaging platform**

## 📁 Structure

```
backend/
├── .htaccess              # Apache configuration
├── index.php              # Main entry point & routing
├── config.php             # Application configuration
├── composer.json          # PHP dependencies
├── start-production.sh    # Production startup script
├── DEPLOYMENT.md          # Detailed deployment guide
├── env.example            # Environment variables template
├── api/                   # API endpoints
│   ├── auth.php          # Authentication
│   ├── messages.php      # Messaging
│   ├── users.php         # User management
│   └── update_status.php # Status updates
├── config/               # Configuration
│   └── database.php      # Database connection
├── utils/                # Utilities
│   ├── cors.php          # CORS handling
│   └── jwt.php           # JWT tokens
├── websocket/            # WebSocket server
│   ├── server.js         # WebSocket server
│   ├── package.json      # Node.js dependencies
│   └── node_modules/     # Node.js dependencies
└── vendor/               # PHP dependencies
```

## 🚀 Quick Start

### 1. Setup Environment
```bash
cp env.example .env
# Edit .env with your database credentials
```

### 2. Install Dependencies
```bash
# PHP dependencies
composer install --no-dev --optimize-autoloader

# Node.js dependencies (for WebSocket)
cd websocket && npm install --production
```

### 3. Database Setup
```bash
# Create database and run schema
psql -d chatlinkr -f ../database/schema.sql
```

### 4. Start Services
```bash
# Run production setup
./start-production.sh

# Start WebSocket server
cd websocket && npm start
```

## 🔧 Configuration

### Environment Variables (.env)
```env
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/chatlinkr

# JWT Secret (REQUIRED - NO DEFAULT VALUES)
SESSION_SECRET=your_super_secret_key_change_in_production

# WebSocket
WEBSOCKET_PORT=3001

# CORS
CORS_ORIGIN=*

# Environment
APP_ENV=production
```

⚠️ **IMPORTANTE**: Non ci sono più chiavi hardcoded nel codice. Tutte le chiavi segrete DEVONO essere impostate nelle variabili ambiente.

### Web Server
- **Apache**: Uses included `.htaccess`
- **Nginx**: See `DEPLOYMENT.md` for configuration

## 📡 API Endpoints

### Authentication
- `POST /api/auth.php?action=register` - Register user
- `POST /api/auth.php?action=login` - Login user
- `POST /api/auth.php?action=logout` - Logout user
- `GET /api/auth.php` - Get user info

### Messages
- `GET /api/messages.php?action=conversations` - Get conversations
- `GET /api/messages.php?action=history&contact_id=X` - Get history
- `POST /api/messages.php` - Send message

### Users
- `GET /api/users.php` - List users
- `GET /api/users.php?search=query` - Search users

### Status
- `POST /api/update_status.php` - Update online status

## 🔌 WebSocket

Real-time features:
- Instant messaging
- Online status updates
- Typing indicators
- Message delivery confirmations

Start WebSocket server:
```bash
npm start
# or with PM2 for production
pm2 start websocket-server.js --name chatlinkr-websocket
```

## 🔒 Security Features

- ✅ JWT authentication
- ✅ CORS protection
- ✅ SQL injection prevention
- ✅ XSS protection
- ✅ Rate limiting
- ✅ Input validation
- ✅ Secure password hashing

## 📊 Production Deployment

See `DEPLOYMENT.md` for detailed production deployment instructions.

### Quick Production Setup:
1. Upload files to server
2. Set file permissions
3. Configure environment variables
4. Install dependencies
5. Setup database
6. Configure web server
7. Start WebSocket server

## 🐛 Troubleshooting

### Common Issues:
- **500 Error**: Check file permissions and .htaccess
- **Database Error**: Verify DATABASE_URL in .env
- **CORS Issues**: Check CORS_ORIGIN setting
- **WebSocket Issues**: Verify JWT_SECRET matches

### Debug Mode:
Set `APP_ENV=development` in .env for detailed error messages.

## 📞 Support

Check logs in `logs/app.log` for error details.
