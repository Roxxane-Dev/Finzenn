import 'package:flutter/material.dart';
import '../../theme/finzenn_theme.dart';
import '../../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main_navigation.dart';

class SmartSetupScreen extends StatefulWidget {
  const SmartSetupScreen({super.key});

  @override
  State<SmartSetupScreen> createState() => _SmartSetupScreenState();
}

class _SmartSetupScreenState extends State<SmartSetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  // Variables para guardar las elecciones temporalmente
  String _selectedGoal = '';
  String _trackingPreference = '';
  double _incomeSlider = 2500;
  final List<String> _selectedExpenses = [];

  final List<String> _goals = [
    'Ahorrar para una meta',
    'Controlar mis gastos diarios',
    'Salir de mis deudas',
    'Empezar a invertir'
  ];

  final List<String> _trackingMethods = [
    'Hablar por Voz (AI)',
    'Escanear Ticket (OCR)',
    'Manual Tradicional'
  ];

  final List<String> _expensesOptions = [
    'Comida/Restaurantes', 'Alquiler/Hipoteca', 'Suscripciones',
    'Entretenimiento', 'Transporte', 'Educación', 'Mascotas'
  ];

  void _nextPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage < 3) { // Son 4 páginas de preguntas (índices 0, 1, 2, 3)
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutBack);
      setState(() => _currentPage++);
    } else {
      _finalizeSetup();
    }
  }

  Future<void> _finalizeSetup() async {
    setState(() => _isSaving = true);

    try {
      final user = AuthService().currentUser;
      if (user != null) {
        // Enviar a Supabase PostgreSQL una única vez todas las respuestas juntas
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id,
          'onboarding_completed': true,
          'financial_goal': _selectedGoal,
          'tracking_preference': _trackingPreference,
          'income_range': _incomeSlider.toInt().toString(),
          'primary_expenses': _selectedExpenses,
        });
      }

      // Loader simulador de "Calibrando Inteligencia Artificial" para generar inmersión emocional
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainNavigation()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error guardando perfil: $e')));
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaving) {
      return Scaffold(
        backgroundColor: FinzennTheme.bgColor,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: FinzennTheme.primaryBlue),
              SizedBox(height: 24),
              Text("Calibrando a tu copiloto financiero...", style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            style: FinzennTheme.lightTheme.elevatedButtonTheme.style,
            onPressed: _nextPage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_currentPage == 3 ? 'Comenzar mi viaje' : 'Siguiente'),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso elegante
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / 4,
                  minHeight: 4,
                  backgroundColor: FinzennTheme.softPurple.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(FinzennTheme.primaryBlue),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGoalSelection(),
                  _buildTrackingPreference(),
                  _buildIncomeRange(),
                  _buildPrimaryExpenses(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 14, color: FinzennTheme.textSecondary, height: 1.4)),
        const SizedBox(height: 32),
      ],
    );
  }

  // 1. Objetivo Financiero
  Widget _buildGoalSelection() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildStepHeader('¿Cuál es tu meta financiera principal este año?', 'Finnny adaptará sus recomendaciones basándose en esto.'),
        ..._goals.map((g) => GestureDetector(
          onTap: () => setState(() => _selectedGoal = g),
          child: _animatedSelectionCard(g, _selectedGoal == g),
        )),
      ],
    );
  }

  // 2. Método preferido
  Widget _buildTrackingPreference() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildStepHeader('¿Cómo prefieres registrar gastos?', 'Finzenn funciona con Inteligencia Artificial. Usa lo que te sea más rápido.'),
        ..._trackingMethods.map((m) => GestureDetector(
          onTap: () => setState(() => _trackingPreference = m),
          child: _animatedSelectionCard(m, _trackingPreference == m),
        )),
      ],
    );
  }

  // 3. Rango de Ingresos (Slider)
  Widget _buildIncomeRange() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildStepHeader('Definamos tu rango de ingresos', 'Nos ayuda a crear reglas claras de Safe-to-Spend mensual. (Privado y encriptado).'),
        const SizedBox(height: 40),
        Center(
          child: Text('\$${_incomeSlider.toInt()}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: FinzennTheme.primaryBlue)),
        ),
        const Center(child: Text('Dólares / Mensual', style: TextStyle(color: FinzennTheme.textMuted))),
        const SizedBox(height: 40),
        Slider(
          value: _incomeSlider,
          min: 0, max: 15000, divisions: 150,
          activeColor: FinzennTheme.primaryBlue,
          inactiveColor: FinzennTheme.softPurple.withOpacity(0.5),
          onChanged: (val) => setState(() => _incomeSlider = val),
        ),
      ],
    );
  }

  // 4. Multi-selección con Chips
  Widget _buildPrimaryExpenses() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _buildStepHeader('¿Cuáles son tus 3 mayores focos de gasto?', 'Selecciona opciones para personalizar nuestras alertas predictivas.'),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: _expensesOptions.map((expense) {
            final isSelected = _selectedExpenses.contains(expense);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedExpenses.remove(expense);
                } else if (_selectedExpenses.length < 3) {
                  _selectedExpenses.add(expense);
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? FinzennTheme.primaryBlue : FinzennTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? FinzennTheme.primaryBlue : Colors.white),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                child: Text(expense, style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : FinzennTheme.textDark,
                )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _animatedSelectionCard(String label, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? FinzennTheme.primaryBlue : FinzennTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected ? [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: isSelected ? Colors.white : FinzennTheme.textDark)),
          if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
        ],
      ),
    );
  }
}
