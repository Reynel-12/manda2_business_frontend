import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS — consistentes con Login y Settings
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
  // static const inputFill = Color(0xFFF5F7FA);
  static const error = Color(0xFFE74C3C);
  static const primarySoft = Color(0xFFE8EFF7);
  // static const accentSoft = Color(0xFFFFF3EC);
  // static const successBg = Color(0xFFEAF6EE);
  static const success = Color(0xFF27AE60);
}

class _R {
  static const card = 18.0;
  static const input = 10.0;
  static const button = 10.0;
}

class _S {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  // static const xl = 32.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Controladores (sin cambios)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _referencesController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedMunicipality;
  final List<String> _municipalities = [
    'Selecciona tu municipio',
    'Municipio Centro',
    'Municipio Norte',
    'Municipio Sur',
    'Municipio Este',
    'Municipio Oeste',
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  // Fuerza de contraseña (0–3)
  int _passwordStrength = 0;

  late AnimationController _stepAnimController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _stepAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _stepAnimController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _stepAnimController, curve: Curves.easeOut),
        );
    _stepAnimController.forward();

    _passwordController.addListener(_evaluatePasswordStrength);
  }

  @override
  void dispose() {
    _stepAnimController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _neighborhoodController.dispose();
    _houseController.dispose();
    _referencesController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Lógica de negocio (sin cambios) ──────────────────────────────────────

  void _evaluatePasswordStrength() {
    final p = _passwordController.text;
    int strength = 0;
    if (p.length >= 6) strength++;
    if (p.contains(RegExp(r'[A-Z]'))) strength++;
    if (p.contains(RegExp(r'[0-9!@#\$&*]'))) strength++;
    setState(() => _passwordStrength = strength);
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 1) {
        setState(() => _currentStep++);
        _stepAnimController.reset();
        _stepAnimController.forward();
      } else {
        _submitForm();
      }
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('¡Cuenta creada exitosamente!'),
          ],
        ),
        backgroundColor: _C.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_R.input),
        ),
        margin: const EdgeInsets.all(_S.md),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _stepAnimController.reset();
      _stepAnimController.forward();
    } else {
      Navigator.pop(context);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;
    final maxWidth = isWide ? 520.0 : double.infinity;

    return Scaffold(
      backgroundColor: _C.bg,
      // AppBar plana y limpia — consistente con Login y Settings
      appBar: AppBar(
        backgroundColor: _C.bg,
        foregroundColor: _C.primary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _previousStep,
        ),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _C.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                // ── Stepper compacto en la AppBar region ─────────────────
                _buildStepper(),

                // ── Contenido del paso (scrollable) ───────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 0 : _S.md,
                      vertical: 18,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: _currentStep == 0
                            ? _buildStep1()
                            : _buildStep2(),
                      ),
                    ),
                  ),
                ),

                // ── Botones fijos al fondo ─────────────────────────────────
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Stepper rediseñado — compacto y claro ─────────────────────────────────

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.fromLTRB(_S.md, 2, _S.md, _S.md),
      color: _C.bg,
      child: Column(
        children: [
          // Barra de progreso linear
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 2,
              backgroundColor: _C.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(_C.accent),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: _S.sm),
          // Labels de pasos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepLabel(
                label: 'Datos del negocio',
                isActive: _currentStep == 0,
                isDone: _currentStep > 0,
              ),
              _StepLabel(
                label: 'Tu cuenta',
                isActive: _currentStep == 1,
                isDone: false,
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Paso 1: Datos personales ───────────────────────────────────────────────

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del paso
          _StepHeader(
            stepNumber: '1',
            title: 'Cuéntanos sobre tu negocio',
            subtitle: 'Necesitamos estos datos para tu cuenta',
          ),

          const SizedBox(height: _S.lg),

          // ── Grupo: Información personal ──────────────────────────────
          _GroupCard(
            label: 'Información personal',
            icon: Icons.person_outline_rounded,
            children: [
              _RegField(
                controller: _firstNameController,
                label: 'Nombre',
                icon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Ingresa tu nombre' : null,
              ),
              const _FieldDivider(),
              _RegField(
                controller: _lastNameController,
                label: 'Apellido',
                icon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Ingresa tu apellido' : null,
              ),
              const _FieldDivider(),
              _RegField(
                controller: _phoneController,
                label: 'Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Ingresa tu teléfono';
                  if (v!.length < 8) return 'Número inválido (mín. 8 dígitos)';
                  return null;
                },
              ),
            ],
          ),

          const SizedBox(height: _S.md),

          // ── Grupo: Ubicación ─────────────────────────────────────────
          _GroupCard(
            label: 'Municipio',
            icon: Icons.location_city_outlined,
            children: [
              _RegDropdown(
                value: _selectedMunicipality,
                items: _municipalities,
                onChanged: (v) => setState(() => _selectedMunicipality = v),
                validator: (v) => v == null || v == 'Selecciona tu municipio'
                    ? 'Selecciona un municipio'
                    : null,
              ),
            ],
          ),

          const SizedBox(height: _S.md),

          // ── Grupo: Dirección ─────────────────────────────────────────
          _GroupCard(
            label: 'Dirección de entrega',
            icon: Icons.home_outlined,
            children: [
              _RegField(
                controller: _neighborhoodController,
                label: 'Barrio / Colonia',
                icon: Icons.location_on_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Ingresa tu barrio' : null,
              ),
              const _FieldDivider(),
              _RegField(
                controller: _houseController,
                label: 'Casa / Edificio / Apartamento',
                icon: Icons.maps_home_work_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Ingresa tu dirección' : null,
              ),
              const _FieldDivider(),
              _RegField(
                controller: _referencesController,
                label: 'Referencias',
                icon: Icons.info_outline_rounded,
                maxLines: 3,
                isOptional: true,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),

          const SizedBox(height: _S.md),
        ],
      ),
    );
  }

  // ── Paso 2: Datos de cuenta ───────────────────────────────────────────────

  Widget _buildStep2() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            stepNumber: '2',
            title: 'Crea tu acceso',
            subtitle: 'Solo te falta un paso para empezar',
          ),

          const SizedBox(height: _S.lg),

          // ── Grupo: Credenciales ──────────────────────────────────────
          _GroupCard(
            label: 'Credenciales de acceso',
            icon: Icons.lock_outline_rounded,
            children: [
              _RegField(
                controller: _emailController,
                label: 'Correo electrónico',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Ingresa tu correo';
                  if (!v!.contains('@') || !v.contains('.'))
                    return 'Correo inválido';
                  return null;
                },
              ),
              const _FieldDivider(),
              // Campo contraseña con toggle
              _PasswordRegField(
                controller: _passwordController,
                label: 'Contraseña',
                obscure: _obscurePassword,
                onToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Ingresa una contraseña';
                  if (v!.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const _FieldDivider(),
              _PasswordRegField(
                controller: _confirmPasswordController,
                label: 'Confirmar contraseña',
                obscure: _obscureConfirmPassword,
                onToggle: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Confirma tu contraseña';
                  if (v != _passwordController.text)
                    return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
            ],
          ),

          const SizedBox(height: _S.md),

          // ── Indicador de fuerza de contraseña ────────────────────────
          if (_passwordController.text.isNotEmpty)
            _PasswordStrengthIndicator(strength: _passwordStrength),

          const SizedBox(height: _S.md),

          // ── Resumen del paso anterior ────────────────────────────────
          _SummaryCard(
            name: '${_firstNameController.text} ${_lastNameController.text}'
                .trim(),
            phone: _phoneController.text,
            municipality: _selectedMunicipality ?? '',
            previousStep: _previousStep,
          ),

          const SizedBox(height: _S.md),
        ],
      ),
    );
  }

  // ── Botones fijos al pie ─────────────────────────────────────────────────

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        _S.md,
        10,
        _S.md,
        _S.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: _C.surface,
        border: const Border(top: BorderSide(color: _C.divider, width: 1)),
      ),
      child: Row(
        children: [
          // Botón "Atrás" — solo un ghost button, peso visual mínimo
          if (_currentStep > 0)
            Padding(
              padding: const EdgeInsets.only(right: _S.sm),
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _C.primary,
                    side: const BorderSide(color: _C.inputBorder, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_R.button),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, size: 16),
                      SizedBox(width: _S.xs),
                      Text(
                        'Atrás',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Botón principal — CTA naranja, siempre expandido
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _C.accent.withValues(alpha: 0.65),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.button),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isSubmitting
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          key: const ValueKey('label'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 1
                                  ? 'Crear mi cuenta'
                                  : 'Continuar',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: _S.sm),
                            Icon(
                              _currentStep == 1
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 17,
                            ),
                          ],
                        ),
                ),
              ),
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

/// Label compacto del stepper
class _StepLabel extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDone;
  final bool alignRight;

  const _StepLabel({
    required this.label,
    required this.isActive,
    required this.isDone,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isDone) {
      color = _C.success;
    } else if (isActive) {
      color = _C.accent;
    } else {
      color = _C.textMuted;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDone)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: _C.success,
            ),
          ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Encabezado de cada paso con número, título y subtítulo
class _StepHeader extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _C.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: _S.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.primary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: _C.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

/// Card contenedora de un grupo de campos relacionados
class _GroupCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Widget> children;

  const _GroupCard({
    required this.label,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label de sección fuera de la card
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: _S.sm),
          child: Row(
            children: [
              Icon(icon, size: 13, color: _C.textMuted),
              const SizedBox(width: _S.xs),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _C.textMuted,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        // Card con todos los campos agrupados
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.circular(_R.card),
            border: Border.all(color: _C.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// Campo de texto dentro de un GroupCard — sin borde propio (la card lo provee)
class _RegField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool isOptional;
  final String? Function(String?)? validator;

  const _RegField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.isOptional = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 3),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 14,
          color: _C.textSec,
          fontWeight: FontWeight.w500,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
          suffixText: isOptional ? 'Opcional' : null,
          suffixStyle: const TextStyle(fontSize: 11, color: _C.textMuted),
          prefixIcon: Icon(icon, size: 17, color: _C.primary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // El error sí muestra su underline semántico
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _C.error, width: 1),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _C.error, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

/// Campo de contraseña dentro de GroupCard
class _PasswordRegField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _PasswordRegField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 3),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textInputAction: textInputAction,
        style: const TextStyle(
          fontSize: 14,
          color: _C.textSec,
          fontWeight: FontWeight.w500,
        ),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: _C.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: _C.textMuted,
            ),
            onPressed: onToggle,
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _C.error, width: 1),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: _C.error, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

/// Dropdown dentro de GroupCard — estilo consistente con _RegField
class _RegDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const _RegDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 3),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.expand_more_rounded,
          color: _C.primary,
          size: 20,
        ),
        style: const TextStyle(
          fontSize: 14,
          color: _C.textSec,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          labelText: 'Municipio',
          labelStyle: TextStyle(fontSize: 13, color: _C.textMuted),
          prefixIcon: Icon(
            Icons.location_city_outlined,
            size: 17,
            color: _C.primary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _C.error, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        ),
        items: items
            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

/// Separador fino entre campos del mismo grupo
class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50, right: 14),
      height: 1,
      color: _C.divider,
    );
  }
}

/// Indicador de fuerza de contraseña — 3 segmentos coloreados
class _PasswordStrengthIndicator extends StatelessWidget {
  final int strength; // 0–3

  const _PasswordStrengthIndicator({required this.strength});

  Color get _color {
    switch (strength) {
      case 1:
        return _C.error;
      case 2:
        return const Color(0xFFF39C12);
      case 3:
        return _C.success;
      default:
        return _C.divider;
    }
  }

  String get _label {
    switch (strength) {
      case 1:
        return 'Contraseña débil';
      case 2:
        return 'Contraseña regular';
      case 3:
        return 'Contraseña fuerte';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_S.md),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.card),
        border: Border.all(color: _C.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: List.generate(3, (i) {
                      final filled = i < strength;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 4,
                          margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: filled ? _color : _C.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: _S.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _label,
                  key: ValueKey(strength),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _S.sm),
          const Text(
            'Usa mayúsculas, números o símbolos para una contraseña más segura.',
            style: TextStyle(fontSize: 11, color: _C.textMuted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de resumen del paso 1 — mostrada en el paso 2
class _SummaryCard extends StatelessWidget {
  final String name;
  final String phone;
  final String municipality;
  final Function() previousStep;

  const _SummaryCard({
    required this.name,
    required this.phone,
    required this.municipality,
    required this.previousStep,
  });

  @override
  Widget build(BuildContext context) {
    if (name.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(_S.md),
      decoration: BoxDecoration(
        color: _C.primarySoft,
        borderRadius: BorderRadius.circular(_R.card),
        border: Border.all(color: _C.primary.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _C.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: _S.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _C.primary,
                  ),
                ),
                if (phone.isNotEmpty || municipality.isNotEmpty)
                  Text(
                    [
                      if (phone.isNotEmpty) phone,
                      if (municipality.isNotEmpty &&
                          municipality != 'Selecciona tu municipio')
                        municipality,
                    ].join(' · '),
                    style: const TextStyle(fontSize: 12, color: _C.textMuted),
                  ),
              ],
            ),
          ),
          // Botón para editar el paso anterior
          GestureDetector(
            onTap: () {
              previousStep();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _C.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Text(
                'Editar',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _C.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
