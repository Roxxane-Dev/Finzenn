import 'package:flutter/material.dart';
import '../../theme/finzenn_theme.dart';
import '../../widgets/finzenn_cards.dart';
import '../../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? FinzennTheme.error : FinzennTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitForm() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || pass.isEmpty || (_isSignUp && name.isEmpty)) {
      _showSnack('Por favor completa todos los campos', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        await _authService.signUp(email: email, password: pass, name: name);
        _showSnack('¡Cuenta creada correctamente! Ingresando...');
        // Si Supabase requiere confirmación por email, informarlo aquí. Por ahora, asume login directo.
      } else {
        await _authService.signIn(email: email, password: pass);
      }
    } catch (error) {
      _showSnack('Error: ${error.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showSnack('Error en Google Sign-In: $e', isError: true);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Escribe tu correo para recuperar contraseña', isError: true);
      return;
    }
    try {
      await _authService.sendPasswordReset(email);
      _showSnack('Enlace de recuperación enviado al correo.');
    } catch (e) {
      _showSnack('Hubo un error al enviar el enlace.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzennTheme.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo superior
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: FinzennTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text('Finzenn', style: TextStyle(
                    color: FinzennTheme.primaryBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  )),
                ],
              ),
              const SizedBox(height: 32),

              // Mascota / Avatar central
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBryMIZFyCsvi16KV2HMoe5pCOK66S_uUZA2_pUapvMuLpkJqcKkcAfS3HtGyT6g8SoxHkRqAArZHade-CVTEEF1zKw0GN-nX35EgEg3ZuH1IdPl1_w0KL-SvxHTffSMI8pBxeODUJZu16TSEuZ_FIErR5T2JIxBxWF4VpCgXr6oUBxAJM60J0VXI7leHyHy3l_T54M9fIUM0DJhNELxf_24xJXC1p7_YQU1uyOkpnr8eVlpC8a6TlZOvqRILfqfdP-HD48ZWGURFk"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(color: FinzennTheme.primaryBlue.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, 12))
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: FinzennTheme.softPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.auto_awesome, color: FinzennTheme.primaryBlue, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text('Tu Hogar Financiero', style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w900, color: FinzennTheme.textDark
              )),
              const SizedBox(height: 8),
              const Text('Experimenta una forma más inteligente y segura de gestionar tu riqueza con Finzenn.', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: FinzennTheme.textSecondary, height: 1.4)
              ),
              const SizedBox(height: 32),

              // Tarjeta Formulario Glassmorphism
              WhiteCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Segmented Control (Sign In / Sign Up)
                    Container(
                      height: 50,
                      decoration: BoxDecoration(color: FinzennTheme.bgColor, borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() { _isSignUp = false; _passwordController.clear(); }),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !_isSignUp ? FinzennTheme.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: !_isSignUp ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
                                ),
                                alignment: Alignment.center,
                                child: Text('Sign In', style: TextStyle(
                                  color: !_isSignUp ? FinzennTheme.primaryBlue : FinzennTheme.textSecondary,
                                  fontWeight: FontWeight.w800, fontSize: 14,
                                )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() { _isSignUp = true; _passwordController.clear(); }),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isSignUp ? FinzennTheme.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: _isSignUp ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
                                ),
                                alignment: Alignment.center,
                                child: Text('Sign Up', style: TextStyle(
                                  color: _isSignUp ? FinzennTheme.primaryBlue : FinzennTheme.textSecondary,
                                  fontWeight: FontWeight.w800, fontSize: 14,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Inputs dinámicos
                    if (_isSignUp) ...[
                      _buildInputField('NOMBRE COMPLETO', 'Tu nombre', Icons.person_outline, _nameController),
                      const SizedBox(height: 16),
                    ],
                    _buildInputField('CORREO ELECTRÓNICO', 'name@ejemplo.com', Icons.mail_outline, _emailController),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 24),

                    // Botón Principal
                    ElevatedButton(
                      style: FinzennTheme.lightTheme.elevatedButtonTheme.style,
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_isSignUp ? 'Crear mi cuenta' : 'Continuar al Hogar'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Divisor
                    Row(
                      children: [
                        Expanded(child: Container(height: 1, color: FinzennTheme.bgColor)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('O CONTINÚA CON', style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w800, color: FinzennTheme.textMuted, letterSpacing: 1
                          )),
                        ),
                        Expanded(child: Container(height: 1, color: FinzennTheme.bgColor)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Botón Google (OAuth Nativo Web/Desktop)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: BorderSide(color: FinzennTheme.textMuted.withOpacity(0.3)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.g_mobiledata, color: FinzennTheme.textDark, size: 32),
                          SizedBox(width: 8),
                          Text('Google Account', style: TextStyle(
                            color: FinzennTheme.textDark, fontWeight: FontWeight.w800, fontSize: 16
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Footer Legal
              const Text('Al continuar, aceptas nuestros', style: TextStyle(color: FinzennTheme.textMuted, fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Términos de Servicio', style: TextStyle(color: FinzennTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                  Text(' & ', style: TextStyle(color: FinzennTheme.textMuted, fontSize: 12)),
                  Text('Póliza de Privacidad', style: TextStyle(color: FinzennTheme.primaryBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1
        )),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: FinzennTheme.bgColor, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: FinzennTheme.textMuted, fontSize: 14),
              prefixIcon: Icon(icon, color: FinzennTheme.textMuted, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('CONTRASEÑA', style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w900, color: FinzennTheme.textMuted, letterSpacing: 1
            )),
            if (!_isSignUp)
              GestureDetector(
                onTap: _forgotPassword,
                child: const Text('¿Olvidaste?', style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, color: FinzennTheme.primaryBlue
                )),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: FinzennTheme.bgColor, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: const TextStyle(color: FinzennTheme.textMuted, fontSize: 14),
              prefixIcon: const Icon(Icons.lock_outline, color: FinzennTheme.textMuted, size: 20),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: FinzennTheme.textMuted, size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
