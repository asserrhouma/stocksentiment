import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Providers de dépendances
final localStorageProvider = FutureProvider<LocalStorageService>((ref) async {
  return await LocalStorageService.getInstance();
});

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final storage = await ref.watch(localStorageProvider.future);
  return AuthServiceImpl(storage);
});

// State notifier pour gérer l'état d'authentification
class AuthStateNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeAuth();
  }

  /// Initialise l'authentification à partir du stockage local
  /// (Firebase Cloud Firestore sera intégré ultérieurement pour Android/iOS/Web)
  Future<void> _initializeAuth() async {
    try {
      final storage = await LocalStorageService.getInstance();
      final userJson = await storage.getJson('current_user');
      
      if (userJson != null) {
        // Utilisateur connecté localement
        final user = UserModel.fromJson(userJson);
        state = AsyncValue.data(user);
      } else {
        // Pas d'utilisateur connecté
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Connexion
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authService = await ref.read(authServiceProvider.future);
      final user = await authService.signIn(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Inscription
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authService = await ref.read(authServiceProvider.future);
      final user = await authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword({required String email}) async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      await authService.resetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }
}

// Provider de l'état d'authentification
final authProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthStateNotifier(ref);
});

// Selecteurs pratiques
final isUserLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});
