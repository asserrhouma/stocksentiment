import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/constants.dart';

/// Service de stockage local utilisant SharedPreferences
/// Ref: Atelier 8 - Persistance de données
class LocalStorageService {
  late SharedPreferences _prefs;
  static LocalStorageService? _instance;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      final instance = LocalStorageService._();
      await instance._init();
      _instance = instance;
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Sauvegarde une chaîne
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Récupère une chaîne
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Sauvegarde un entier
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Récupère un entier
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Sauvegarde un booléen
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Récupère un booléen
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Sauvegarde un objet JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  /// Récupère un objet JSON
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Erreur decode JSON: $e');
      return null;
    }
  }

  /// Sauvegarde une liste JSON
  Future<bool> setJsonList(String key, List<dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  /// Récupère une liste JSON
  List<dynamic>? getJsonList(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      print('Erreur decode JSON List: $e');
      return null;
    }
  }

  /// Supprime une clé
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Supprime toutes les données
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Récupère le token d'authentification
  String? getAuthToken() {
    return getString(AppConstants.spAuthTokenKey);
  }

  /// Sauvegarde le token d'authentification
  Future<bool> setAuthToken(String token) async {
    return await setString(AppConstants.spAuthTokenKey, token);
  }

  /// Supprime le token d'authentification
  Future<bool> removeAuthToken() async {
    return await remove(AppConstants.spAuthTokenKey);
  }

  /// Récupère l'ID utilisateur
  String? getUserId() {
    return getString(AppConstants.spUserIdKey);
  }

  /// Sauvegarde l'ID utilisateur
  Future<bool> setUserId(String userId) async {
    return await setString(AppConstants.spUserIdKey, userId);
  }

  /// Vérifie si l'utilisateur est authentifié
  bool isUserAuthenticated() {
    return getAuthToken() != null && getAuthToken()!.isNotEmpty;
  }

  /// Récupère le mode sombre
  bool isDarkMode() {
    return getBool(AppConstants.spIsDarkModeKey) ?? false;
  }

  /// Sauvegarde le mode sombre
  Future<bool> setDarkMode(bool isDarkMode) async {
    return await setBool(AppConstants.spIsDarkModeKey, isDarkMode);
  }
}
