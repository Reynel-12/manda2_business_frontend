import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manda2_business_frontend/view/general/login_screen.dart';

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFF0F2B46);
  static const primaryLight = Color(0xFF2C5B82);
  static const primarySurface = Color(0xFFF0F5FA);
  static const accent = Color(0xFFE96A2C);
  static const accentSurface = Color(0xFFFFF2EA);
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const surfaceSoft = Color(0xFFF9FBFD);
  static const textPrimary = Color(0xFF132238);
  static const textSecondary = Color(0xFF40546A);
  static const textMuted = Color(0xFF8695A5);
  static const divider = Color(0xFFE7EDF2);
  static const error = Color(0xFFE74C3C);
  static const errorSurface = Color(0xFFFDEDEC);
  static const success = Color(0xFF1E8E5A);
  static const successSurface = Color(0xFFEAF7EF);
  static const warning = Color(0xFFF39C12);
  static const warningSurface = Color(0xFFFEF9EC);
  static const textSec = Color(0xFF2C3E50);
  static const primarySoft = Color(0xFFE8EFF7);
}

class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(10));
  static const md = BorderRadius.all(Radius.circular(14));
  static const lg = BorderRadius.all(Radius.circular(18));
  static const xl = BorderRadius.all(Radius.circular(24));
  static const card = 14.0;
  static const button = 10.0;
}

class _S {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
}

class AppShadow {
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF0F2B46).withOpacity(0.08),
      blurRadius: 22,
      offset: const Offset(0, 8),
    ),
  ];
  static List<BoxShadow> bottom = [
    BoxShadow(
      color: const Color(0xFF0F2B46).withOpacity(0.08),
      blurRadius: 22,
      offset: const Offset(0, -6),
    ),
  ];
}

// ─────────────────────────────────────────────
//  TIME HELPER — sin librería intl
// ─────────────────────────────────────────────
String _formatTime(TimeOfDay t) {
  final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

// ─────────────────────────────────────────────
//  MODELOS
// ─────────────────────────────────────────────
class BusinessProfile {
  final String name;
  final String description;
  final String logoUrl;
  final List<String> bannerUrls;
  final String address;
  final String city;
  final String phone;
  final String email;
  final String website;
  final List<BusinessDay> schedule;
  final List<String> categories;
  final double deliveryRadius;
  final int preparationTime;
  final bool isActive;

  const BusinessProfile({
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.bannerUrls,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.website,
    required this.schedule,
    required this.categories,
    required this.deliveryRadius,
    required this.preparationTime,
    required this.isActive,
  });

  BusinessProfile copyWith({
    String? name,
    String? description,
    String? logoUrl,
    List<String>? bannerUrls,
    String? address,
    String? city,
    String? phone,
    String? email,
    String? website,
    List<BusinessDay>? schedule,
    List<String>? categories,
    double? deliveryRadius,
    int? preparationTime,
    bool? isActive,
  }) => BusinessProfile(
    name: name ?? this.name,
    description: description ?? this.description,
    logoUrl: logoUrl ?? this.logoUrl,
    bannerUrls: bannerUrls ?? this.bannerUrls,
    address: address ?? this.address,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    website: website ?? this.website,
    schedule: schedule ?? this.schedule,
    categories: categories ?? this.categories,
    deliveryRadius: deliveryRadius ?? this.deliveryRadius,
    preparationTime: preparationTime ?? this.preparationTime,
    isActive: isActive ?? this.isActive,
  );
}

class BusinessDay {
  final String day;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  final bool isOpen;

  const BusinessDay({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isOpen,
  });

  BusinessDay copyWith({
    String? day,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    bool? isOpen,
  }) => BusinessDay(
    day: day ?? this.day,
    openTime: openTime ?? this.openTime,
    closeTime: closeTime ?? this.closeTime,
    isOpen: isOpen ?? this.isOpen,
  );
}

// ─────────────────────────────────────────────
//  PANTALLA PRINCIPAL
// ─────────────────────────────────────────────
class BusinessSettingsScreen extends StatefulWidget {
  final bool isTab;
  const BusinessSettingsScreen({super.key, this.isTab = false});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  BusinessProfile _profile = BusinessProfile(
    name: 'Restaurante La Esquina',
    description: 'Comida tradicional con sabor casero',
    logoUrl: '__mock__',
    bannerUrls: ['__mock__', '__mock__'],
    address: 'Av. Principal #123, Colonia Centro',
    city: 'Ciudad de México',
    phone: '+52 55 1234 5678',
    email: 'contacto@laesquina.com',
    website: 'www.laesquina.com',
    schedule: [
      BusinessDay(
        day: 'Lunes',
        openTime: const TimeOfDay(hour: 8, minute: 0),
        closeTime: const TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Martes',
        openTime: const TimeOfDay(hour: 8, minute: 0),
        closeTime: const TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Miércoles',
        openTime: const TimeOfDay(hour: 8, minute: 0),
        closeTime: const TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Jueves',
        openTime: const TimeOfDay(hour: 8, minute: 0),
        closeTime: const TimeOfDay(hour: 22, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Viernes',
        openTime: const TimeOfDay(hour: 8, minute: 0),
        closeTime: const TimeOfDay(hour: 23, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Sábado',
        openTime: const TimeOfDay(hour: 9, minute: 0),
        closeTime: const TimeOfDay(hour: 23, minute: 0),
        isOpen: true,
      ),
      BusinessDay(
        day: 'Domingo',
        openTime: const TimeOfDay(hour: 10, minute: 0),
        closeTime: const TimeOfDay(hour: 18, minute: 0),
        isOpen: true,
      ),
    ],
    categories: ['Restaurante', 'Comida Mexicana', 'Desayunos'],
    deliveryRadius: 5.0,
    preparationTime: 25,
    isActive: true,
  );

  late TextEditingController _nameCtrl,
      _descCtrl,
      _addrCtrl,
      _cityCtrl,
      _phoneCtrl,
      _emailCtrl,
      _webCtrl,
      _radiusCtrl,
      _prepCtrl;

  bool _isEditing = false;
  bool _isSaving = false;

  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Para animar transición modo vista ↔ edición
  late AnimationController _modeCtrl;

  @override
  void initState() {
    super.initState();
    _initControllers();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _modeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _modeCtrl.dispose();
    for (final c in [
      _nameCtrl,
      _descCtrl,
      _addrCtrl,
      _cityCtrl,
      _phoneCtrl,
      _emailCtrl,
      _webCtrl,
      _radiusCtrl,
      _prepCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController(text: _profile.name);
    _descCtrl = TextEditingController(text: _profile.description);
    _addrCtrl = TextEditingController(text: _profile.address);
    _cityCtrl = TextEditingController(text: _profile.city);
    _phoneCtrl = TextEditingController(text: _profile.phone);
    _emailCtrl = TextEditingController(text: _profile.email);
    _webCtrl = TextEditingController(text: _profile.website);
    _radiusCtrl = TextEditingController(
      text: _profile.deliveryRadius.toString(),
    );
    _prepCtrl = TextEditingController(
      text: _profile.preparationTime.toString(),
    );
  }

  void _startEditing() {
    HapticFeedback.selectionClick();
    setState(() => _isEditing = true);
    _modeCtrl.forward();
  }

  void _cancelEditing() {
    HapticFeedback.selectionClick();
    setState(() => _isEditing = false);
    _modeCtrl.reverse();
    _initControllers();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.heavyImpact();
    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    setState(() {
      _profile = _profile.copyWith(
        name: _nameCtrl.text,
        description: _descCtrl.text,
        address: _addrCtrl.text,
        city: _cityCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
        website: _webCtrl.text,
        deliveryRadius: double.tryParse(_radiusCtrl.text) ?? 5.0,
        preparationTime: int.tryParse(_prepCtrl.text) ?? 25,
      );
      _isEditing = false;
      _isSaving = false;
    });
    _modeCtrl.reverse();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Cambios guardados',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;
    final isDesktop = size.width >= 1200;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                isDesktop
                    ? 56
                    : isWide
                    ? 32
                    : 16,
                0,
                isDesktop
                    ? 56
                    : isWide
                    ? 32
                    : 16,
                _isEditing ? 112 : 28,
              ),
              children: [
                // Banner de modo edición
                _buildEditModeBanner(),
                const SizedBox(height: 16),
                // Header del negocio
                _buildBusinessHeader(),
                const SizedBox(height: 16),
                // Banners
                _buildBannersSection(),
                const SizedBox(height: 16),
                // Información básica
                _buildInfoSection(isWide),
                const SizedBox(height: 16),
                // Horario + Delivery en fila si es wide
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildScheduleSection()),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildDeliverySection()),
                    ],
                  )
                else ...[
                  _buildScheduleSection(),
                  const SizedBox(height: 16),
                  _buildDeliverySection(),
                ],
                const SizedBox(height: 16),
                // Grupo 3: Sesión (separado y con énfasis en peligro)
                _SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: _SettingRow(
                    icon: Icons.logout_rounded,
                    label: 'Cerrar sesión',
                    isDangerous: true,
                    onTap: () => _confirmLogout(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      // Bottom CTA — solo visible en modo edición
      bottomNavigationBar: _isEditing ? _buildBottomBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: widget.isTab
          ? null
          : IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(Icons.arrow_back, size: 18),
              ),
              onPressed: () {
                if (_isEditing) {
                  _showDiscardDialog();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mi negocio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'Configuración del perfil',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        if (!_isEditing)
          TextButton.icon(
            onPressed: _startEditing,
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            label: const Text(
              'Editar',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surfaceSoft,
              side: const BorderSide(color: AppColors.divider),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.divider),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BANNER MODO EDICIÓN
  // ─────────────────────────────────────────────
  Widget _buildEditModeBanner() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: _isEditing
          ? Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentSurface,
                borderRadius: AppRadius.md,
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    size: 16,
                    color: AppColors.accent,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Modo edición activo. Los cambios se guardan al presionar "Guardar".',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // ─────────────────────────────────────────────
  //  HEADER DEL NEGOCIO (logo + nombre + status)
  // ─────────────────────────────────────────────
  Widget _buildBusinessHeader() {
    return _SectionCard(
      title: 'Identidad',
      icon: Icons.store_outlined,
      child: Row(
        children: [
          // Logo
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: _profile.logoUrl == '__mock__'
                    ? const Icon(
                        Icons.store,
                        color: AppColors.primary,
                        size: 32,
                      )
                    : Image.network(
                        _profile.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textMuted,
                          size: 28,
                        ),
                      ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Nombre y descripción
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profile.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _profile.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: _profile.categories
                      .map(
                        (c) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: AppRadius.sm,
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Text(
                            c,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Estado del negocio — acción de alto impacto bien etiquetada
          _buildActiveToggle(),
        ],
      ),
    );
  }

  Widget _buildActiveToggle() {
    final isActive = _profile.isActive;
    return GestureDetector(
      onTap: _isEditing
          ? () {
              HapticFeedback.selectionClick();
              if (!isActive) {
                setState(() => _profile = _profile.copyWith(isActive: true));
              } else {
                _showDeactivateDialog();
              }
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.successSurface : AppColors.errorSurface,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isActive
                ? AppColors.success.withOpacity(0.3)
                : AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              isActive
                  ? Icons.check_circle_outline
                  : Icons.pause_circle_outline,
              size: 20,
              color: isActive ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 3),
            Text(
              isActive ? 'Activo' : 'Inactivo',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BANNERS
  // ─────────────────────────────────────────────
  Widget _buildBannersSection() {
    return _SectionCard(
      title: 'Banners',
      icon: Icons.photo_library_outlined,
      badge: '${_profile.bannerUrls.length} fotos',
      child: SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _profile.bannerUrls.length + (_isEditing ? 1 : 0),
          itemBuilder: (ctx, i) {
            if (i == _profile.bannerUrls.length) {
              return _AddBannerSlot(onTap: () {});
            }
            return _BannerSlot(
              url: _profile.bannerUrls[i],
              canDelete: _isEditing,
              onDelete: () => setState(() {
                final updated = List<String>.from(_profile.bannerUrls)
                  ..removeAt(i);
                _profile = _profile.copyWith(bannerUrls: updated);
              }),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  INFORMACIÓN BÁSICA
  // ─────────────────────────────────────────────
  Widget _buildInfoSection(bool isWide) {
    return _SectionCard(
      title: 'Información básica',
      icon: Icons.info_outline,
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoLeft()),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoRight()),
              ],
            )
          : Column(
              children: [
                _buildInfoLeft(),
                const SizedBox(height: 14),
                _buildInfoRight(),
              ],
            ),
    );
  }

  Widget _buildInfoLeft() {
    return Column(
      children: [
        _AppField(
          ctrl: _nameCtrl,
          label: 'Nombre del negocio',
          hint: 'Ej: Restaurante La Esquina',
          icon: Icons.store_outlined,
          enabled: _isEditing,
          validator: (v) =>
              (v ?? '').trim().isEmpty ? 'El nombre es requerido' : null,
        ),
        const SizedBox(height: 14),
        _AppField(
          ctrl: _descCtrl,
          label: 'Descripción',
          hint: 'Describe tu negocio...',
          icon: Icons.notes_outlined,
          enabled: _isEditing,
          maxLines: 3,
        ),
        const SizedBox(height: 14),
        _AppField(
          ctrl: _phoneCtrl,
          label: 'Teléfono',
          hint: '+52 55 1234 5678',
          icon: Icons.phone_outlined,
          enabled: _isEditing,
          keyboard: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _AppField(
          ctrl: _emailCtrl,
          label: 'Correo electrónico',
          hint: 'contacto@negocio.com',
          icon: Icons.email_outlined,
          enabled: _isEditing,
          keyboard: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildInfoRight() {
    return Column(
      children: [
        _AppField(
          ctrl: _addrCtrl,
          label: 'Dirección',
          hint: 'Av. Principal #123',
          icon: Icons.location_on_outlined,
          enabled: _isEditing,
        ),
        const SizedBox(height: 14),
        _AppField(
          ctrl: _cityCtrl,
          label: 'Ciudad',
          hint: 'Ciudad de México',
          icon: Icons.location_city_outlined,
          enabled: _isEditing,
        ),
        const SizedBox(height: 14),
        _AppField(
          ctrl: _webCtrl,
          label: 'Sitio web',
          hint: 'www.minegocio.com',
          icon: Icons.language_outlined,
          enabled: _isEditing,
          keyboard: TextInputType.url,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  HORARIO
  // ─────────────────────────────────────────────
  Widget _buildScheduleSection() {
    final openDays = _profile.schedule.where((d) => d.isOpen).length;
    return _SectionCard(
      title: 'Horario de atención',
      icon: Icons.schedule_outlined,
      badge: '$openDays/7 días',
      child: Column(
        children: _profile.schedule.asMap().entries.map((entry) {
          final i = entry.key;
          final day = entry.value;
          final isLast = i == _profile.schedule.length - 1;
          return _ScheduleRow(
            day: day,
            isEditing: _isEditing,
            showDivider: !isLast,
            onToggle: (v) => setState(() {
              _profile.schedule[i] = day.copyWith(isOpen: v);
            }),
            onEditTime: () async {
              final open = await showTimePicker(
                context: context,
                initialTime: day.openTime,
              );
              if (open == null || !mounted) return;
              final close = await showTimePicker(
                context: context,
                initialTime: day.closeTime,
              );
              if (close != null) {
                setState(
                  () => _profile.schedule[i] = day.copyWith(
                    openTime: open,
                    closeTime: close,
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  DELIVERY
  // ─────────────────────────────────────────────
  Widget _buildDeliverySection() {
    return _SectionCard(
      title: 'Operaciones',
      icon: Icons.delivery_dining_outlined,
      child: Column(
        children: [
          _AppField(
            ctrl: _radiusCtrl,
            label: 'Radio de entrega',
            hint: '5',
            icon: Icons.map_outlined,
            enabled: _isEditing,
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            suffixText: 'km',
            validator: (v) {
              final n = double.tryParse(v ?? '');
              return (n == null || n <= 0) ? 'Ingresa un radio válido' : null;
            },
          ),
          const SizedBox(height: 14),
          _AppField(
            ctrl: _prepCtrl,
            label: 'Tiempo de preparación',
            hint: '25',
            icon: Icons.timer_outlined,
            enabled: _isEditing,
            keyboard: TextInputType.number,
            suffixText: 'min',
            validator: (v) {
              final n = int.tryParse(v ?? '');
              return (n == null || n < 0) ? 'Ingresa un tiempo válido' : null;
            },
          ),
          if (!_isEditing) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            // Métricas rápidas en vista
            Row(
              children: [
                _MetricChip(
                  icon: Icons.map_outlined,
                  label: '${_profile.deliveryRadius} km',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _MetricChip(
                  icon: Icons.timer_outlined,
                  label: '${_profile.preparationTime} min',
                  color: AppColors.accent,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BOTTOM CTA
  // ─────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: AppShadow.bottom,
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: _isSaving ? null : _cancelEditing,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              side: const BorderSide(color: AppColors.divider),
              minimumSize: const Size(100, 52),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Guardar cambios',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  DIÁLOGOS
  // ─────────────────────────────────────────────
  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: const Text(
          '¿Descartar cambios?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Los cambios que hiciste no se guardarán.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Seguir editando',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelEditing();
              Navigator.pop(context);
            },
            child: const Text(
              'Descartar',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: const Text(
          '¿Desactivar negocio?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Tu negocio dejará de aparecer en la aplicación y los clientes no podrán hacer pedidos.',
          style: TextStyle(color: AppColors.textMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _profile = _profile.copyWith(isActive: false));
            },
            child: const Text(
              'Desactivar',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(height: _S.md),
            const Text(
              'Cerrar sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: _S.sm),
            const Text(
              '¿Seguro que deseas salir de tu cuenta?',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSec,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: _S.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Salir',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: SECTION CARD
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final String? badge;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Icon(icon, size: 15, color: AppColors.primaryLight),
                const SizedBox(width: 7),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.1,
                  ),
                ),
                if (badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: APP FIELD  (vista + edición)
// ─────────────────────────────────────────────
class _AppField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;
  final bool enabled;
  final int maxLines;
  final TextInputType? keyboard;
  final String? suffixText;
  final String? Function(String?)? validator;

  const _AppField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    required this.enabled,
    this.maxLines = 1,
    this.keyboard,
    this.suffixText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // En modo vista: texto legible sin apariencia de campo deshabilitado
    if (!enabled) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ctrl.text.isEmpty ? '—' : ctrl.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (suffixText != null)
            Text(
              suffixText!,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
        ],
      );
    }

    // En modo edición: campo completo
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboard,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
            suffixText: suffixText,
            prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surfaceSoft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: SCHEDULE ROW
// ─────────────────────────────────────────────
class _ScheduleRow extends StatelessWidget {
  final BusinessDay day;
  final bool isEditing;
  final bool showDivider;
  final void Function(bool) onToggle;
  final VoidCallback onEditTime;

  const _ScheduleRow({
    required this.day,
    required this.isEditing,
    required this.showDivider,
    required this.onToggle,
    required this.onEditTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Día abreviado
              SizedBox(
                width: 36,
                child: Text(
                  day.day.substring(0, 3),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: day.isOpen ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Horario o "Cerrado"
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: day.isOpen
                        ? AppColors.primarySurface
                        : AppColors.surfaceSoft,
                    borderRadius: AppRadius.sm,
                    border: Border.all(
                      color: day.isOpen
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    day.isOpen
                        ? '${_formatTime(day.openTime)} – ${_formatTime(day.closeTime)}'
                        : 'Cerrado',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: day.isOpen
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Botón editar hora (solo en edición y si está abierto)
              if (isEditing && day.isOpen)
                GestureDetector(
                  onTap: onEditTime,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: AppRadius.sm,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                const SizedBox(width: 26),
              const SizedBox(width: 8),
              // Switch de apertura
              SizedBox(
                height: 28,
                child: Switch(
                  value: day.isOpen,
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: isEditing ? onToggle : null,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: BANNER SLOT
// ─────────────────────────────────────────────
class _BannerSlot extends StatelessWidget {
  final String url;
  final bool canDelete;
  final VoidCallback onDelete;

  const _BannerSlot({
    required this.url,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          url == '__mock__'
              ? const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.primaryLight,
                    size: 32,
                  ),
                )
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, prog) => prog == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textMuted,
                      size: 28,
                    ),
                  ),
                ),
          if (canDelete)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddBannerSlot extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBannerSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: AppColors.primaryLight.withOpacity(0.35),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 26,
              color: AppColors.primaryLight.withOpacity(0.72),
            ),
            const SizedBox(height: 4),
            Text(
              'Agregar',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primaryLight.withOpacity(0.72),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: METRIC CHIP
// ─────────────────────────────────────────────
class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: AppRadius.sm,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
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

/// Card de superficie reutilizable con sombra sutil
class _SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _SurfaceCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(_S.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Fila de ajuste individual
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool isDangerous;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.isDangerous = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDangerous ? AppColors.error : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDangerous
                      ? AppColors.error.withOpacity(0.08)
                      : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDangerous ? AppColors.error : AppColors.textSec,
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDangerous
                        ? AppColors.error.withOpacity(0.5)
                        : AppColors.textMuted,
                    size: 18,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
