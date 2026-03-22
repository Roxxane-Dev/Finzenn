import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main_navigation.dart';
import 'auth_screen.dart';
import 'onboarding_screen.dart';
import 'smart_setup_screen.dart';
import '../../theme/finzenn_theme.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: FinzennTheme.primaryBlue)),
          );
        }

        final session = snapshot.data?.session;

        // Si NO hay sesión, mostramos el Onboarding visual primero
        if (session == null) {
          return const OnboardingScreen();
        }

        // Si hay sesión activa, validamos en Base de Datos su estatus de perfilamiento
        return FutureBuilder<Map<String, dynamic>?>(
          future: Supabase.instance.client
              .from('profiles')
              .select('onboarding_completed')
              .eq('id', session.user.id)
              .maybeSingle() as Future<Map<String, dynamic>?>,
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: FinzennTheme.bgColor,
                body: Center(child: CircularProgressIndicator(color: FinzennTheme.primaryBlue)),
              );
            }
            
            // Verificamos el campo SQL
            final isOnboarded = profileSnap.data?['onboarding_completed'] == true;

            if (isOnboarded) {
              return const MainNavigation();
            } else {
              return const SmartSetupScreen();
            }
          },
        );
      },
    );
  }
}
