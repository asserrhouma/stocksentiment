import 'package:flutter/material.dart';
import '../../../core/widgets/error_widget.dart';

/// Widget formulaire réutilisable pour l'authentification
/// Ref: Atelier 6 - Formulaires avec validation
class AuthFormWidget extends StatefulWidget {
  final String buttonLabel;
  final VoidCallback onSubmit;
  final Function(String email, String password, {String? displayName}) onFormData;
  final bool isLoading;
  final bool isSignUp;
  final VoidCallback onToggleMode;
  final String? Function(String)? validateEmail;
  final String? Function(String)? validatePassword;

  const AuthFormWidget({
    required this.buttonLabel,
    required this.onSubmit,
    required this.onFormData,
    required this.isLoading,
    required this.isSignUp,
    required this.onToggleMode,
    this.validateEmail,
    this.validatePassword,
    super.key,
  });

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onFormData(
        _emailController.text.trim(),
        _passwordController.text,
        displayName: widget.isSignUp ? _displayNameController.text.trim() : null,
      );
      widget.onSubmit();
    }
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Email requis';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email invalide';
    }
    return widget.validateEmail?.call(value);
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Mot de passe requis';
    if (value.length < 6) return 'Minimum 6 caractères';
    return widget.validatePassword?.call(value);
  }

  String? _validateDisplayName(String value) {
    if (!widget.isSignUp) return null;
    if (value.isEmpty) return 'Nom requis';
    if (value.length < 2) return 'Minimum 2 caractères';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Champ Nom (inscription seulement)
          if (widget.isSignUp) ...[
            TextFormField(
              controller: _displayNameController,
              enabled: !widget.isLoading,
              decoration: InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person),
                hintText: 'Jean Dupont',
              ),
              validator: (value) => _validateDisplayName(value ?? ''),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 16),
          ],

          // Champ Email
          TextFormField(
            controller: _emailController,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              hintText: 'votre.email@example.com',
            ),
            validator: (value) => _validateEmail(value ?? ''),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 16),

          // Champ Mot de passe
          TextFormField(
            controller: _passwordController,
            enabled: !widget.isLoading,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: (value) => _validatePassword(value ?? ''),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 24),

          // Bouton Submit
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              child: widget.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(widget.buttonLabel),
            ),
          ),
          SizedBox(height: 16),

          // Lien basculer mode
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isSignUp
                    ? 'Vous avez déjà un compte? '
                    : 'Pas de compte? ',
              ),
              TextButton(
                onPressed: widget.isLoading ? null : widget.onToggleMode,
                child: Text(
                  widget.isSignUp ? 'Se connecter' : 'S\'inscrire',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
