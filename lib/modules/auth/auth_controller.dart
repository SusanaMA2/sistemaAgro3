import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final supabase = Supabase.instance.client;

  // VALIDAR CONTRASEÑA
  String? validarPassword(String pass) {
    if (pass.length < 6) return "La contraseña debe tener mínimo 6 caracteres";
    if (!pass.contains(RegExp(r'[A-Z]'))) return "Debe tener al menos 1 mayúscula";
    if (!pass.contains(RegExp(r'[0-9]'))) return "Debe tener al menos 1 número";
    return null;
  }

  // LOGIN EMAIL + PASSWORD
  Future<String?> login(String email, String password) async {
    final passError = validarPassword(password);
    if (passError != null) return passError;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null; // OK
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error inesperado: $e";
    }
  }

  // REGISTRO
  Future<String?> register(String email, String password) async {
    final passError = validarPassword(password);
    if (passError != null) return passError;

    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN GOOGLE (Supabase Auth OAuth)
  Future<String?> loginGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google, // ← ESTE ES EL CORRECTO
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
