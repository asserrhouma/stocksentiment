import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'firebase_init.dart';  // Temporarily disabled for Windows
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/login_screen.dart';
import 'features/stocks/views/stocks_scanner_screen.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (temporarily disabled for Windows compatibility)
  // await initializeFirebaseIfSupported();
  
  // Initialize SharedPreferences
  await LocalStorageService.getInstance();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // TODO: Ajouter l'initialisation Firebase ici
    // await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockSentiment',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: _buildHome(),
      routes: {
        '/login': (c) => const LoginScreen(),
        '/scanner': (c) => const StocksScannerScreen(),
      },
    );
  }

  Widget _buildHome() {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (user) {
        // Si l'utilisateur est authentifié, afficher le scanner
        if (user != null) {
          return const StocksScannerScreen();
        }
        // Sinon, afficher l'écran de connexion
        return const LoginScreen();
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, st) {
        // En cas d'erreur, montrer l'écran de connexion
        return const LoginScreen();
      },
    );
  }
}