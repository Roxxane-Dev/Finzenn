import 'package:flutter/material.dart';
import 'core/supabase_config.dart';
import 'core/app_locale.dart';
import 'theme/finzenn_theme.dart';
import 'screens/language_select_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/auth/auth_gate.dart';

late AppLocale appLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  appLocale = await AppLocale.load();
  runApp(FinzennApp(locale: appLocale));
}

class FinzennApp extends StatefulWidget {
  final AppLocale locale;
  const FinzennApp({super.key, required this.locale});

  @override
  State<FinzennApp> createState() => _FinzennAppState();
}

class _FinzennAppState extends State<FinzennApp> {
  @override
  void initState() {
    super.initState();
    widget.locale.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // First launch: no locale saved → show language picker
    final isFirstLaunch = widget.locale.locale == 'es'; // default; change logic if needed
    return MaterialApp(
      title: 'Finzenn',
      theme: FinzennTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
