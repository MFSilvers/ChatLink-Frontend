#!/bin/bash

echo "🚀 Building ChatLinkr Backend for Render..."

# Install PHP dependencies
cd backend
composer install --no-dev --optimize-autoloader

# Install Node.js dependencies for WebSocket
cd websocket
npm install --production

echo "✅ Build completed successfully!"
