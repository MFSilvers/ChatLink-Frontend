# ChatLinkr - Messaggistica Professionale

Una piattaforma di messaggistica in tempo reale moderna e professionale.

## 🚀 Avvio Rapido

### 1. Configurazione Database
Assicurati che PostgreSQL sia in esecuzione e crea il database:
```bash
createdb chatlinkr
psql chatlinkr < database/schema.sql
```

### 2. Configurazione Environment
I file `.env` sono già stati creati automaticamente. Modifica solo questi valori:

**File: `.env` (root)**
```bash
DATABASE_URL=postgresql://tuo_username:tuo_password@localhost:5432/chatlinkr
SESSION_SECRET=la_tua_chiave_segreta_sicura
```

**File: `backend/.env`**
```bash
DATABASE_URL=postgresql://tuo_username:tuo_password@localhost:5432/chatlinkr
SESSION_SECRET=la_tua_chiave_segreta_sicura
```

**File: `backend/websocket/.env`**
```bash
DATABASE_URL=postgresql://tuo_username:tuo_password@localhost:5432/chatlinkr
SESSION_SECRET=la_tua_chiave_segreta_sicura
```

### 3. Installazione Dipendenze
```bash
# Frontend
npm install

# Backend PHP
cd backend && composer install

# WebSocket
cd backend/websocket && npm install
```

### 4. Avvio Applicazione
```bash
./start.sh
```

L'applicazione sarà disponibile su:
- **Frontend**: http://localhost:5001 (o porta mostrata)
- **Backend API**: http://localhost:8000
- **WebSocket**: http://localhost:3001

## 📁 Struttura Progetto

```
ChatLinkr/
├── src/                    # Frontend Vue.js
├── backend/               # Backend PHP
│   ├── api/              # API endpoints
│   ├── websocket/        # WebSocket server
│   └── .env              # Configurazione backend
├── database/             # Schema database
├── .env                  # Configurazione principale
└── start.sh              # Script di avvio
```

## 🔧 Configurazione Produzione

Per la produzione, modifica questi URL nei file `.env`:
```bash
VITE_API_BASE_URL=https://tuodominio.com
VITE_WEBSOCKET_URL=wss://tuodominio.com:3001
```

## ⚠️ Sicurezza

- ✅ I file `.env` sono protetti da `.gitignore`
- ✅ Nessuna chiave segreta nel codice sorgente
- ✅ Cambia `SESSION_SECRET` in produzione
- ✅ Usa HTTPS in produzione

## 🛠️ Tecnologie

- **Frontend**: Vue.js 3, Vite, Tailwind CSS
- **Backend**: PHP 8.4, PostgreSQL
- **Real-time**: Socket.io, WebSocket
- **Autenticazione**: JWT
