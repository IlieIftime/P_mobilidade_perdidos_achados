import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  // Mock de usuários (em produção, isso seria Firebase Auth)
  final List<Map<String, String>> _users = [
    {'email': 'admin@sos.com', 'password': 'admin123', 'role': 'admin'},
    {'email': 'user@sos.com', 'password': 'user123', 'role': 'user'},
  ];

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<UserModel?> login(String email, String password) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );

      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: user['email']!,
        role: user['role']!,
      );

      return _currentUser;
    } catch (e) {
      throw Exception('Email ou senha incorretos');
    }
  }

  Future<UserModel?> register(String email, String password) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Verificar se o email já existe
    if (_users.any((u) => u['email'] == email)) {
      throw Exception('Email já cadastrado');
    }

    // Adicionar novo usuário
    _users.add({
      'email': email,
      'password': password,
      'role': 'user',
    });

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      role: 'user',
    );

    return _currentUser;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}

