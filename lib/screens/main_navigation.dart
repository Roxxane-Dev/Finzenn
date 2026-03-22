import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/finzenn_theme.dart';
import 'dashboard_screen.dart';
import 'ai_assistant_screen.dart';
import 'subscriptions_screen.dart';
import 'academy_screen.dart';
import '../widgets/add_transaction_modal.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _current = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AiAssistantScreen(),     // Analytics
    const SubscriptionsScreen(),   // Activity
    const AcademyScreen(),         // Learn
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: FinzennTheme.bgColor,
        body: _screens[_current],
        floatingActionButton: _current == 0
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddTransactionModal(),
                  );
                },
                backgroundColor: FinzennTheme.primaryBlue,
                elevation: 10,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FinzennTheme.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: FinzennTheme.primaryBlue.withOpacity(0.10),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Inicio'),
                  _navItem(1, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analítica'),
                  // FAB spacer
                  const SizedBox(width: 60),
                  _navItem(2, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Actividad'),
                  _navItem(3, Icons.menu_book_rounded, Icons.menu_book_outlined, 'Aprender'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final bool isActive = _current == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _current = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: FinzennTheme.primaryBlue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? FinzennTheme.primaryBlue : FinzennTheme.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                color: isActive ? FinzennTheme.primaryBlue : FinzennTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
