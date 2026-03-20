import 'package:flutter/material.dart';
import '../theme/finzenn_theme.dart';
import '../widgets/finzenn_cards.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 120, top: 16),
        children: [
          const Text('Academia Finzenn', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: FinzennTheme.textDark)),
          const SizedBox(height: 4),
          const Text('Educación financiera gamificada', style: TextStyle(color: FinzennTheme.textMuted, fontSize: 14)),
          const SizedBox(height: 24),

          // User Progress Card
          PurpleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.4,
                            backgroundColor: Colors.white30,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                        ),
                        const Text('40%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tu Progreso Global', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          const Text('⭐ Nivel 4 · Ahorrista', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          const Text('80 XP para el siguiente nivel', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('En Progreso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FinzennTheme.textDark)),
          const SizedBox(height: 14),
          _buildLessonCard(
            emoji: '🛡️',
            title: 'Fondo de Emergencia 101',
            description: 'Aprende a construir tu red de seguridad financiera en 3 pasos.',
            progress: 0.4,
            xp: '40 XP',
            color: const Color(0xFFE8F8F6),
            accentColor: const Color(0xFF11D4C4),
          ),
          const SizedBox(height: 28),

          const Text('Próximos Módulos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FinzennTheme.textDark)),
          const SizedBox(height: 14),
          _buildLessonCard(
            emoji: '📊',
            title: 'Invierte con Sentido',
            description: 'Fondos de inversión, ETFs e interés compuesto explicados simple.',
            progress: 0,
            xp: '80 XP',
            color: const Color(0xFFEDE9FF),
            accentColor: FinzennTheme.primaryBlue,
            locked: false,
          ),
          const SizedBox(height: 12),
          _buildLessonCard(
            emoji: '💳',
            title: 'Crédito sin Miedo',
            description: 'Entiende tu score crediticio y cómo mejorarlo.',
            progress: 0,
            xp: '60 XP',
            color: const Color(0xFFFFF3E0),
            accentColor: const Color(0xFFFF9800),
            locked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard({
    required String emoji,
    required String title,
    required String description,
    required double progress,
    required String xp,
    required Color color,
    required Color accentColor,
    bool locked = false,
  }) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: FinzennTheme.textDark)),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(fontSize: 12, color: FinzennTheme.textMuted, height: 1.3)),
                  ],
                ),
              ),
              if (locked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: FinzennTheme.bgColor, shape: BoxShape.circle),
                  child: const Icon(Icons.lock_outline, color: FinzennTheme.textMuted, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress,
                    backgroundColor: accentColor.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('+$xp', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
