// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS — consistentes con el resto del sistema
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const primary = Color(0xFF05386B);
//   static const accent = Color(0xFFFF6B00);
//   static const bg = Color(0xFFF9FAFB);
//   static const surface = Colors.white;
//   static const textSec = Color(0xFF2C3E50);
//   static const textMuted = Color(0xFF7F8C8D);
//   static const divider = Color(0xFFECF0F1);
//   static const inputBorder = Color(0xFFDDE1E7);
//   static const error = Color(0xFFE74C3C);
//   static const primarySoft = Color(0xFFE8EFF7);
//   static const accentSoft = Color(0xFFFFF3EC);
//   static const success = Color(0xFF27AE60);
//   static const successBg = Color(0xFFEAF6EE);
//   // static const warningBg = Color(0xFFFEF9EC);
// }

// class _R {
//   static const card = 16.0;
//   static const input = 12.0;
//   static const button = 12.0;
//   static const badge = 8.0;
// }

// class _S {
//   static const xs = 4.0;
//   static const sm = 8.0;
//   static const md = 16.0;
//   static const lg = 24.0;
//   // static const xl = 32.0;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class CreatePromotionScreen extends StatefulWidget {
//   const CreatePromotionScreen({super.key});

//   @override
//   State<CreatePromotionScreen> createState() => _CreatePromotionScreenState();
// }

// class _CreatePromotionScreenState extends State<CreatePromotionScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();

//   final _titleCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _codeCtrl = TextEditingController();
//   final _discountCtrl = TextEditingController();
//   final _minOrderCtrl = TextEditingController();
//   final _usageLimitCtrl = TextEditingController();

//   String _type = 'Descuento Porcentual';
//   String _target = 'Todos';
//   String? _selectedCategory;
//   String? _selectedProduct;
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 7));

//   bool _active = true;
//   bool _featured = false;
//   bool _codeRequired = false;
//   bool _hasDiscount = true;
//   bool _isCreating = false;

//   List<String> _images = [];

//   final _types = [
//     'Descuento Porcentual',
//     'Descuento Fijo',
//     '2x1',
//     'Envío Gratis',
//     'Combo',
//   ];
//   final _targets = ['Todos', 'Categoría', 'Producto', 'Pedido Mínimo'];
//   final _categories = ['Comida', 'Bebidas', 'Postres'];
//   final _products = ['Pizza', 'Hamburguesa', 'Ensalada'];

//   late AnimationController _animCtrl;
//   late Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
//     _animCtrl.forward();

//     _images = List.filled(
//       2,
//       'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
//     );

//     _discountCtrl.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     _titleCtrl.dispose();
//     _descCtrl.dispose();
//     _codeCtrl.dispose();
//     _discountCtrl.dispose();
//     _minOrderCtrl.dispose();
//     _usageLimitCtrl.dispose();
//     super.dispose();
//   }

//   // ── Lógica de negocio (sin cambios) ──────────────────────────────────────

//   Future<void> _onCreate() async {
//     if (_formKey.currentState!.validate() && _images.isNotEmpty) {
//       setState(() => _isCreating = true);
//       await Future.delayed(const Duration(milliseconds: 700));
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//               SizedBox(width: _S.sm),
//               Text('¡Promoción creada exitosamente!'),
//             ],
//           ),
//           backgroundColor: _C.success,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(_R.badge),
//           ),
//           margin: const EdgeInsets.all(_S.md),
//         ),
//       );
//       Navigator.pop(context);
//     } else if (_images.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Agrega al menos una imagen'),
//           backgroundColor: _C.error,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(_R.badge),
//           ),
//           margin: const EdgeInsets.all(_S.md),
//         ),
//       );
//     }
//   }

//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? _startDate : _endDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(
//             primary: _C.primary,
//             onPrimary: Colors.white,
//             surface: _C.surface,
//           ),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       setState(() => isStart ? _startDate = picked : _endDate = picked);
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 768;
//     final bottomPadding = MediaQuery.of(context).padding.bottom;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       appBar: AppBar(
//         backgroundColor: _C.bg,
//         foregroundColor: _C.primary,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         centerTitle: false,
//         title: const Text(
//           'Nueva promoción',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             color: _C.primary,
//             letterSpacing: -0.3,
//           ),
//         ),
//         actions: [
//           // Vista previa — acción secundaria en AppBar
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: _C.primary,
//                 side: const BorderSide(color: _C.inputBorder, width: 0.5),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(_R.badge),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 minimumSize: Size.zero,
//               ),
//               child: const Text(
//                 'Vista previa',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnim,
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//               isWide ? 48 : _S.md,
//               _S.sm,
//               isWide ? 48 : _S.md,
//               120 + bottomPadding,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildImages(),
//                 const SizedBox(height: _S.lg),
//                 _buildBasicInfo(),
//                 const SizedBox(height: _S.md),
//                 _buildPromotionConfig(),
//                 const SizedBox(height: _S.md),
//                 _buildValidity(isWide),
//                 const SizedBox(height: _S.md),
//                 _buildOptions(),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // CTA fijo al pie — reemplaza el FAB flotante
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(
//           _S.md,
//           _S.sm,
//           _S.md,
//           _S.md + bottomPadding,
//         ),
//         decoration: const BoxDecoration(
//           color: _C.surface,
//           border: Border(top: BorderSide(color: _C.divider, width: 0.5)),
//         ),
//         child: SizedBox(
//           height: 52,
//           child: ElevatedButton(
//             onPressed: _isCreating ? null : _onCreate,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _C.accent,
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: _C.accent.withOpacity(0.65),
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(_R.button),
//               ),
//             ),
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),
//               child: _isCreating
//                   ? const SizedBox(
//                       key: ValueKey('loading'),
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2.5,
//                       ),
//                     )
//                   : const Row(
//                       key: ValueKey('label'),
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.local_offer_rounded, size: 18),
//                         SizedBox(width: _S.sm),
//                         Text(
//                           'Publicar promoción',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Sección de imágenes ───────────────────────────────────────────────────

//   Widget _buildImages() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           title: 'Imágenes de la promoción',
//           badge: _images.isEmpty ? null : '${_images.length}',
//           badgeColor: _images.isEmpty ? null : _C.accent,
//         ),
//         const SizedBox(height: _S.sm),

//         // Indicador de requerimiento
//         if (_images.isEmpty)
//           Container(
//             margin: const EdgeInsets.only(bottom: _S.sm),
//             padding: const EdgeInsets.symmetric(
//               horizontal: _S.md,
//               vertical: _S.sm,
//             ),
//             decoration: BoxDecoration(
//               color: _C.error.withOpacity(0.07),
//               borderRadius: BorderRadius.circular(_R.badge),
//               border: Border.all(color: _C.error.withOpacity(0.25), width: 0.5),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.info_outline_rounded, size: 14, color: _C.error),
//                 SizedBox(width: _S.sm),
//                 Text(
//                   'Agrega al menos 1 imagen para continuar',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: _C.error,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         SizedBox(
//           height: 140,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             clipBehavior: Clip.none,
//             children: [
//               // Imágenes existentes
//               ..._images.asMap().entries.map((entry) {
//                 final url = entry.value;
//                 return _ImageTile(
//                   url: url,
//                   onRemove: () => setState(() => _images.remove(url)),
//                 );
//               }),

//               // Botón de agregar
//               GestureDetector(
//                 onTap: () => setState(
//                   () => _images.add(
//                     'https://ilacad.com/BO/data/logos_cadenas/logo_la_colonia_honduras.jpg',
//                   ),
//                 ),
//                 child: Container(
//                   width: 120,
//                   height: 140,
//                   margin: const EdgeInsets.only(right: _S.sm),
//                   decoration: BoxDecoration(
//                     color: _C.primarySoft,
//                     borderRadius: BorderRadius.circular(_R.card),
//                     border: Border.all(
//                       color: _C.primary.withOpacity(0.25),
//                       width: 1,
//                     ),
//                   ),
//                   child: const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.add_photo_alternate_outlined,
//                         size: 28,
//                         color: _C.primary,
//                       ),
//                       SizedBox(height: _S.xs),
//                       Text(
//                         'Agregar',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: _C.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Información básica ────────────────────────────────────────────────────

//   Widget _buildBasicInfo() {
//     return _SectionCard(
//       title: 'Información básica',
//       icon: Icons.edit_note_rounded,
//       children: [
//         _PromoField(
//           controller: _titleCtrl,
//           label: 'Título de la promoción',
//           icon: Icons.label_outline_rounded,
//           textInputAction: TextInputAction.next,
//           validator: (v) =>
//               v?.isEmpty ?? true ? 'El título es requerido' : null,
//         ),
//         const _FieldDivider(),
//         _PromoField(
//           controller: _descCtrl,
//           label: 'Descripción',
//           icon: Icons.description_outlined,
//           maxLines: 3,
//           isOptional: true,
//           textInputAction: TextInputAction.next,
//         ),
//         const _FieldDivider(),
//         _PromoDropdown(
//           label: 'Tipo de promoción',
//           icon: Icons.category_outlined,
//           value: _type,
//           items: _types,
//           onChanged: (v) => setState(() => _type = v!),
//         ),
//       ],
//     );
//   }

//   // ── Configuración de la promoción ─────────────────────────────────────────

//   Widget _buildPromotionConfig() {
//     return _SectionCard(
//       title: 'Configuración del descuento',
//       icon: Icons.percent_rounded,
//       children: [
//         _PromoDropdown(
//           label: 'Aplicar a',
//           icon: Icons.track_changes_outlined,
//           value: _target,
//           items: _targets,
//           onChanged: (v) => setState(() => _target = v!),
//         ),

//         // Campos condicionales por target
//         if (_target == 'Categoría') ...[
//           const _FieldDivider(),
//           _PromoDropdown(
//             label: 'Categoría',
//             icon: Icons.folder_outlined,
//             value: _selectedCategory,
//             items: _categories,
//             onChanged: (v) => setState(() => _selectedCategory = v),
//           ),
//         ],
//         if (_target == 'Producto') ...[
//           const _FieldDivider(),
//           _PromoDropdown(
//             label: 'Producto',
//             icon: Icons.inventory_2_outlined,
//             value: _selectedProduct,
//             items: _products,
//             onChanged: (v) => setState(() => _selectedProduct = v),
//           ),
//         ],

//         const _FieldDivider(),

//         // Toggle de descuento con descripción
//         _OptionRow(
//           icon: Icons.discount_outlined,
//           label: 'Aplicar descuento',
//           description: 'Define un valor de reducción para esta promoción',
//           value: _hasDiscount,
//           activeColor: _C.accent,
//           onChanged: (v) => setState(() => _hasDiscount = v),
//         ),

//         // Campo de descuento — con AnimatedSize para transición suave
//         AnimatedSize(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: _hasDiscount
//               ? Column(
//                   children: [
//                     const _FieldDivider(),
//                     _PromoField(
//                       controller: _discountCtrl,
//                       label: _type.contains('Porcentual')
//                           ? 'Porcentaje de descuento'
//                           : 'Monto de descuento',
//                       icon: _type.contains('Porcentual')
//                           ? Icons.percent_rounded
//                           : Icons.attach_money_rounded,
//                       keyboardType: TextInputType.number,
//                       prefix: _type.contains('Porcentual') ? null : 'L ',
//                       suffix: _type.contains('Porcentual') ? '%' : null,
//                       textInputAction: TextInputAction.next,
//                     ),
//                     // Preview del precio calculado
//                     if (_discountCtrl.text.isNotEmpty)
//                       _DiscountPreview(
//                         type: _type,
//                         value: double.tryParse(_discountCtrl.text) ?? 0,
//                       ),
//                   ],
//                 )
//               : const SizedBox.shrink(),
//         ),

//         const _FieldDivider(),

//         // Pedido mínimo
//         _PromoField(
//           controller: _minOrderCtrl,
//           label: 'Pedido mínimo (opcional)',
//           icon: Icons.shopping_bag_outlined,
//           keyboardType: TextInputType.number,
//           prefix: 'L ',
//           isOptional: true,
//           textInputAction: TextInputAction.next,
//         ),

//         const _FieldDivider(),

//         _PromoField(
//           controller: _usageLimitCtrl,
//           label: 'Límite de usos (opcional)',
//           icon: Icons.people_outline_rounded,
//           keyboardType: TextInputType.number,
//           isOptional: true,
//           textInputAction: TextInputAction.done,
//         ),
//       ],
//     );
//   }

//   // ── Vigencia ──────────────────────────────────────────────────────────────

//   Widget _buildValidity(bool isWide) {
//     final duration = _endDate.difference(_startDate).inDays;
//     final isValidRange = _endDate.isAfter(_startDate);

//     return _SectionCard(
//       title: 'Vigencia',
//       icon: Icons.calendar_month_outlined,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: _S.md,
//             vertical: _S.sm,
//           ),
//           child: isWide
//               ? Row(
//                   children: [
//                     Expanded(
//                       child: _DateButton(
//                         label: 'Fecha de inicio',
//                         date: _startDate,
//                         onTap: () => _selectDate(context, true),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: _S.md),
//                       child: Icon(
//                         Icons.arrow_forward_rounded,
//                         color: _C.textMuted,
//                         size: 18,
//                       ),
//                     ),
//                     Expanded(
//                       child: _DateButton(
//                         label: 'Fecha de fin',
//                         date: _endDate,
//                         onTap: () => _selectDate(context, false),
//                         isEnd: true,
//                       ),
//                     ),
//                   ],
//                 )
//               : Column(
//                   children: [
//                     _DateButton(
//                       label: 'Fecha de inicio',
//                       date: _startDate,
//                       onTap: () => _selectDate(context, true),
//                     ),
//                     const SizedBox(height: _S.sm),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 6),
//                         child: Icon(
//                           Icons.arrow_downward_rounded,
//                           color: _C.textMuted,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: _S.sm),
//                     _DateButton(
//                       label: 'Fecha de fin',
//                       date: _endDate,
//                       onTap: () => _selectDate(context, false),
//                       isEnd: true,
//                     ),
//                   ],
//                 ),
//         ),

//         // Resumen de duración
//         Padding(
//           padding: const EdgeInsets.fromLTRB(_S.md, 0, _S.md, _S.md),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             padding: const EdgeInsets.symmetric(
//               horizontal: _S.md,
//               vertical: _S.sm,
//             ),
//             decoration: BoxDecoration(
//               color: isValidRange ? _C.successBg : _C.error.withOpacity(0.07),
//               borderRadius: BorderRadius.circular(_R.badge),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   isValidRange
//                       ? Icons.check_circle_outline_rounded
//                       : Icons.warning_amber_rounded,
//                   size: 14,
//                   color: isValidRange ? _C.success : _C.error,
//                 ),
//                 const SizedBox(width: _S.sm),
//                 Text(
//                   isValidRange
//                       ? 'Duración: $duration ${duration == 1 ? 'día' : 'días'}'
//                       : 'La fecha de fin debe ser posterior al inicio',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: isValidRange ? _C.success : _C.error,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Opciones adicionales ─────────────────────────────────────────────────

//   Widget _buildOptions() {
//     return _SectionCard(
//       title: 'Opciones adicionales',
//       icon: Icons.tune_rounded,
//       children: [
//         _OptionRow(
//           icon: Icons.toggle_on_outlined,
//           label: 'Activa',
//           description: 'Los clientes pueden ver y usar esta promoción',
//           value: _active,
//           activeColor: _C.success,
//           onChanged: (v) => setState(() => _active = v),
//         ),
//         const _FieldDivider(),
//         _OptionRow(
//           icon: Icons.star_outline_rounded,
//           label: 'Destacada',
//           description: 'Aparece primero en la lista de promociones',
//           value: _featured,
//           activeColor: _C.accent,
//           onChanged: (v) => setState(() => _featured = v),
//         ),
//         const _FieldDivider(),
//         _OptionRow(
//           icon: Icons.qr_code_rounded,
//           label: 'Requiere código',
//           description: 'El cliente debe ingresar un código para canjearla',
//           value: _codeRequired,
//           activeColor: _C.primary,
//           onChanged: (v) => setState(() => _codeRequired = v),
//         ),

//         // Campo de código — AnimatedSize para transición suave
//         AnimatedSize(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: _codeRequired
//               ? Column(
//                   children: [
//                     const _FieldDivider(),
//                     _PromoField(
//                       controller: _codeCtrl,
//                       label: 'Código de descuento',
//                       icon: Icons.vpn_key_outlined,
//                       textInputAction: TextInputAction.done,
//                       validator: _codeRequired
//                           ? (v) =>
//                                 v?.isEmpty ?? true ? 'Ingresa el código' : null
//                           : null,
//                     ),
//                     // Sugerencia de código
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(
//                         _S.md,
//                         0,
//                         _S.md,
//                         _S.sm,
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           final code = 'PROMO${DateTime.now().millisecond}';
//                           _codeCtrl.text = code;
//                           setState(() {});
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: _S.sm,
//                             vertical: _S.xs,
//                           ),
//                           decoration: BoxDecoration(
//                             color: _C.accentSoft,
//                             borderRadius: BorderRadius.circular(_R.badge),
//                           ),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.auto_fix_high_rounded,
//                                 size: 12,
//                                 color: _C.accent,
//                               ),
//                               SizedBox(width: _S.xs),
//                               Text(
//                                 'Generar código automático',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: _C.accent,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SUBCOMPONENTES
// // ─────────────────────────────────────────────────────────────────────────────

// /// Encabezado de sección con badge opcional
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final String? badge;
//   final Color? badgeColor;

//   const _SectionHeader({required this.title, this.badge, this.badgeColor});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//             color: _C.textSec,
//             letterSpacing: 0.1,
//           ),
//         ),
//         if (badge != null) ...[
//           const SizedBox(width: _S.sm),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//               color: (badgeColor ?? _C.primary).withOpacity(0.12),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               badge!,
//               style: TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//                 color: badgeColor ?? _C.primary,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

// /// Card contenedora de una sección del formulario
// class _SectionCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final List<Widget> children;

//   const _SectionCard({
//     required this.title,
//     required this.icon,
//     required this.children,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Label de sección
//         Padding(
//           padding: const EdgeInsets.only(left: 2, bottom: _S.sm),
//           child: Row(
//             children: [
//               Icon(icon, size: 13, color: _C.textMuted),
//               const SizedBox(width: _S.xs),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: _C.textMuted,
//                   letterSpacing: 0.1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Card blanca con sombra sutil
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: _C.surface,
//             borderRadius: BorderRadius.circular(_R.card),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: children,
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// Tile de imagen con botón de eliminar
// class _ImageTile extends StatelessWidget {
//   final String url;
//   final VoidCallback onRemove;

//   const _ImageTile({required this.url, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       height: 140,
//       margin: const EdgeInsets.only(right: _S.sm),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(_R.card),
//             child: Image.network(
//               url,
//               width: 140,
//               height: 140,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 color: _C.primarySoft,
//                 child: const Icon(
//                   Icons.broken_image_outlined,
//                   color: _C.primary,
//                 ),
//               ),
//             ),
//           ),
//           // Botón de eliminar
//           Positioned(
//             top: 6,
//             right: 6,
//             child: GestureDetector(
//               onTap: onRemove,
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.55),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.close_rounded,
//                   color: Colors.white,
//                   size: 14,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Campo de texto dentro de una SectionCard
// class _PromoField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final IconData icon;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final int maxLines;
//   final bool isOptional;
//   final String? prefix;
//   final String? suffix;
//   final String? Function(String?)? validator;

//   const _PromoField({
//     required this.controller,
//     required this.label,
//     required this.icon,
//     this.keyboardType,
//     this.textInputAction,
//     this.maxLines = 1,
//     this.isOptional = false,
//     this.prefix,
//     this.suffix,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 2),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         textInputAction: textInputAction,
//         maxLines: maxLines,
//         style: const TextStyle(
//           fontSize: 14,
//           color: _C.textSec,
//           fontWeight: FontWeight.w500,
//         ),
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
//           prefixIcon: Icon(icon, size: 17, color: _C.primary),
//           prefixText: prefix,
//           prefixStyle: const TextStyle(
//             fontSize: 14,
//             color: _C.textSec,
//             fontWeight: FontWeight.w500,
//           ),
//           suffixText: suffix,
//           suffixStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
//           suffixIcon: isOptional
//               ? Container(
//                   margin: const EdgeInsets.only(right: _S.sm),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 6,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _C.divider,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: const Text(
//                     'Opcional',
//                     style: TextStyle(fontSize: 10, color: _C.textMuted),
//                   ),
//                 )
//               : null,
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           errorBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: _C.error, width: 1),
//           ),
//           focusedErrorBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: _C.error, width: 1.5),
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 0,
//             vertical: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Dropdown dentro de SectionCard
// class _PromoDropdown extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final String? value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;

//   const _PromoDropdown({
//     required this.label,
//     required this.icon,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: 2),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         isExpanded: true,
//         icon: const Icon(
//           Icons.expand_more_rounded,
//           color: _C.primary,
//           size: 20,
//         ),
//         style: const TextStyle(
//           fontSize: 14,
//           color: _C.textSec,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
//           prefixIcon: Icon(icon, size: 17, color: _C.primary),
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 0,
//             vertical: 12,
//           ),
//         ),
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }

// /// Fila de opción toggle con descripción semántica
// class _OptionRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String description;
//   final bool value;
//   final Color activeColor;
//   final ValueChanged<bool> onChanged;

//   const _OptionRow({
//     required this.icon,
//     required this.label,
//     required this.description,
//     required this.value,
//     required this.activeColor,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: _S.sm),
//       child: Row(
//         children: [
//           // Ícono en contenedor con color del estado
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: value
//                   ? activeColor.withOpacity(0.1)
//                   : _C.divider.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(_R.badge),
//             ),
//             child: Icon(
//               icon,
//               size: 17,
//               color: value ? activeColor : _C.textMuted,
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Label + descripción
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: _C.textSec,
//                   ),
//                 ),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: _C.textMuted,
//                     height: 1.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: activeColor,
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Botón de selección de fecha — reemplaza el InkWell con Container genérico
// class _DateButton extends StatelessWidget {
//   final String label;
//   final DateTime date;
//   final VoidCallback onTap;
//   final bool isEnd;

//   const _DateButton({
//     required this.label,
//     required this.date,
//     required this.onTap,
//     this.isEnd = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: _C.primarySoft,
//           borderRadius: BorderRadius.circular(_R.input),
//           border: Border.all(color: _C.primary.withOpacity(0.2), width: 0.5),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               isEnd ? Icons.event_available_outlined : Icons.today_outlined,
//               size: 16,
//               color: _C.primary,
//             ),
//             const SizedBox(width: _S.sm),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(fontSize: 11, color: _C.textMuted),
//                   ),
//                   Text(
//                     DateFormat('dd MMM yyyy').format(date),
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: _C.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.edit_calendar_outlined,
//               size: 14,
//               color: _C.textMuted,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Preview calculado del descuento
// class _DiscountPreview extends StatelessWidget {
//   final String type;
//   final double value;

//   const _DiscountPreview({required this.type, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     final isPercent = type.contains('Porcentual');
//     final label = isPercent
//         ? 'Ahorro del ${value.toStringAsFixed(0)}% sobre el precio original'
//         : 'Descuento fijo de L ${value.toStringAsFixed(2)} por pedido';

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(_S.md, _S.xs, _S.md, _S.sm),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: _S.md, vertical: _S.sm),
//         decoration: BoxDecoration(
//           color: _C.successBg,
//           borderRadius: BorderRadius.circular(_R.badge),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.savings_outlined, size: 14, color: _C.success),
//             const SizedBox(width: _S.sm),
//             Expanded(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: _C.success,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Separador entre campos del mismo grupo
// class _FieldDivider extends StatelessWidget {
//   const _FieldDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 50),
//       height: 0.5,
//       color: _C.divider,
//     );
//   }
// }
