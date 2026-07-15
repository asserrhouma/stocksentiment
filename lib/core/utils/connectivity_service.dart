import 'package:connectivity_plus/connectivity_plus.dart';

/// Service pour vérifier la connectivité internet
/// Ref: Architecture - Utilitaires
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._();

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  /// Vérifie la connexion actuelle
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet);
    } catch (e) {
      print('Erreur vérification connectivité: $e');
      return false;
    }
  }

  /// Écoute les changements de connectivité
  Stream<bool> onConnectivityChanged() {
    return _connectivity.onConnectivityChanged
        .map((result) => result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet));
  }
}
