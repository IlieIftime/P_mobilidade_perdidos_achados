import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  // Singleton (igual ao antigo)
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // LOGIN COM FIREBASE
  Future<UserModel?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // Buscar dados do utilizador no Firestore
      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      // Se for o email admin@sos.com, garantimos role = 'admin'
      final isAdminEmail = (cred.user!.email ?? email).toLowerCase() == 'admin@sos.com';

      if (!doc.exists) {
        _currentUser = UserModel(
          id: uid,
          email: cred.user!.email ?? email,
          role: isAdminEmail ? 'admin' : 'user',
        );

        await docRef.set(_currentUser!.toJson());
      } else {
        // Lê os dados existentes
        _currentUser = UserModel.fromJson(doc.data()!);

        // Se o email for admin mas o documento tem role != admin, atualizamos
        if (isAdminEmail && _currentUser!.role != 'admin') {
          // Criamos um novo UserModel com role = 'admin' (sem usar copyWith)
          _currentUser = UserModel(
            id: _currentUser!.id,
            email: _currentUser!.email,
            role: 'admin',
          );
          await docRef.update({'role': 'admin'});
        }
      }

      return _currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (_) {
      throw Exception('Erro ao iniciar sessão. Tenta novamente.');
    }
  }
  // REGISTO COM FIREBASE
  Future<UserModel?> register(String email, String password) async {
    // ignore: avoid_print
    print('🔥 A FUNÇÃO REGISTER FOI CHAMADA');
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // Tratar admin por email (automaticamente marca como admin)
      final isAdminEmail = email.toLowerCase() == 'admin@sos.com';

      _currentUser = UserModel(
        id: uid,
        email: cred.user!.email ?? email,
        role: isAdminEmail ? 'admin' : 'user',
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(_currentUser!.toJson());

      return _currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    } catch (_) {
      throw Exception('Erro ao registar. Tenta novamente.');
    }
  }



  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Utilizador não encontrado.';
      case 'wrong-password':
        return 'Palavra-passe incorreta.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este email.';
      case 'weak-password':
        return 'A palavra-passe é demasiado fraca.';
      case 'invalid-email':
        return 'Email inválido.';
      default:
        return e.message ?? 'Ocorreu um erro de autenticação.';
    }
  }
}

