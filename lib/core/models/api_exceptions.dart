/// Exception personnalisée pour l'API
/// Ref: Atelier 10 - Gestion des erreurs réseau
abstract class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

/// Exception pour timeout API
class ApiTimeoutException extends ApiException {
  ApiTimeoutException()
      : super('Délai d\'attente dépassé. Vérifiez votre connexion internet.');
}

/// Exception pour erreur de connexion
class ApiConnectionException extends ApiException {
  ApiConnectionException()
      : super('Erreur de connexion. Vérifiez votre connexion internet.');
}

/// Exception pour code d'erreur HTTP
class ApiServerException extends ApiException {
  final int statusCode;
  ApiServerException(this.statusCode, String message) : super(message);
}

/// Exception pour réponse invalide
class ApiInvalidResponseException extends ApiException {
  ApiInvalidResponseException()
      : super('Réponse serveur invalide. Veuillez réessayer.');
}

/// Exception pour erreur non catégorisée
class ApiUnknownException extends ApiException {
  ApiUnknownException(super.message);
}
