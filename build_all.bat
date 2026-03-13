@echo off
echo 🚀 Iniciando a maquina de builds do Flutter...

echo.
echo 📦 Construindo Android APK...
call flutter build apk --release

echo.
echo 📦 Construindo Android App Bundle (AAB)...
call flutter build appbundle --release

echo.
echo 🪟 Construindo Windows (EXE)...
call flutter build windows --release

echo.
echo 🌐 Construindo Web (Web App)...
call flutter build web --release

echo.
echo 🔄 Executando o script de renomeacao e organizacao...
call dart run rename_builds.dart

echo.
echo ✅ Processo finalizado com sucesso! Suas versoes estao na pasta 'releases_finais'.
pause