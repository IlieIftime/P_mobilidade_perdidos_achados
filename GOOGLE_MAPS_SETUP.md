# Configuração do Google Maps

Este guia mostra como configurar a API do Google Maps na aplicação.

## 1. Obter API Key do Google Maps

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Ative a API do Google Maps:
   - Maps SDK for Android
   - Maps SDK for iOS
4. Vá em "Credenciais" e crie uma API Key
5. (Opcional) Restrinja a API Key para maior segurança

## 2. Configurar Android

### Editar AndroidManifest.xml

O arquivo já está configurado em `android/app/src/main/AndroidManifest.xml`.
Apenas substitua `YOUR_API_KEY_HERE` pela sua chave:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_AQUI"/>
```

## 3. Configurar iOS

### Editar AppDelegate.swift

1. Abra `ios/Runner/AppDelegate.swift`
2. Adicione no topo do arquivo:

```swift
import GoogleMaps
```

3. No método `application`, adicione antes do `return`:

```swift
GMSServices.provideAPIKey("SUA_CHAVE_AQUI")
```

O arquivo completo ficará assim:

```swift
import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("SUA_CHAVE_AQUI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Editar Info.plist

Adicione as permissões de localização em `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Este app precisa da sua localização para mostrar objetos perdidos próximos.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Este app precisa da sua localização para mostrar objetos perdidos próximos.</string>
```

## 4. Testar

Execute a aplicação e navegue até a tela de mapa:

```bash
flutter run
```

## 5. Solução de Problemas

### Mapa não carrega (Android)
- Verifique se a API Key está correta
- Certifique-se de que a "Maps SDK for Android" está ativada
- Verifique o logcat para erros de autenticação

### Mapa não carrega (iOS)
- Verifique se a API Key está no AppDelegate.swift
- Certifique-se de que a "Maps SDK for iOS" está ativada
- Execute `cd ios && pod install`

### Erro de permissões
- Certifique-se de que todas as permissões estão no AndroidManifest.xml (Android)
- Certifique-se de que as permissões estão no Info.plist (iOS)

## 6. Modo de Desenvolvimento

Se não quiser configurar o Google Maps agora, a aplicação ainda funcionará.
A tela de mapa pode apresentar erro, mas todas as outras funcionalidades estarão operacionais:

- Login/Registo ✅
- Homepage com lista de itens ✅
- Reportar objetos ✅
- Painel de administração ✅

## 7. Alternativas

Se não quiser usar Google Maps, você pode:

1. Usar OpenStreetMap com o plugin `flutter_map`
2. Remover a funcionalidade de mapa temporariamente
3. Usar apenas coordenadas de texto (latitude/longitude)

## 8. Custos

O Google Maps oferece $200 de crédito mensal gratuito, o que equivale a:
- ~28.000 carregamentos de mapa dinâmico
- Suficiente para desenvolvimento e pequenas aplicações

Para mais informações: https://cloud.google.com/maps-platform/pricing

