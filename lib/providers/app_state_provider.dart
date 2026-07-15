import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global application state provider
/// Manages shared app-wide state like theme, language, etc.
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setDarkMode(bool isDark) {
    state = state.copyWith(isDarkMode: isDark);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void setAppInitialized(bool initialized) {
    state = state.copyWith(isInitialized: initialized);
  }
}

class AppState {
  final bool isDarkMode;
  final String language;
  final bool isInitialized;

  const AppState({
    this.isDarkMode = false,
    this.language = 'fr',
    this.isInitialized = false,
  });

  AppState copyWith({
    bool? isDarkMode,
    String? language,
    bool? isInitialized,
  }) {
    return AppState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);
