/// Classe générique pour encapsuler les réponses API
/// Ref: Atelier 10 - Gestion des réponses asynchrones
sealed class ApiResponse<T> {
  const ApiResponse();
}

/// Réponse réussie
class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

/// Réponse en erreur
class ApiError<T> extends ApiResponse<T> {
  final String message;
  final Exception? exception;
  const ApiError(this.message, {this.exception});
}

/// État de chargement
class ApiLoading<T> extends ApiResponse<T> {
  const ApiLoading();
}
