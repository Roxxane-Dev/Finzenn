import 'package:flutter/material.dart';
import '../theme/finzenn_theme.dart';
import '../widgets/finzenn_cards.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      appBar: AppBar(
        backgroundColor: FinzennTheme.bgColor,
        elevation: 0,
        title: const Text(
          'Asistente IA',
          style: TextStyle(color: FinzennTheme.textDark, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: FinzennTheme.primaryBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: PurpleCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Text('🤖', style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Copiloto Finzenn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Siempre disponible para ayudarte', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              children: [
                _buildMsg('Hola 👋 Soy tu copiloto financiero. ¿Cómo puedo ayudarte hoy?', isAi: true),
                _buildMsg('¿En qué estoy gastando más este mes?', isAi: false),
                _buildMsg('📊 Analizando tus datos...\n\nTu mayor categoría de gasto este mes es:\n\n🍕 **Comida & Delivery → \$380.00** (38%)\n🚗 Transporte → \$200.00 (20%)\n🎬 Entretenimiento → \$150.00 (15%)\n\n¿Quieres que cree un presupuesto límite para Comida?', isAi: true),
                _buildChips(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: WhiteCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 30,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: FinzennTheme.softPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.mic, color: FinzennTheme.primaryBlue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Escribe o usa tu voz...",
                        hintStyle: TextStyle(color: FinzennTheme.textMuted, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: FinzennTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMsg(String text, {required bool isAi}) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAi ? FinzennTheme.white : FinzennTheme.primaryBlue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isAi ? 4 : 20),
            bottomRight: Radius.circular(isAi ? 20 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: isAi ? Colors.black12 : FinzennTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAi ? FinzennTheme.textDark : Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildChips() {
    final List<String> suggestions = ['Sí, crear presupuesto', '¿Puedo gastar hoy?', 'Ver mis ahorros'];
    return Wrap(
      spacing: 8,
      children: suggestions.map((s) {
        return ActionChip(
          label: Text(s, style: const TextStyle(color: FinzennTheme.primaryBlue, fontWeight: FontWeight.w600, fontSize: 12)),
          backgroundColor: FinzennTheme.softPurple,
          side: BorderSide.none,
          onPressed: () {},
        );
      }).toList(),
    );
  }
}
