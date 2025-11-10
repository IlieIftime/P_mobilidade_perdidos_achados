# 🛠️ Comandos Úteis - SOS Perdidos e Achados

Referência rápida de comandos úteis para desenvolvimento.

---

## 🚀 Comandos Básicos

### Executar Aplicação
```bash
# Executar em modo debug
flutter run

# Executar em modo release (mais rápido)
flutter run --release

# Executar em dispositivo específico
flutter run -d <device-id>

# Ver lista de dispositivos
flutter devices
```

### Desenvolvimento
```bash
# Hot reload (r no terminal após flutter run)
r

# Hot restart (R no terminal após flutter run)
R

# Quit (q no terminal após flutter run)
q

# Limpar build
flutter clean

# Obter dependências
flutter pub get

# Atualizar dependências
flutter pub upgrade
```

---

## 🔍 Análise e Debug

### Análise de Código
```bash
# Analisar código em busca de problemas
flutter analyze

# Verificar dependências desatualizadas
flutter pub outdated

# Verificar instalação do Flutter
flutter doctor

# Verificar instalação detalhada
flutter doctor -v
```

### Logs
```bash
# Ver logs em tempo real
flutter logs

# Ver logs do Android (se flutter run está ativo)
# Os logs já aparecem automaticamente
```

---

## 📦 Build

### Android
```bash
# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release

# Build APK split por ABI (menor tamanho)
flutter build apk --split-per-abi

# Build App Bundle (para Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build iOS (requer macOS)
flutter build ios --release

# Build sem codesign
flutter build ios --no-codesign
```

---

## 🧪 Testes

### Executar Testes
```bash
# Executar todos os testes
flutter test

# Executar teste específico
flutter test test/widget_test.dart

# Executar com cobertura
flutter test --coverage
```

---

## 🔧 Manutenção

### Limpeza
```bash
# Limpar cache e build
flutter clean

# Remover dependências baixadas
# (Windows)
rmdir /s /q .dart_tool
rmdir /s /q build

# (Linux/Mac)
rm -rf .dart_tool build

# Reinstalar tudo
flutter clean && flutter pub get
```

### Atualização
```bash
# Atualizar Flutter
flutter upgrade

# Atualizar canais (stable, beta, dev)
flutter channel stable
flutter upgrade
```

---

## 📱 Dispositivos

### Gerenciar Dispositivos
```bash
# Listar dispositivos conectados
flutter devices

# Listar emuladores disponíveis
flutter emulators

# Iniciar emulador
flutter emulators --launch <emulator-id>
```

### Android
```bash
# Instalar APK manualmente
adb install build/app/outputs/flutter-apk/app-release.apk

# Ver logs do Android
adb logcat

# Limpar dados do app
adb shell pm clear com.example.projeto_prog_mob

# Lista de dispositivos ADB
adb devices
```

---

## 🌐 Web

### Executar Web
```bash
# Executar em navegador
flutter run -d chrome

# Executar em edge
flutter run -d edge

# Build para web
flutter build web

# Servir build web localmente
cd build/web
python -m http.server 8000
# Abrir: http://localhost:8000
```

---

## 📊 Performance

### Análise de Performance
```bash
# Executar com perfil de performance
flutter run --profile

# Observatory (para análise detalhada)
flutter run --observatory-port=8888
# Abrir: http://localhost:8888
```

---

## 🔐 Configuração

### Variáveis de Ambiente
```bash
# Ver configuração do Flutter
flutter config

# Habilitar web
flutter config --enable-web

# Habilitar desktop
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Desabilitar analytics
flutter config --no-analytics
```

---

## 📝 Geração de Código

### Criar Componentes
```bash
# Criar novo projeto
flutter create meu_projeto

# Criar novo package
flutter create --template=package meu_package

# Criar novo plugin
flutter create --template=plugin meu_plugin
```

---

## 🐛 Solução de Problemas

### Problemas Comuns

#### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

#### "License not accepted"
```bash
flutter doctor --android-licenses
# Aceitar todas as licenças
```

#### App não atualiza
```bash
flutter clean
flutter pub get
flutter run
```

#### "Plugin not found"
```bash
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

---

## 📦 Dependências do Projeto

### Instalar Dependências Específicas
```bash
# Adicionar dependência
flutter pub add nome_do_pacote

# Adicionar dependência de dev
flutter pub add --dev nome_do_pacote

# Remover dependência
flutter pub remove nome_do_pacote
```

### Dependências Atuais
```bash
# Image picker
flutter pub add image_picker

# Google Maps
flutter pub add google_maps_flutter

# HTTP
flutter pub add http
```

---

## 🎨 Assets e Ícones

### Gerar Ícones
```bash
# Instalar ferramenta
flutter pub add --dev flutter_launcher_icons

# Gerar ícones (após configurar pubspec.yaml)
flutter pub run flutter_launcher_icons:main
```

### Gerar Splash Screen
```bash
# Instalar ferramenta
flutter pub add --dev flutter_native_splash

# Gerar splash (após configurar pubspec.yaml)
flutter pub run flutter_native_splash:create
```

---

## 📱 Permissões

### Android - Testar Permissões
```bash
# Conceder permissão via ADB
adb shell pm grant com.example.projeto_prog_mob android.permission.CAMERA

# Revogar permissão
adb shell pm revoke com.example.projeto_prog_mob android.permission.CAMERA

# Ver permissões do app
adb shell dumpsys package com.example.projeto_prog_mob | grep permission
```

---

## 🚢 Deploy

### Android - Play Store
```bash
# 1. Build app bundle
flutter build appbundle --release

# 2. Assinar (se não configurado)
# Seguir: https://flutter.dev/docs/deployment/android

# 3. Arquivo gerado em:
# build/app/outputs/bundle/release/app-release.aab
```

### iOS - App Store
```bash
# 1. Build iOS
flutter build ios --release

# 2. Abrir Xcode
open ios/Runner.xcworkspace

# 3. Archive no Xcode
# Product > Archive

# 4. Upload via Xcode
```

---

## 📊 Métricas

### Tamanho do App
```bash
# Analisar tamanho do APK
flutter build apk --analyze-size

# Analisar tamanho do iOS
flutter build ios --analyze-size
```

---

## 🔄 Git (Controle de Versão)

### Comandos Úteis
```bash
# Inicializar repositório
git init

# Adicionar arquivos
git add .

# Commit
git commit -m "Implementação inicial completa"

# Ver status
git status

# Ver histórico
git log --oneline

# Criar branch
git checkout -b feature/nova-funcionalidade

# Criar .gitignore típico do Flutter
# (já existe no projeto)
```

### .gitignore Recomendado
```
# Flutter/Dart
.dart_tool/
.packages
build/
.flutter-plugins
.flutter-plugins-dependencies

# IDE
.idea/
*.iml
.vscode/

# Android
android/app/google-services.json
android/key.properties

# iOS
ios/Runner/GoogleService-Info.plist
ios/Flutter/flutter_export_environment.sh
```

---

## 💡 Dicas Rápidas

### Atalhos no Terminal
- `Ctrl+C` - Parar flutter run
- `r` - Hot reload
- `R` - Hot restart
- `p` - Toggle de grade de debug
- `o` - Toggle de overlay de performance
- `q` - Quit

### VSCode
- `F5` - Start debugging
- `Shift+F5` - Stop debugging
- `Ctrl+F5` - Start without debugging
- `Ctrl+Shift+P` - Command palette

### Android Studio
- `Shift+F10` - Run
- `Ctrl+F5` - Debug
- `Alt+Shift+R` - Reload

---

## 📚 Recursos Adicionais

### Documentação
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Pub.dev](https://pub.dev/) - Pacotes Flutter

### Ferramentas Online
- [DartPad](https://dartpad.dev/) - Testar código online
- [FlutterGems](https://fluttergems.dev/) - Pacotes curados
- [Flutter Samples](https://flutter.github.io/samples/) - Exemplos

---

## 🆘 Comandos de Emergência

### App não compila?
```bash
flutter clean
flutter pub get
flutter run
```

### App crasha?
```bash
flutter logs
# Ou
adb logcat
```

### Dependências confusas?
```bash
flutter pub cache repair
flutter pub get
```

### Tudo deu errado?
```bash
flutter doctor
flutter clean
rm -rf .dart_tool
flutter pub get
flutter run
```

---

**Salve este arquivo como referência rápida! 📌**

