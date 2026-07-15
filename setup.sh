#!/bin/bash
# Script de démarrage du projet StockSentiment
# Utilisation: bash setup.sh

echo "🚀 Initialisation du projet StockSentiment..."

# 1. Installer les dépendances
echo "📦 Installation des dépendances..."
flutter pub get

# 2. Générer le code (Riverpod, Hive, etc.)
echo "⚙️ Génération du code..."
flutter pub run build_runner build

# 3. Nettoyer
echo "🧹 Nettoyage du build..."
flutter clean

# 4. Vérifier la structure
echo "✅ Vérification de la structure..."
if [ -f "lib/core/api/api_service.dart" ]; then
    echo "✅ Core layer: OK"
else
    echo "❌ Core layer: ERREUR"
fi

if [ -f "lib/features/auth/providers/auth_provider.dart" ]; then
    echo "✅ Auth feature: OK"
else
    echo "❌ Auth feature: ERREUR"
fi

if [ -f "lib/features/stocks/providers/stocks_provider.dart" ]; then
    echo "✅ Stocks feature: OK"
else
    echo "❌ Stocks feature: ERREUR"
fi

echo ""
echo "==================================="
echo "✅ Configuration terminée!"
echo "==================================="
echo ""
echo "🎯 Prochaines étapes:"
echo "1. Configurer Firebase (CRITIQUE)"
echo "2. Remplacer les API keys en .env"
echo "3. flutter run -d windows (ou ios/android)"
echo ""
