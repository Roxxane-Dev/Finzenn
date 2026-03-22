import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Escuchar cambios de sesión
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;
  User? get currentUser => _supabase.auth.currentUser;

  // 2. Sign Up con Email y Contraseña (creará el profile auto por el Trigger SQL)
  Future<AuthResponse> signUp({required String email, required String password, required String name}) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name}, // El trigger tomará esto
    );
  }

  // 3. Sign In con Email y Contraseña
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 4. Reset Password
  Future<void> sendPasswordReset(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // 5. Cerrar sesión
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 6. Google Sign In (Supabase OAuth genérico - funciona sin nativos en Web/Desktop)
  Future<void> signInWithGoogle() async {
    // Si estás en móvil se recomienda usar google_sign_in package,
    // pero este método OAuth nativo de Supabase funcionará impecable en Web/Desktop 
    // redirigiendo al navegador para autenticarte.
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  }
}
