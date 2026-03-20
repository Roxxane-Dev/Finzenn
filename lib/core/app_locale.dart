import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple in-memory localization. Expand strings here for each language.
const Map<String, Map<String, String>> _strings = {
  'es': {
    'home': 'Inicio',
    'analytics': 'Analítica',
    'activity': 'Actividad',
    'learn': 'Aprender',
    'greeting_morning': 'Buenos días ☀️',
    'greeting_afternoon': 'Buenas tardes 🌤️',
    'greeting_night': 'Buenas noches 🌙',
    'total_balance': 'SALDO TOTAL',
    'monthly_spending': 'GASTO MENSUAL',
    'available_today': 'DISPONIBLE HOY',
    'active_goals': 'METAS ACTIVAS',
    'history': 'HISTORIAL',
    'subscriptions': 'SUSCRIPCIONES',
    'quote_select_lang': 'Selecciona tu idioma preferido',
  },
  'en': {
    'home': 'Home',
    'analytics': 'Analytics',
    'activity': 'Activity',
    'learn': 'Learn',
    'greeting_morning': 'Good morning ☀️',
    'greeting_afternoon': 'Good afternoon 🌤️',
    'greeting_night': 'Good evening 🌙',
    'total_balance': 'TOTAL BALANCE',
    'monthly_spending': 'MONTHLY SPENDING',
    'available_today': 'AVAILABLE TODAY',
    'active_goals': 'ACTIVE GOALS',
    'history': 'HISTORY',
    'subscriptions': 'SUBSCRIPTIONS',
    'quote_select_lang': 'Select your preferred language',
  },
};

class AppLocale extends ChangeNotifier {
  String _locale;
  AppLocale(this._locale);

  String get locale => _locale;

  String t(String key) => _strings[_locale]?[key] ?? _strings['es']![key] ?? key;

  Future<void> setLocale(String locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }

  static Future<AppLocale> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('locale') ?? 'es';
    return AppLocale(saved);
  }
}
