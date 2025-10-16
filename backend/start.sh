#!/bin/bash

# Script per avviare sia il backend PHP che il WebSocket server

echo "🚀 Avvio ChatLinkr Backend + WebSocket Server..."

# Avvia il WebSocket server in background
echo "📡 Avvio WebSocket server sulla porta 3001..."
cd websocket
npm install --silent
node server.js &
WEBSOCKET_PID=$!

# Torna alla directory backend
cd ..

# Avvia il server PHP
echo "🌐 Avvio server PHP sulla porta 8000..."
php -S 0.0.0.0:8000 -t . index.php &
PHP_PID=$!

echo "✅ Servizi avviati:"
echo "   - PHP Backend: http://localhost:8000"
echo "   - WebSocket: http://localhost:3001"
echo ""
echo "Premi Ctrl+C per fermare tutti i servizi"

# Funzione per cleanup
cleanup() {
    echo ""
    echo "🛑 Fermando servizi..."
    kill $WEBSOCKET_PID 2>/dev/null
    kill $PHP_PID 2>/dev/null
    echo "✅ Servizi fermati"
    exit 0
}

# Cattura Ctrl+C
trap cleanup SIGINT SIGTERM

# Mantieni lo script attivo
wait
