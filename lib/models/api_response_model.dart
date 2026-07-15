/// Generic API response wrapper for consistent handling
class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    this.statusCode,
    required this.success,
  });

  factory ApiResponse.success(T data) => ApiResponse(
    data: data,
    success: true,
  );

  factory ApiResponse.error(String error, {int? statusCode}) => ApiResponse(
    error: error,
    statusCode: statusCode,
    success: false,
  );

  factory ApiResponse.loading() => ApiResponse(success: false);

  bool get isLoading => !success && error == null;

  T? getOrNull() => data;

  T getOrThrow() {
    if (success && data != null) return data as T;
    throw Exception(error ?? 'Unknown error');
  }
}
