import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form_widget.dart';

/// Écran de connexion/inscription refactorisé
/// Ref: Atelier 6 - Gestion des formulaires & Atelier 10 - État asynchrone
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSignUp = false;
  String _email = '';
  String _password = '';
  String? _displayName;

  void _handleFormData(String email, String password, {String? displayName}) {
    _email = email;
    _password = password;
    _displayName = displayName;
  }

  void _handleSubmit() async {
    final authNotifier = ref.read(authProvider.notifier);

    try {
      if (_isSignUp) {
        await authNotifier.signUp(
          email: _email,
          password: _password,
          displayName: _displayName ?? '',
        );
      } else {
        await authNotifier.signIn(email: _email, password: _password);
      }

      // Afficher succès et naviguer
      if (mounted) {
        showSuccessSnackbar(
          context,
          _isSignUp ? 'Compte créé avec succès!' : 'Connexion réussie!',
        );
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              // Logo
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.candlestick_chart,
                  size: 80,
                  color: AppTheme.accentColor,
                ),
              ),
              SizedBox(height: 24),

              // Titre
              Text(
                'StockSentiment',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                _isSignUp
                    ? 'Créer un nouveau compte'
                    : 'Connectez-vous à votre compte',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
              ),
              SizedBox(height: 40),

              // Formulaire
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AuthFormWidget(
                  buttonLabel: _isSignUp ? 'S\'inscrire' : 'Se connecter',
                  onSubmit: _handleSubmit,
                  onFormData: _handleFormData,
                  isLoading: isLoading,
                  isSignUp: _isSignUp,
                  onToggleMode: () {
                    setState(() => _isSignUp = !_isSignUp);
                  },
                ),
              ),

              SizedBox(height: 24),

              // Afficher les erreurs
              authState.whenData((user) {
                return SizedBox.shrink();
              }).maybeWhen(
                error: (error, st) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              error.toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                orElse: () => SizedBox.shrink(),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
