import 'package:flutter/material.dart';
import '../../theme/finzenn_theme.dart';
import '../../widgets/finzenn_cards.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] ?? 'Usuario Fintech';
    final email = user?.email ?? 'correo@ejemplo.com';

    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      appBar: AppBar(
        backgroundColor: FinzennTheme.bgColor,
        elevation: 0,
        leading: const BackButton(color: FinzennTheme.textDark),
        title: const Text('Mi Perfil', style: TextStyle(color: FinzennTheme.textDark, fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // Avatar y Header
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: FinzennTheme.blueGradient,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))],
                      ),
                      child: const Center(child: Text('🦉', style: TextStyle(fontSize: 48))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: FinzennTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: const Icon(Icons.edit, color: FinzennTheme.primaryBlue, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 14, color: FinzennTheme.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: FinzennTheme.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Text('Cuentas Conectadas', style: TextStyle(color: FinzennTheme.success, fontWeight: FontWeight.w800, fontSize: 10)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Enlaces rápidos
          WhiteCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildActionRow(Icons.person_outline, 'Detalles de la cuenta'),
                const Divider(height: 1, color: FinzennTheme.bgColor),
                _buildActionRow(Icons.security, 'Seguridad y PIN'),
                const Divider(height: 1, color: FinzennTheme.bgColor),
                _buildActionRow(Icons.language, 'Idioma de la aplicación'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botón Cerrar Sesión
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              side: const BorderSide(color: FinzennTheme.error),
              foregroundColor: FinzennTheme.error,
            ),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout, size: 20),
                SizedBox(width: 8),
                Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: FinzennTheme.softPurple.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: FinzennTheme.primaryBlue, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: FinzennTheme.textDark)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: FinzennTheme.textMuted),
      onTap: () {},
    );
  }
}
