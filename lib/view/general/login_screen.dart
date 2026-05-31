import 'package:flutter/material.dart';
import 'package:manda2_business_frontend/view/business/business_dashboard.dart';
import 'package:manda2_business_frontend/view/general/create_account_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const primary = Color(0xFF05386B);
  static const accent = Color(0xFFFF6B00);
  static const bg = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textSec = Color(0xFF2C3E50);
  static const textMuted = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);
  static const inputBorder = Color(0xFFE2E8F0);
}

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ── Lógica de negocio (sin cambios) ──────────────────────────────────────

  Future<void> _handleLogin() async {
    // Feedback visual de carga
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Widget nextScreen;

    // if (email == 'Repartidor') {
    //   nextScreen = const DeliveryHomeScreen();
    // } else

    nextScreen = const BusinessDashboardScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 600;
    final maxWidth = isWide ? 440.0 : double.infinity;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 0 : 24,
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Header: logo + marca ───────────────────────────
                      _buildHeader(),

                      const SizedBox(height: 34),

                      // ── Tarjeta del formulario ─────────────────────────
                      _buildFormCard(),

                      const SizedBox(height: 20),

                      // ── Footer: registro ───────────────────────────────
                      _buildRegisterFooter(),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Sección header ────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo — forma de "entrega": caja con flecha
        _AppLogo(),
        const SizedBox(height: 20),
        const Text(
          'Manda2 - Negocios',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: _C.primary,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Delivery local, rápido y cercano para tu negocio',
          style: TextStyle(
            fontSize: 14,
            color: _C.textMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Card del formulario ───────────────────────────────────────────────────

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado de la card
          const Text(
            'Bienvenido de vuelta',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _C.primary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ingresa a tu cuenta para continuar',
            style: TextStyle(fontSize: 13, color: _C.textMuted),
          ),

          const SizedBox(height: 22),

          // Campo email
          _LoginField(
            controller: _emailController,
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 12),

          // Campo contraseña
          _PasswordField(
            controller: _passwordController,
            obscure: _obscurePassword,
            onToggle: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),

          // "¿Olvidaste?" — adyacente al campo de contraseña
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Navegar a recuperación
              },
              style: TextButton.styleFrom(
                foregroundColor: _C.accent,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // "Recordar sesión" — con switch en lugar de checkbox
          _RememberMeRow(
            value: _rememberMe,
            onChanged: (v) => setState(() => _rememberMe = v ?? false),
          ),

          const SizedBox(height: 24),

          // Botón principal de login
          _LoginButton(
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleLogin,
          ),
        ],
      ),
    );
  }

  // ── Footer de registro ────────────────────────────────────────────────────

  Widget _buildRegisterFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _C.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿No tienes cuenta?',
            style: TextStyle(fontSize: 14, color: _C.textMuted),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: _C.accent,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Crear cuenta',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBCOMPONENTES
// ─────────────────────────────────────────────────────────────────────────────

/// Logo de la app construido con primitivas SVG/Canvas — sin assets externos
class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _C.divider),
        // Sombra sutil de color — no exagerada
        boxShadow: [
          BoxShadow(
            color: _C.primary.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Accent dot en esquina superior derecha — señal de "activo"
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _C.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Ícono compuesto: caja + velocidad
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: _C.primary,
                size: 28,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 2,
                    color: _C.primary.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 3),
                  Container(width: 10, height: 2, color: _C.primary),
                  const SizedBox(width: 3),
                  Container(
                    width: 6,
                    height: 2,
                    color: _C.primary.withValues(alpha: 0.45),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Campo de texto con estilo unificado
class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const _LoginField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(
        fontSize: 15,
        color: _C.textSec,
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(label: label, icon: icon),
    );
  }
}

/// Campo de contraseña con toggle de visibilidad
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        fontSize: 15,
        color: _C.textSec,
        fontWeight: FontWeight.w500,
      ),
      decoration: _fieldDecoration(
        label: 'Contraseña',
        icon: Icons.lock_outline_rounded,
        suffix: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: _C.textMuted,
          ),
          onPressed: onToggle,
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }
}

/// Decoración unificada para campos de texto
InputDecoration _fieldDecoration({
  required String label,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14, color: _C.textMuted),
    prefixIcon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Icon(icon, size: 20, color: _C.primary),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _C.inputBorder, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _C.inputBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _C.primary, width: 1.5),
    ),
  );
}

/// Fila "Recordar sesión" con Switch en lugar de Checkbox
class _RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _RememberMeRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 20,
            child: Transform.scale(
              scale: 0.75,
              alignment: Alignment.centerLeft,
              child: Switch(
                value: value,
                onChanged: onChanged,
                trackColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.selected)) {
                    return _C.primary; // color cuando está seleccionado
                  }
                  return null; // o un color por defecto
                }),
                activeThumbColor: _C.accent,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: _C.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Mantener sesión iniciada',
            style: TextStyle(
              fontSize: 13,
              color: _C.textSec,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón de login con estado de carga
class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _C.accent.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  key: ValueKey('label'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}
