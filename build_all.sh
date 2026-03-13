#!/bin/bash

echo "🚀 Iniciando a máquina de builds do Flutter..."

echo -e "\n📦 Construindo Android APK..."
flutter build apk --release

echo -e "\n📦 Construindo Android App Bundle (AAB)..."
flutter build appbundle --release

#echo -e "\n🌐 Construindo Web (Web App)..."
#flutter build web --release

# Verifica se está rodando no macOS para compilar iOS e Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n🍏 Construindo iOS (IPA)..."
    flutter build ipa --release
    
    echo -e "\n🍏 Construindo macOS..."
    flutter build macos --release
# Verifica se está rodando no Linux para compilar para Linux
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\n🐧 Construindo Linux..."
    flutter build linux --release
fi

echo -e "\n🔄 Executando o script de renomeação e organização..."
dart run rename_builds.dart

echo -e "\n✅ Processo finalizado com sucesso! Verifique a pasta 'releases_finais'."