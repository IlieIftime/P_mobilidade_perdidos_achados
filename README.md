# SOS Perdidos e Achados

Aplicação Flutter para reportar e encontrar objetos perdidos e achados.

## 📱 Sobre o Projeto

O **SOS Perdidos e Achados** é uma aplicação móvel desenvolvida em Flutter que permite aos utilizadores reportar objetos perdidos ou achados, visualizar itens reportados por outros utilizadores, e localizar estes itens num mapa interativo.

## ✨ Funcionalidades

### Para Utilizadores Comuns:
- 🔐 Login e Registo de utilizadores
- 📝 Reportar objetos perdidos/achados com foto
- 🗺️ Visualizar localização dos objetos no mapa
- 🔍 Filtrar objetos por categoria
- 📋 Ver lista de objetos aprovados

### Para Administradores:
- ✅ Validar objetos reportados
- ❌ Remover objetos inadequados
- 📊 Painel de administração completo
- 📋 Visualizar todos os itens (aprovados e pendentes)

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── api/                               # Integrações com APIs
├── models/                            # Modelos de dados
│   ├── user_model.dart
│   └── item_model.dart
├── screens/                           # Telas da aplicação
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── homepage_screen.dart
│   ├── report_form_screen.dart
│   ├── map_screen.dart
│   └── admin/
│       └── admin_dashboard_screen.dart
├── services/                          # Lógica de negócio
│   ├── auth_service.dart
│   └── item_service.dart
├── utils/                             # Utilitários
│   ├── colors.dart
│   └── styles.dart
└── widgets/                           # Widgets reutilizáveis
    ├── custom_button.dart
    └── custom_textfield.dart
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK (3.9.2 ou superior)
- Android Studio ou VS Code
- Emulador Android/iOS ou dispositivo físico

### Passos

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd projeto_prog_mob
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure a API Key do Google Maps** (Opcional, para usar o mapa)
   - Obtenha uma API Key em: https://console.cloud.google.com/
   - Edite `android/app/src/main/AndroidManifest.xml`
   - Substitua `YOUR_API_KEY_HERE` pela sua chave

4. **Execute a aplicação**
   ```bash
   flutter run
   ```

## 🔑 Credenciais de Teste

### Administrador
- Email: `admin@sos.com`
- Senha: `admin123`

### Utilizador Comum
- Email: `user@sos.com`
- Senha: `user123`

## 📦 Dependências Principais

- `flutter` - Framework principal
- `image_picker` - Seleção de imagens da câmera/galeria
- `google_maps_flutter` - Integração com Google Maps
- `http` - Requisições HTTP (preparado para API real)

## 🎨 Design

A aplicação utiliza Material Design com um esquema de cores personalizado:
- **Primário**: Azul (#2196F3)
- **Secundário**: Azul Claro (#03A9F4)
- **Accent**: Laranja (#FF5722)
- **Sucesso**: Verde (#4CAF50)
- **Erro**: Vermelho (#F44336)

## 🔄 Fluxo de Funcionamento

1. **Login/Registo**: Utilizador faz login ou cria uma conta
2. **Homepage**: Visualiza lista de objetos aprovados
3. **Reportar**: Utilizador reporta um objeto com foto e descrição
4. **Aprovação**: Administrador valida o objeto reportado
5. **Visualização**: Objeto aparece na lista e no mapa para todos

## 🛠️ Arquitetura

A aplicação utiliza uma arquitetura simples com separação de responsabilidades:
- **Models**: Representação dos dados
- **Services**: Lógica de negócio e mock de API
- **Screens**: Interface do utilizador
- **Widgets**: Componentes reutilizáveis
- **Utils**: Funções e constantes auxiliares

## 📝 Notas de Desenvolvimento

- A aplicação atualmente usa dados simulados (mock)
- Para produção, integre com Firebase ou API REST
- A localização é simulada (use Geolocator para localização real)
- As imagens são enviadas mas não persistidas (adicione Firebase Storage)

## 🔮 Melhorias Futuras

- [ ] Integração com Firebase Authentication
- [ ] Persistência de dados com Firestore
- [ ] Upload real de imagens com Firebase Storage
- [ ] Geolocalização em tempo real
- [ ] Notificações push
- [ ] Chat entre utilizadores
- [ ] Sistema de match (objeto perdido ↔ achado)
- [ ] Histórico de objetos recuperados

## 👥 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## 📄 Licença

Este projeto é desenvolvido para fins educacionais.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
