import 'package:flutter/material.dart';
import '../theme/finzenn_theme.dart';
import '../widgets/finzenn_cards.dart';
import '../core/app_locale.dart';
import '../main.dart';
import 'auth/onboarding_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: FinzennTheme.blueGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('🦉', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 32),
              const Text('Finzenn', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
              const SizedBox(height: 8),
              const Text('Tu copiloto financiero inteligente', style: TextStyle(fontSize: 16, color: FinzennTheme.textSecondary)),
              const SizedBox(height: 48),
              const Text('Elige tu idioma', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1)),
              const SizedBox(height: 16),
              _LangOption(flag: '🇪🇸', label: 'Español', code: 'es'),
              const SizedBox(height: 12),
              _LangOption(flag: '🇺🇸', label: 'English', code: 'en'),
              const Spacer(),
              Text('Podrás cambiarlo en cualquier momento desde Perfil.', style: TextStyle(fontSize: 12, color: FinzennTheme.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String flag, label, code;
  const _LangOption({required this.flag, required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await appLocale.setLocale(code);
        if (context.mounted) {
          // Después de elegir el idioma, pasamos por el onboarding visual 
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      },
      child: WhiteCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: FinzennTheme.textDark)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: FinzennTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
