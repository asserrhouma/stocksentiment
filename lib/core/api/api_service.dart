import 'package:dio/dio.dart';
import '../config/constants.dart';
import '../models/api_exceptions.dart';

/// Service API utilisant Dio pour les requêtes HTTP
/// Ref: Atelier 10 - Requêtes asynchrones avec gestion d'erreurs
/// Gère les intercepteurs, timeouts et erreurs
class ApiService {
  late Dio _dio;

  ApiService() {
    _initializeDio();
  }

  /// Initialise Dio avec configuration
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.apiConnectTimeout),
        receiveTimeout: Duration(seconds: AppConstants.apiReceiveTimeout),
        sendTimeout: Duration(seconds: AppConstants.apiSendTimeout),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Intercepteur de requête
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request avec gestion d'erreurs
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiUnknownException(e.toString());
    }
  }

  /// POST request avec gestion d'erreurs
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiUnknownException(e.toString());
    }
  }

  /// PUT request avec gestion d'erreurs
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiUnknownException(e.toString());
    }
  }

  /// DELETE request avec gestion d'erreurs
  Future<void> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiUnknownException(e.toString());
    }
  }

  /// Traite la réponse API
  T _handleResponse<T>(Response response, T Function(dynamic) fromJson) {
    if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
      throw ApiServerException(
        response.statusCode ?? 0,
        response.data['message'] ?? 'Erreur serveur',
      );
    }

    try {
      return fromJson(response.data);
    } catch (e) {
      throw ApiInvalidResponseException();
    }
  }

  /// Gère les exceptions Dio
  ApiException _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiTimeoutException();

      case DioExceptionType.connectionError:
        return ApiConnectionException();

      case DioExceptionType.badResponse:
        return ApiServerException(
          exception.response?.statusCode ?? 0,
          exception.response?.data['message'] ?? 'Erreur serveur',
        );

      case DioExceptionType.cancel:
        return ApiUnknownException('Requête annulée');

      case DioExceptionType.unknown:
        return ApiConnectionException();

      default:
        return ApiUnknownException(exception.message ?? 'Erreur inconnue');
    }
  }

  /// Ferme le service Dio
  void close() {
    _dio.close();
  }
}
