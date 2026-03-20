import 'package:flutter/material.dart';
import '../theme/finzenn_theme.dart';
import '../widgets/finzenn_cards.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días ☀️';
    if (hour < 18) return 'Buenas tardes 🌤️';
    return 'Buenas noches 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22).copyWith(bottom: 120, top: 8),
        children: [
          // ── HEADER ───────────────────────────────────────────────
          Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: FinzennTheme.blueGradient,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Center(child: Text('🦉', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting(), style: const TextStyle(fontSize: 13, color: FinzennTheme.textMuted, fontWeight: FontWeight.w600)),
                    const Text('Alex Rodríguez', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: FinzennTheme.textDark)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: FinzennTheme.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                ),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: FinzennTheme.textDark, size: 22),
                    Positioned(
                      top: 0, right: 0,
                      child: Container(width: 8, height: 8,
                        decoration: const BoxDecoration(color: FinzennTheme.error, shape: BoxShape.circle)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── CONSEJO DEL DÍA ──────────────────────────────────────
          WhiteCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 20,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: FinzennTheme.blueGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('"La paciencia en tus gastos de hoy es la libertad de tus sueños de mañana."',
                          style: TextStyle(fontSize: 12, color: FinzennTheme.textSecondary, fontStyle: FontStyle.italic, height: 1.4)),
                      SizedBox(height: 4),
                      Text('— Warren Buffett', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: FinzennTheme.primaryBlue)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── SALDO TOTAL + DIFERENCIAL vs. MES PASADO ─────────────
          GradientCard(
            padding: const EdgeInsets.all(26),
            child: Stack(
              children: [
                // Glow abstract
                Positioned(
                  right: -20, bottom: -20,
                  child: Container(
                    width: 130, height: 130,
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SALDO TOTAL', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    const Text('\$12,450.00',
                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.trending_up, color: Colors.white, size: 15),
                              SizedBox(width: 4),
                              Text('+2.5% vs. mes pasado', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _balanceStat(Icons.arrow_downward, 'Ingresos', '\$5,800.00'),
                        const SizedBox(width: 24),
                        _balanceStat(Icons.arrow_upward, 'Gastos', '\$3,350.00'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── MINI STATS ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PUNTAJE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1)),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('785', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: FinzennTheme.primaryBlue)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: FinzennTheme.success.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: const Text('EXCELENTE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: FinzennTheme.success)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1)),
                      const SizedBox(height: 6),
                      Row(children: const [
                        Icon(Icons.sentiment_satisfied_alt_outlined, color: FinzennTheme.success, size: 22),
                        SizedBox(width: 6),
                        Text('Tranquilo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: FinzennTheme.textDark)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── MONTHLY SPENDING PROGRESS  ────────────────────────────
          WhiteCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('GASTO MENSUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1)),
                    Text('Mar 2026', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: FinzennTheme.textMuted)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('\$3,350', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
                    const Text(' / \$5,000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FinzennTheme.textMuted)),
                    const Spacer(),
                    const Text('67%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: FinzennTheme.primaryBlue)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.67,
                    minHeight: 10,
                    backgroundColor: FinzennTheme.bgColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(FinzennTheme.primaryBlue),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Puedes gastar \$1,650 más este mes', style: TextStyle(fontSize: 12, color: FinzennTheme.textMuted, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── DISPONIBLE HOY ────────────────────────────────────────
          WhiteCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('DISPONIBLE HOY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.primaryBlue, letterSpacing: 1)),
                      SizedBox(height: 6),
                      Text('\$24.91', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: FinzennTheme.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: FinzennTheme.softPurple, width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                  ),
                  child: const Icon(Icons.coffee_outlined, color: FinzennTheme.primaryBlue, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── METAS ACTIVAS ─────────────────────────────────────────
          _sectionHeader('METAS ACTIVAS', 'Ver todas'),
          const SizedBox(height: 14),
          _goalCard('✈️', 'Viaje a Japón', 0.65, '\$1,950', '\$3,000', FinzennTheme.primaryBlue, const Color(0xFFEEF1FF)),
          const SizedBox(height: 10),
          _goalCard('💻', 'Nueva MacBook', 0.20, '\$480', '\$2,400', const Color(0xFFA855F7), const Color(0xFFF5F0FF)),
          const SizedBox(height: 28),

          // ── HISTORIAL ─────────────────────────────────────────────
          _sectionHeader('HISTORIAL', 'Ver todo'),
          const SizedBox(height: 14),
          _txItem(Icons.shopping_bag_outlined, 'Zara Home', 'Hace 2 horas · Decoración', '-\$45.20', false),
          const SizedBox(height: 10),
          _txItem(Icons.payments_outlined, 'Nómina Mensual', 'Ayer · Ingreso', '+\$2,800.00', true),
          const SizedBox(height: 10),
          _txItem(Icons.coffee_outlined, 'Starbucks', 'Ayer · Comida', '-\$5.50', false),
          const SizedBox(height: 10),
          _txItem(Icons.local_gas_station_outlined, 'Gasolinera Shell', 'Mar 18 · Transporte', '-\$45.00', false),
          const SizedBox(height: 28),

          // ── SUSCRIPCIONES (chip row) ──────────────────────────────
          _sectionHeader('SUSCRIPCIONES', 'Ver todas'),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _subChip(Icons.play_circle_outline, 'Netflix', '\$15.99', const Color(0xFFFF4D4D), const Color(0xFFFFEEEE)),
                _subChip(Icons.fitness_center_outlined, 'Gimnasio', '\$45.00', FinzennTheme.success, const Color(0xFFE8FFF5)),
                _subChip(Icons.cloud_outlined, 'iCloud', '\$0.99', FinzennTheme.primaryBlue, const Color(0xFFEEF1FF)),
                _subChip(Icons.headphones_outlined, 'Spotify', '\$12.99', const Color(0xFF1DB954), const Color(0xFFE8FFF5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceStat(IconData icon, String label, String amount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          Text(amount, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
        ]),
      ],
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: FinzennTheme.textDark, letterSpacing: 1)),
        Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FinzennTheme.primaryBlue)),
      ],
    );
  }

  Widget _goalCard(String emoji, String name, double progress, String current, String total, Color accent, Color bg) {
    return WhiteCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: FinzennTheme.textDark)),
                    Text('${(progress * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: accent)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: bg,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
                const SizedBox(height: 6),
                Text('$current de $total', style: const TextStyle(fontSize: 11, color: FinzennTheme.textMuted, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _txItem(IconData icon, String title, String subtitle, String amount, bool isPositive) {
    return WhiteCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPositive ? FinzennTheme.success.withOpacity(0.12) : FinzennTheme.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isPositive ? FinzennTheme.success : FinzennTheme.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: FinzennTheme.textDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: FinzennTheme.textMuted, letterSpacing: 0.3)),
            ]),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15,
              color: isPositive ? FinzennTheme.success : FinzennTheme.textDark)),
        ],
      ),
    );
  }

  Widget _subChip(IconData icon, String name, String price, Color iconColor, Color bg) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FinzennTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: FinzennTheme.textDark)),
          const SizedBox(height: 2),
          Text(price + '/mes', style: const TextStyle(fontSize: 10, color: FinzennTheme.textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}