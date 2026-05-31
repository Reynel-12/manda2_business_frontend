import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
}

class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(10));
  static const md = BorderRadius.all(Radius.circular(14));
  static const lg = BorderRadius.all(Radius.circular(18));
  static const xl = BorderRadius.all(Radius.circular(24));
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
//  CONSTANTES DE FORMULARIO
// ─────────────────────────────────────────────
const int _maxImages = 5;

// ─────────────────────────────────────────────
//  PANTALLA PRINCIPAL
// ─────────────────────────────────────────────
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers — todos declarados y gestionados aquí
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _finalPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _discountController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;
  bool _isAvailable = true;
  bool _isFeatured = false;
  bool _hasDiscount = false;
  bool _isSaving = false;

  List<String> _images = [];

  static const _categories = [
    'Lácteos',
    'Panadería',
    'Bebidas',
    'Enlatados',
    'Snacks',
    'Limpieza',
    'Carnes',
    'Otros',
  ];
  static const _units = ['Unidad', 'kg', 'g', 'L', 'mL', 'Paquete', 'Docena'];

  // Íconos por categoría para el selector
  static const Map<String, IconData> _categoryIcons = {
    'Lácteos': Icons.egg_outlined,
    'Panadería': Icons.bakery_dining_outlined,
    'Bebidas': Icons.local_drink_outlined,
    'Enlatados': Icons.kitchen_outlined,
    'Snacks': Icons.cookie_outlined,
    'Limpieza': Icons.cleaning_services_outlined,
    'Carnes': Icons.set_meal_outlined,
    'Otros': Icons.category_outlined,
  };

  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Mock images — placeholder local sin URL externa
    _images = ['__mock__', '__mock__', '__mock__'];

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    _entryController.forward();

    // Recalcular precio final cuando cambia precio base o descuento
    _priceController.addListener(_calculateDiscount);
    _discountController.addListener(_calculateDiscount);
  }

  @override
  void dispose() {
    _entryController.dispose();
    // Todos los controllers liberados
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _finalPriceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  LÓGICA
  // ─────────────────────────────────────────────
  void _calculateDiscount() {
    if (!_hasDiscount) return;
    final base = double.tryParse(_priceController.text) ?? 0;
    final percent = double.tryParse(_discountController.text) ?? 0;
    if (base > 0) {
      final final_ = base * (1 - percent / 100);
      _finalPriceController.text = final_.toStringAsFixed(2);
    } else {
      _finalPriceController.clear();
    }
  }

  Future<void> _onSubmit() async {
    // Cerrar teclado
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_images.isEmpty) {
      _showError('Agrega al menos una imagen del producto');
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              '${_nameController.text.isNotEmpty ? _nameController.text : "Producto"} guardado',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
    Navigator.pop(context);
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
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
    final isWide = size.width > 600;
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
                18,
                isDesktop
                    ? 56
                    : isWide
                    ? 32
                    : 16,
                112,
              ),
              children: [
                // Sección 1: Imágenes
                _SectionCard(
                  title: 'Imágenes del producto',
                  icon: Icons.photo_library_outlined,
                  badge: '${_images.length}/$_maxImages',
                  badgeColor: _images.isEmpty
                      ? AppColors.error
                      : AppColors.success,
                  child: _buildImageGallery(),
                ),

                const SizedBox(height: 16),

                // Sección 2: Info básica + precios en 1 o 2 col
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoSection()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPricingSection()),
                    ],
                  )
                else ...[
                  _buildInfoSection(),
                  const SizedBox(height: 16),
                  _buildPricingSection(),
                ],

                const SizedBox(height: 16),

                // Sección 3: Opciones
                _buildOptionsSection(),
              ],
            ),
          ),
        ),
      ),
      // CTA fijo en bottom — nunca tapa contenido
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: AppRadius.sm,
            border: Border.all(color: AppColors.divider),
          ),
          child: const Icon(Icons.arrow_back, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nuevo producto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'Completa la información',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.divider),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  GALERÍA DE IMÁGENES
  // ─────────────────────────────────────────────
  Widget _buildImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._images.asMap().entries.map((e) {
                final isFirst = e.key == 0;
                return _ImageSlot(
                  index: e.key,
                  url: e.value,
                  isPrimary: isFirst,
                  onRemove: () {
                    HapticFeedback.selectionClick();
                    setState(() => _images.removeAt(e.key));
                  },
                );
              }),
              if (_images.length < _maxImages)
                _AddImageSlot(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _images.add('__mock__'));
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 12,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              'La primera imagen será la principal · Máx. $_maxImages fotos',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  SECCIÓN INFO BÁSICA
  // ─────────────────────────────────────────────
  Widget _buildInfoSection() {
    return _SectionCard(
      title: 'Información básica',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _AppField(
            controller: _nameController,
            label: 'Nombre del producto',
            hint: 'Ej: Leche Entera 1L',
            icon: Icons.label_outline,
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'El nombre es requerido' : null,
          ),
          const SizedBox(height: 14),
          _AppField(
            controller: _descriptionController,
            label: 'Descripción',
            hint: 'Describe características, contenido, presentación...',
            icon: Icons.notes_outlined,
            maxLines: 3,
            validator: (v) =>
                (v ?? '').trim().length < 10 ? 'Mínimo 10 caracteres' : null,
          ),
          const SizedBox(height: 14),
          _AppDropdown<String>(
            label: 'Categoría',
            hint: 'Selecciona una categoría',
            value: _selectedCategory,
            icon: Icons.category_outlined,
            items: _categories,
            itemLabel: (e) => e,
            itemIcon: (e) => _categoryIcons[e],
            onChanged: (v) => setState(() => _selectedCategory = v),
            validator: (v) => v == null ? 'Selecciona una categoría' : null,
          ),
          const SizedBox(height: 14),
          _AppDropdown<String>(
            label: 'Unidad de medida',
            hint: 'Selecciona unidad',
            value: _selectedUnit,
            icon: Icons.straighten_outlined,
            items: _units,
            itemLabel: (e) => e,
            onChanged: (v) => setState(() => _selectedUnit = v),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SECCIÓN PRECIO E INVENTARIO
  // ─────────────────────────────────────────────
  Widget _buildPricingSection() {
    return _SectionCard(
      title: 'Precio e inventario',
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          _AppField(
            controller: _priceController,
            label: 'Precio base',
            hint: '0.00',
            icon: Icons.attach_money,
            prefixText: '\$ ',
            keyboard: TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              final n = double.tryParse(v ?? '');
              return (n == null || n <= 0)
                  ? 'Ingresa un precio mayor a 0'
                  : null;
            },
          ),
          const SizedBox(height: 14),
          _AppField(
            controller: _stockController,
            label: 'Stock disponible',
            hint: '0',
            icon: Icons.inventory_2_outlined,
            keyboard: TextInputType.number,
            validator: (v) {
              final n = int.tryParse(v ?? '');
              return (n == null || n < 0)
                  ? 'Ingresa un stock válido (≥ 0)'
                  : null;
            },
          ),
          const SizedBox(height: 16),
          // Toggle de descuento
          _buildDiscountCard(),
        ],
      ),
    );
  }

  Widget _buildDiscountCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _hasDiscount ? AppColors.accentSurface : AppColors.background,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: _hasDiscount
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.divider,
          width: _hasDiscount ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: AppRadius.md,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _hasDiscount = !_hasDiscount;
                if (!_hasDiscount) {
                  _discountController.clear();
                  _finalPriceController.clear();
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: _hasDiscount
                          ? AppColors.accent.withOpacity(0.15)
                          : AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 16,
                      color: _hasDiscount
                          ? AppColors.accent
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aplicar descuento',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _hasDiscount
                                ? AppColors.accent
                                : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _hasDiscount ? 'Activo' : 'Sin descuento',
                          style: TextStyle(
                            fontSize: 11,
                            color: _hasDiscount
                                ? AppColors.accent
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _hasDiscount,
                    activeColor: AppColors.accent,
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _hasDiscount = v;
                        if (!v) {
                          _discountController.clear();
                          _finalPriceController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Campos de descuento — animados
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _hasDiscount
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  const Divider(color: AppColors.divider, height: 16),
                  _AppField(
                    controller: _discountController,
                    label: 'Porcentaje de descuento',
                    hint: '10',
                    icon: Icons.percent,
                    suffixText: '%',
                    keyboard: TextInputType.numberWithOptions(decimal: true),
                    validator: _hasDiscount
                        ? (v) {
                            final n = double.tryParse(v ?? '');
                            if (n == null || n < 0 || n > 100) {
                              return 'Ingresa un porcentaje entre 0 y 100';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 12),
                  // Precio final calculado — campo de solo lectura
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.sm,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sell_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Precio final',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Spacer(),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _priceController,
                            _discountController,
                          ]),
                          builder: (_, __) {
                            final base =
                                double.tryParse(_priceController.text) ?? 0;
                            final pct =
                                double.tryParse(_discountController.text) ?? 0;
                            final f = base * (1 - pct / 100);
                            return Text(
                              '\$${f.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: f > 0
                                    ? AppColors.accent
                                    : AppColors.textMuted,
                                letterSpacing: -0.4,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SECCIÓN OPCIONES
  // ─────────────────────────────────────────────
  Widget _buildOptionsSection() {
    return _SectionCard(
      title: 'Visibilidad',
      icon: Icons.visibility_outlined,
      child: Column(
        children: [
          _ToggleTile(
            icon: Icons.storefront_outlined,
            iconColor: AppColors.primary,
            title: 'Disponible para venta',
            subtitle: _isAvailable
                ? 'Los clientes pueden comprarlo'
                : 'Producto oculto en la tienda',
            value: _isAvailable,
            activeColor: AppColors.primary,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _isAvailable = v);
            },
          ),
          const SizedBox(height: 8),
          _ToggleTile(
            icon: Icons.star_outline_rounded,
            iconColor: AppColors.accent,
            title: 'Destacar en tienda',
            subtitle: _isFeatured
                ? 'Aparece en sección destacados'
                : 'Producto estándar',
            value: _isFeatured,
            activeColor: AppColors.accent,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _isFeatured = v);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BOTTOM CTA (fijo, nunca tapa campos)
  // ─────────────────────────────────────────────
  Widget _buildBottomCTA() {
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
          // Botón cancelar — acción secundaria
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              side: const BorderSide(color: AppColors.divider),
              minimumSize: const Size(80, 52),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
            ),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 12),
          // Botón guardar — acción primaria
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _onSubmit,
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
                            'Guardar producto',
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
}

// ─────────────────────────────────────────────
//  WIDGET: SECTION CARD
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final String? badge;
  final Color? badgeColor;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.badge,
    this.badgeColor,
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
          // Header de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
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
                      color: (badgeColor ?? AppColors.textMuted).withOpacity(
                        0.1,
                      ),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor ?? AppColors.textMuted,
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
//  WIDGET: CAMPO DE TEXTO UNIFICADO
// ─────────────────────────────────────────────
class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboard;
  final String? prefixText;
  final String? suffixText;
  final String? Function(String?)? validator;

  const _AppField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboard,
    this.prefixText,
    this.suffixText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
          controller: controller,
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
              fontWeight: FontWeight.w400,
            ),
            prefixText: prefixText,
            suffixText: suffixText,
            prefixStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
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
//  WIDGET: DROPDOWN UNIFICADO
// ─────────────────────────────────────────────
class _AppDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final IconData icon;
  final List<T> items;
  final String Function(T) itemLabel;
  final IconData? Function(T)? itemIcon;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const _AppDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.itemIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          icon: const Icon(
            Icons.expand_more,
            color: AppColors.textMuted,
            size: 20,
          ),
          decoration: InputDecoration(
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
            errorStyle: const TextStyle(fontSize: 11, color: AppColors.error),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Row(
                    children: [
                      if (itemIcon != null && itemIcon!(e) != null) ...[
                        Icon(itemIcon!(e), size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        itemLabel(e),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: TOGGLE TILE
// ─────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final Color activeColor;
  final void Function(bool) onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: value ? activeColor.withOpacity(0.05) : AppColors.surfaceSoft,
        borderRadius: AppRadius.md,
        border: Border.all(
          color: value ? activeColor.withOpacity(0.25) : AppColors.divider,
          width: value ? 1.5 : 1,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        secondary: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: value ? iconColor.withOpacity(0.1) : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: value ? iconColor : AppColors.textMuted,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: value ? iconColor : AppColors.textSecondary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        value: value,
        activeColor: activeColor,
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET: IMAGE SLOT (con imagen)
// ─────────────────────────────────────────────
class _ImageSlot extends StatelessWidget {
  final int index;
  final String url;
  final bool isPrimary;
  final VoidCallback onRemove;

  const _ImageSlot({
    required this.index,
    required this.url,
    required this.isPrimary,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          // Imagen / placeholder
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isPrimary
                    ? AppColors.accent.withOpacity(0.5)
                    : AppColors.divider,
                width: isPrimary ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: url == '__mock__'
                ? const Icon(
                    Icons.image_outlined,
                    color: AppColors.primaryLight,
                    size: 32,
                  )
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textMuted,
                      size: 28,
                    ),
                  ),
          ),
          // Badge "Principal"
          if (isPrimary)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: AppRadius.sm,
                ),
                child: const Text(
                  'Principal',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          // Botón eliminar
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
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

// ─────────────────────────────────────────────
//  WIDGET: ADD IMAGE SLOT
// ─────────────────────────────────────────────
class _AddImageSlot extends StatefulWidget {
  final VoidCallback onTap;
  const _AddImageSlot({required this.onTap});

  @override
  State<_AddImageSlot> createState() => _AddImageSlotState();
}

class _AddImageSlotState extends State<_AddImageSlot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 90,
          height: 90,
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
                size: 28,
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
      ),
    );
  }
}
