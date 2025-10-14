#!/bin/bash

php -S 0.0.0.0:8000 -t backend backend/server.php &
PHP_PID=$!

cd backend/websocket && node server.js &
WS_PID=$!

npm run dev

kill $PHP_PID $WS_PID 2>/dev/null
