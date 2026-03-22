import 'package:flutter/material.dart';
import '../../theme/finzenn_theme.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Tu copiloto financiero inteligente.",
      "subtitle": "Experimenta una forma conversacional, clara y completamente segura de gestionar, entender y hacer crecer tu dinero todos los días.",
      "emoji": "🦉"
    },
    {
      "title": "Háblale a tu dinero.",
      "subtitle": "Registra gastos solo usando tu voz o tomando fotos a tus recibos físicos. Olvídate de los formularios aburridos.",
      "emoji": "🎙️"
    },
    {
      "title": "Predicciones que dan paz mental.",
      "subtitle": "Recibe alertas preventivas, aprende de tus propios patrones y sabe exactamente cuánto dinero puedes disfrutar hoy sin culpa.",
      "emoji": "🚀"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int index) => setState(() => _currentPage = index),
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return _buildPage(
                  _onboardingData[index]['emoji']!,
                  _onboardingData[index]['title']!,
                  _onboardingData[index]['subtitle']!,
                );
              },
            ),
            
            // Botón Saltar
            Positioned(
              top: 16,
              right: 24,
              child: GestureDetector(
                onTap: _finishOnboarding,
                child: const Text('Saltar', style: TextStyle(color: FinzennTheme.textMuted, fontWeight: FontWeight.w600)),
              ),
            ),
            
            // Footer Control
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index: index),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: FinzennTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Text(_currentPage == _onboardingData.length - 1 ? 'Empezar' : 'Siguiente',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              gradient: FinzennTheme.blueGradient,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.4), blurRadius: 20)],
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 60))),
          ),
          const SizedBox(height: 48),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: FinzennTheme.textDark, height: 1.2)),
          const SizedBox(height: 16),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: FinzennTheme.textSecondary, height: 1.5)),
          const SizedBox(height: 80), // Espacio inferior para los controles
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 6),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? FinzennTheme.primaryBlue : FinzennTheme.softPurple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _finishOnboarding() {
    // Al finalizar el onboarding o pulsar 'Saltar', caemos a la pantalla de Auth
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }
}
