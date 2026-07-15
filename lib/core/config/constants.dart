/// Constantes globales de l'application
/// Ref: Architecture - Configuration centralisée
library;

class AppConstants {
  // URLs API
  static const String baseUrl = 'https://api.example.com/v1';
  static const String newsApiUrl = 'https://newsapi.org/v2';
  static const String finnhubUrl = 'https://finnhub.io/api/v1';

  // Clés API (à externaliser dans .env en production)
  static const String newsApiKey = 'YOUR_NEWS_API_KEY';
  static const String finnhubApiKey = 'YOUR_FINNHUB_API_KEY';

  // Timeouts (en secondes)
  static const int apiConnectTimeout = 10;
  static const int apiReceiveTimeout = 30;
  static const int apiSendTimeout = 30;

  // Hive Box names
  static const String hiveUserBox = 'user_box';
  static const String hiveArticlesBox = 'articles_box';
  static const String hiveFavoritesBox = 'favorites_box';

  // SharedPreferences keys
  static const String spAuthTokenKey = 'auth_token';
  static const String spUserIdKey = 'user_id';
  static const String spIsDarkModeKey = 'is_dark_mode';
  static const String spLastSyncKey = 'last_sync';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxRetries = 3;

  // UI
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
