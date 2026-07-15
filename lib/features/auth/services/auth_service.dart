import '../../../core/models/api_exceptions.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';

/// Service d'authentification avec support Firebase et Mock
/// Pour Windows: utilise mock auth (Firebase C++ SDK non supporté)
/// Pour Android/iOS/Web: intégration Firebase disponible ultérieurement
abstract class AuthService {
  /// Vérifie si l'utilisateur est connecté
  Future<bool> isUserLoggedIn();

  /// Récupère l'utilisateur actuel
  Future<UserModel?> getCurrentUser();

  /// Connexion par email/mot de passe
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Inscription par email/mot de passe
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  /// Déconnexion
  Future<void> signOut();

  /// Réinitialisation de mot de passe
  Future<void> resetPassword({required String email});
}

/// Implémentation du service d'authentification avec Mock (Windows compatible)
/// TODO: Intégrer Firebase Auth pour Android/iOS/Web
class AuthServiceImpl implements AuthService {
  final LocalStorageService _storageService;

  // Mock credentials for testing
  static const String _mockEmail = 'test@example.com';
  static const String _mockPassword = 'Password123!';

  AuthServiceImpl(this._storageService);

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await _storageService.getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = await _storageService.getJson('current_user');
      if (userJson == null) return null;
      return UserModel.fromJson(userJson);
    } catch (e) {
      print('Erreur récupération utilisateur: $e');
      return null;
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ApiUnknownException('Email et mot de passe requis');
      }

      // Mock validation
      if (email.trim() != _mockEmail || password != _mockPassword) {
        throw ApiUnknownException('Email ou mot de passe incorrect');
      }

      final user = UserModel(
        uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim(),
        displayName: 'Test User',
        photoUrl: null,
        phoneNumber: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Sauvegarde en local
      await _storageService.setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await _storageService.setJson('current_user', user.toJson());

      return user;
    } catch (e) {
      throw ApiUnknownException('Erreur connexion: $e');
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
        throw ApiUnknownException('Tous les champs sont requis');
      }

      if (password.length < 6) {
        throw ApiUnknownException('Le mot de passe doit contenir au moins 6 caractères');
      }

      final user = UserModel(
        uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim(),
        displayName: displayName,
        photoUrl: null,
        phoneNumber: null,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Sauvegarde en local
      await _storageService.setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await _storageService.setJson('current_user', user.toJson());

      return user;
    } catch (e) {
      throw ApiUnknownException('Erreur inscription: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _storageService.removeAuthToken();
      await _storageService.remove('current_user');
    } catch (e) {
      print('Erreur déconnexion: $e');
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        throw ApiUnknownException('Email requis');
      }
      // Mock implementation - just log
      print('Email de réinitialisation envoyé à: $email');
    } catch (e) {
      throw ApiUnknownException('Erreur réinitialisation: $e');
    }
  }
}
