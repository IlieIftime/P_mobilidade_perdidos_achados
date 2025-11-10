# 🏗️ Arquitetura do Projeto

## 📐 Visão Geral

A aplicação **SOS Perdidos e Achados** segue uma arquitetura simples e modular, ideal para projetos de médio porte, facilitando a manutenção e escalabilidade.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens & Widgets - Interface UI)     │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Business Logic Layer            │
│    (Services - Lógica de Negócio)      │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│            Data Layer                   │
│  (Models & Mock API - Dados)           │
└─────────────────────────────────────────┘
```

## 📁 Estrutura Detalhada

### 1. **Presentation Layer** (`screens/` e `widgets/`)

Responsável pela interface do usuário e interação.

#### Screens (Telas)
- `login_screen.dart` - Autenticação do usuário
- `registration_screen.dart` - Cadastro de novos usuários
- `homepage_screen.dart` - Lista de objetos aprovados
- `report_form_screen.dart` - Formulário para reportar itens
- `map_screen.dart` - Visualização de localizações no mapa
- `admin/admin_dashboard_screen.dart` - Painel administrativo

#### Widgets (Componentes Reutilizáveis)
- `custom_button.dart` - Botão customizado com loading
- `custom_textfield.dart` - Campo de texto customizado

**Responsabilidades:**
- Renderizar UI
- Capturar eventos do usuário
- Chamar serviços para lógica de negócio
- Exibir feedback ao usuário

### 2. **Business Logic Layer** (`services/`)

Contém toda a lógica de negócio da aplicação.

#### Auth Service
```dart
class AuthService {
  - login(email, password)
  - register(email, password)
  - logout()
  - get currentUser
  - get isLoggedIn
  - get isAdmin
}
```

**Responsabilidades:**
- Gerenciar estado de autenticação
- Validar credenciais
- Controlar perfis de usuário (user/admin)

#### Item Service
```dart
class ItemService {
  - getItems()
  - getApprovedItems()
  - getPendingItems()
  - reportItem(item)
  - validateItem(itemId)
  - deleteItem(itemId)
}
```

**Responsabilidades:**
- Gerenciar CRUD de itens
- Filtrar itens por status
- Simular persistência de dados

### 3. **Data Layer** (`models/`)

Define a estrutura dos dados.

#### User Model
```dart
class UserModel {
  String id
  String email
  String role  // 'user' ou 'admin'
}
```

#### Item Model
```dart
class ItemModel {
  int? id
  String description
  String category
  String status  // 'pendente' ou 'aprovado'
  String? imageUrl
  LocationModel location
}

class LocationModel {
  double latitude
  double longitude
}
```

**Responsabilidades:**
- Estruturar dados
- Serialização (toJson/fromJson)
- Validação de tipos

### 4. **Utils** (`utils/`)

Utilitários e constantes compartilhadas.

- `colors.dart` - Paleta de cores da aplicação
- `styles.dart` - Temas e estilos globais

## 🔄 Fluxo de Dados

### Exemplo: Reportar um Item

```
User Action (UI)
    ↓
1. ReportFormScreen
   - Usuário preenche formulário
   - Clica em "Reportar"
    ↓
2. Validação Local
   - Verifica campos obrigatórios
   - Valida tamanho da descrição
    ↓
3. ItemService.reportItem()
   - Cria novo ItemModel
   - Status = 'pendente'
   - Adiciona à lista interna
    ↓
4. Retorno ao UI
   - Mostra mensagem de sucesso
   - Navega de volta para homepage
    ↓
5. Homepage não mostra item
   - Apenas itens 'aprovado' são exibidos
    ↓
6. Admin valida
   - AdminDashboardScreen
   - ItemService.validateItem()
   - Status muda para 'aprovado'
    ↓
7. Item aparece na Homepage
   - Usuários comuns podem ver
```

## 🎯 Padrões Utilizados

### 1. **Singleton Pattern**
Usado nos serviços para garantir uma única instância.

```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
}
```

**Benefícios:**
- Estado compartilhado entre telas
- Evita múltiplas instâncias
- Facilita acesso global

### 2. **Factory Pattern**
Usado nos models para criação de objetos.

```dart
factory ItemModel.fromJson(Map<String, dynamic> json) {
  return ItemModel(...);
}
```

**Benefícios:**
- Encapsula lógica de criação
- Facilita parsing de JSON
- Permite validações durante criação

### 3. **Repository Pattern** (Simplificado)
Services atuam como repositories mock.

```dart
class ItemService {
  final List<ItemModel> _items = [];  // "Repositório"
  
  Future<List<ItemModel>> getItems() async {
    return List.from(_items);
  }
}
```

**Benefícios:**
- Abstrai fonte de dados
- Facilita troca para API real
- Simula comportamento assíncrono

## 🔐 Gerenciamento de Estado

### Estado Local com StatefulWidget
A aplicação usa `StatefulWidget` para gerenciamento de estado local.

```dart
class _HomepageScreenState extends State<HomepageScreen> {
  List<ItemModel> _items = [];  // Estado local
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadItems();  // Carrega dados ao iniciar
  }
}
```

**Por que não Provider/Bloc?**
- Projeto pequeno/médio
- Complexidade desnecessária inicial
- Fácil migração futura se necessário

### Estado Global (Simplificado)
Usando Singleton Services:

```dart
final authService = AuthService();  // Sempre mesma instância
final user = authService.currentUser;  // Estado global
```

## 🚀 Escalabilidade

### Fácil Migração para:

#### 1. **Firebase**
```dart
// De:
class ItemService {
  final List<ItemModel> _items = [];
}

// Para:
class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<List<ItemModel>> getItems() async {
    final snapshot = await _firestore.collection('items').get();
    return snapshot.docs.map((doc) => ItemModel.fromJson(doc.data())).toList();
  }
}
```

#### 2. **REST API**
```dart
// De:
class ItemService {
  final List<ItemModel> _items = [];
}

// Para:
class ItemService {
  final String baseUrl = 'https://api.example.com';
  
  Future<List<ItemModel>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'));
    final data = json.decode(response.body);
    return data.map((item) => ItemModel.fromJson(item)).toList();
  }
}
```

#### 3. **State Management (Provider/Bloc)**
```dart
// Adicionar:
class ItemProvider extends ChangeNotifier {
  final ItemService _itemService = ItemService();
  List<ItemModel> _items = [];
  
  List<ItemModel> get items => _items;
  
  Future<void> loadItems() async {
    _items = await _itemService.getItems();
    notifyListeners();
  }
}
```

## 📊 Diagrama de Componentes

```
┌─────────────────────────────────────────────┐
│                 main.dart                    │
│           (Entry Point + Theme)              │
└────────────────┬────────────────────────────┘
                 │
    ┌────────────▼────────────┐
    │    LoginScreen          │
    └────────────┬────────────┘
                 │
        ┌────────┴────────┐
        │                 │
┌───────▼──────┐  ┌──────▼───────────┐
│ Homepage     │  │ AdminDashboard   │
│ (User)       │  │ (Admin)          │
└───────┬──────┘  └──────┬───────────┘
        │                │
    ┌───┴─────┐      ┌───┴─────┐
    │         │      │         │
┌───▼───┐ ┌──▼───┐ ┌▼────┐ ┌──▼────┐
│Report │ │Map   │ │Val. │ │Remove │
│Form   │ │Screen│ │Item │ │Item   │
└───────┘ └──────┘ └─────┘ └───────┘
    │         │        │       │
    └────┬────┴────────┴───────┘
         │
    ┌────▼────────────┐
    │  ItemService    │
    │  AuthService    │
    └────┬────────────┘
         │
    ┌────▼────────────┐
    │  ItemModel      │
    │  UserModel      │
    └─────────────────┘
```

## 🔧 Boas Práticas Implementadas

### 1. **Separação de Responsabilidades**
- UI não conhece detalhes de implementação de dados
- Services não manipulam widgets
- Models apenas estruturam dados

### 2. **Código Reutilizável**
- Widgets customizados (CustomButton, CustomTextField)
- Estilos centralizados (AppColors, AppStyles)
- Serviços singleton

### 3. **Tratamento de Erros**
```dart
try {
  await itemService.deleteItem(id);
  // Sucesso
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erro: $e')),
  );
}
```

### 4. **Feedback ao Usuário**
- Loading states
- SnackBars para mensagens
- Dialogs para confirmações

### 5. **Validação de Formulários**
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}
```

## 📝 Conclusão

Esta arquitetura oferece:
- ✅ Simplicidade para iniciantes
- ✅ Organização clara
- ✅ Fácil manutenção
- ✅ Escalabilidade futura
- ✅ Testabilidade
- ✅ Reutilização de código

Para projetos maiores, considere:
- State management avançado (Provider, Bloc, Riverpod)
- Camada de repository separada
- Dependency Injection
- Testes unitários e de integração

