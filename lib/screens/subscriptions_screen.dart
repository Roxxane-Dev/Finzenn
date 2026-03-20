import 'package:flutter/material.dart';
import '../theme/finzenn_theme.dart';
import '../widgets/finzenn_cards.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  final List<Map<String, dynamic>> subs = const [
    {'name': 'Netflix Premium', 'price': 19.99, 'cycle': 'Mensual', 'nextDate': '21 Mar', 'icon': Icons.movie_creation_outlined, 'color': Color(0xFFFF3B30), 'increase': false},
    {'name': 'Spotify Duo', 'price': 12.99, 'cycle': 'Mensual', 'nextDate': '25 Mar', 'icon': Icons.headphones_outlined, 'color': Color(0xFF1DB954), 'increase': false},
    {'name': 'Gimnasio Base', 'price': 45.00, 'cycle': 'Mensual', 'nextDate': '01 Abr', 'icon': Icons.fitness_center_outlined, 'color': Color(0xFF6B48FF), 'increase': true},
    {'name': 'Adobe Creative', 'price': 54.99, 'cycle': 'Mensual', 'nextDate': '05 Abr', 'icon': Icons.brush_outlined, 'color': Color(0xFFFF6B00), 'increase': false},
  ];

  @override
  Widget build(BuildContext context) {
    final double totalMonthly = subs.fold(0, (sum, s) => sum + (s['price'] as double));
    final double totalAnnual = totalMonthly * 12;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 120, top: 16),
        children: [
          const Text('Suscripciones', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: FinzennTheme.textDark)),
          const SizedBox(height: 4),
          const Text('Tus gastos recurrentes activos', style: TextStyle(color: FinzennTheme.textMuted, fontSize: 14)),
          const SizedBox(height: 24),

          // Summary Card
          PurpleCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Mensual', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('\$${totalMonthly.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Anual', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('\$${totalAnnual.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          const Text('Activas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FinzennTheme.textDark)),
          const SizedBox(height: 16),

          ...subs.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WhiteCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (s['color'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: FinzennTheme.textDark)),
                            if (s['increase'] == true) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFECEC),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('↑ Aumentó', style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Próximo cobro: ${s['nextDate']} · ${s['cycle']}', style: const TextStyle(fontSize: 12, color: FinzennTheme.textMuted)),
                      ],
                    ),
                  ),
                  Text('\$${(s['price'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: FinzennTheme.primaryBlue)),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
