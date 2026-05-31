import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manda2_business_frontend/view/business/business_add_product.dart';

// ─────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────
class _C {
  static const primary = Color(0xFF0F2B46);
  static const primaryLight = Color(0xFF2C5B82);
  static const accent = Color(0xFFE96A2C);
  static const accentSoft = Color(0xFFFFF2EA);
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const surfaceSoft = Color(0xFFF9FBFD);
  static const textPrimary = Color(0xFF132238);
  static const textSecondary = Color(0xFF40546A);
  static const textHint = Color(0xFF8695A5);
  static const divider = Color(0xFFE7EDF2);
  static const error = Color(0xFFE74C3C);
  static const success = Color(0xFF1E8E5A);
  static const warning = Color(0xFFF59E0B);
  static const starColor = Color(0xFFFFA726);
}

class _R {
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 24.0;
}

// ─────────────────────────────────────────────
// Categorías por defecto (no eliminables)
// ─────────────────────────────────────────────
const List<String> _kDefaultCategories = [
  'Todos',
  'Lácteos',
  'Panadería',
  'Bebidas',
  'Enlatados',
  'Snacks',
  'Limpieza',
  'Carnes',
];

// ─────────────────────────────────────────────
// BusinessProductsScreen
// ─────────────────────────────────────────────
class BusinessProductsScreen extends StatefulWidget {
  final bool isTab;
  const BusinessProductsScreen({Key? key, this.isTab = false})
    : super(key: key);

  @override
  State<BusinessProductsScreen> createState() => _BusinessProductsScreenState();
}

class _BusinessProductsScreenState extends State<BusinessProductsScreen>
    with SingleTickerProviderStateMixin {
  List<BusinessProduct> _products = [];

  // Categorías: las primeras 8 son por defecto, el resto son custom
  final List<String> _categories = List.from(_kDefaultCategories);
  final List<String> _customCategories = [];

  String _selectedCategory = 'Todos';
  String _selectedAvailability = 'Todos';
  String _searchQuery = '';
  String _sortBy = 'Nombre';
  bool _filtersExpanded = false;

  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;

  final _searchController = TextEditingController();

  final List<String> _availabilityFilters = ['Todos', 'Disponible', 'Agotado'];
  final List<String> _sortOptions = ['Nombre', 'Ventas', 'Rating', 'Stock'];

  // ── Lifecycle ───────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadProducts();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  // ── Data ────────────────────────────────────
  void _loadProducts() {
    _products = [
      BusinessProduct(
        id: '1',
        name: 'Leche Entera 1L',
        description: 'Leche fresca pasteurizada',
        price: 2.50,
        originalPrice: 2.80,
        category: 'Lácteos',
        unit: 'litro',
        stock: 20,
        isAvailable: true,
        images: [],
        rating: 4.5,
        salesCount: 342,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '2',
        name: 'Pan Integral Fresco',
        description: 'Pan integral recién horneado',
        price: 1.75,
        category: 'Panadería',
        unit: 'bolsa',
        stock: 15,
        isAvailable: true,
        images: [],
        rating: 4.2,
        salesCount: 215,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '3',
        name: 'Huevos Blancos x12',
        description: 'Huevos frescos grado A',
        price: 3.20,
        category: 'Lácteos',
        unit: 'docena',
        stock: 8,
        isAvailable: true,
        images: [],
        rating: 4.7,
        salesCount: 189,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '4',
        name: 'Jugo de Naranja 100%',
        description: 'Jugo natural sin conservantes',
        price: 3.50,
        originalPrice: 3.90,
        category: 'Bebidas',
        unit: 'caja',
        stock: 0,
        isAvailable: false,
        images: [],
        rating: 4.4,
        salesCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '5',
        name: 'Galletas de Chocolate',
        description: 'Galletas con chispas de chocolate',
        price: 2.20,
        category: 'Snacks',
        unit: 'paquete',
        stock: 30,
        isAvailable: true,
        images: [],
        rating: 4.6,
        salesCount: 278,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        isFeatured: true,
      ),
      BusinessProduct(
        id: '6',
        name: 'Arroz Integral 5kg',
        description: 'Arroz integral de grano largo',
        price: 7.50,
        originalPrice: 8.90,
        category: 'Enlatados',
        unit: 'bolsa',
        stock: 12,
        isAvailable: true,
        images: [],
        rating: 4.3,
        salesCount: 94,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '7',
        name: 'Detergente Líquido 2L',
        description: 'Detergente para ropa concentrado',
        price: 6.80,
        category: 'Limpieza',
        unit: 'botella',
        stock: 10,
        isAvailable: true,
        images: [],
        rating: 4.5,
        salesCount: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        isFeatured: false,
      ),
      BusinessProduct(
        id: '8',
        name: 'Pechuga de Pollo 1kg',
        description: 'Pechuga de pollo fresca',
        price: 7.90,
        category: 'Carnes',
        unit: 'kg',
        stock: 4,
        isAvailable: true,
        images: [],
        rating: 4.7,
        salesCount: 123,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        isFeatured: true,
      ),
    ];
  }

  // ── Filtros y sort ──────────────────────────
  List<BusinessProduct> get _filteredProducts {
    var list = _products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchCat =
          _selectedCategory == 'Todos' || p.category == _selectedCategory;
      final matchAvail =
          _selectedAvailability == 'Todos' ||
          (_selectedAvailability == 'Disponible'
              ? p.isAvailable
              : !p.isAvailable);
      return matchSearch && matchCat && matchAvail;
    }).toList();

    list.sort((a, b) {
      switch (_sortBy) {
        case 'Ventas':
          return b.salesCount.compareTo(a.salesCount);
        case 'Rating':
          return b.rating.compareTo(a.rating);
        case 'Stock':
          return b.stock.compareTo(a.stock);
        default:
          return a.name.compareTo(b.name);
      }
    });
    return list;
  }

  bool get _hasActiveFilters =>
      _selectedCategory != 'Todos' ||
      _selectedAvailability != 'Todos' ||
      _sortBy != 'Nombre';

  int get _activeFilterCount {
    int c = 0;
    if (_selectedCategory != 'Todos') c++;
    if (_selectedAvailability != 'Todos') c++;
    if (_sortBy != 'Nombre') c++;
    return c;
  }

  // ── Category management ─────────────────────

  /// Muestra el bottom sheet para agregar una nueva categoría
  void _showAddCategorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCategorySheet(
        existingCategories: _categories,
        onAdd: (newCategory) {
          setState(() {
            _categories.add(newCategory);
            _customCategories.add(newCategory);
            _selectedCategory = newCategory; // selecciona la nueva
          });
          HapticFeedback.lightImpact();
          _showFloatingSnack('Categoría "$newCategory" creada ✓');
        },
      ),
    );
  }

  /// Long-press en categoría custom → opción de eliminar
  void _showCategoryOptions(String category) {
    // No se puede eliminar "Todos" ni categorías por defecto
    if (_kDefaultCategories.contains(category)) return;

    final productsInCategory = _products
        .where((p) => p.category == category)
        .length;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryOptionsSheet(
        categoryName: category,
        productsCount: productsInCategory,
        onRename: () {
          Navigator.pop(context);
          _showRenameCategorySheet(category);
        },
        onDelete: () {
          Navigator.pop(context);
          _confirmDeleteCategory(category, productsInCategory);
        },
      ),
    );
  }

  void _showRenameCategorySheet(String oldName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCategorySheet(
        existingCategories: _categories,
        initialValue: oldName,
        isRename: true,
        onAdd: (newName) {
          setState(() {
            final idx = _categories.indexOf(oldName);
            if (idx != -1) _categories[idx] = newName;
            final cidx = _customCategories.indexOf(oldName);
            if (cidx != -1) _customCategories[cidx] = newName;
            // Renombrar en productos también
            for (int i = 0; i < _products.length; i++) {
              if (_products[i].category == oldName) {
                _products[i] = _products[i].copyWith(category: newName);
              }
            }
            if (_selectedCategory == oldName) _selectedCategory = newName;
          });
          HapticFeedback.lightImpact();
          _showFloatingSnack('Categoría renombrada a "$newName"');
        },
      ),
    );
  }

  void _confirmDeleteCategory(String category, int productsCount) {
    showDialog(
      context: context,
      builder: (_) => _DeleteCategoryDialog(
        categoryName: category,
        productsCount: productsCount,
        onConfirm: () {
          setState(() {
            _categories.remove(category);
            _customCategories.remove(category);
            if (_selectedCategory == category) _selectedCategory = 'Todos';
          });
          HapticFeedback.mediumImpact();
          _showFloatingSnack('"$category" eliminada', isError: true);
        },
      ),
    );
  }

  // ── Business logic ──────────────────────────
  void _toggleProductAvailability(String id) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1) {
      setState(() {
        _products[i] = _products[i].copyWith(
          isAvailable: !_products[i].isAvailable,
        );
      });
      HapticFeedback.lightImpact();
      _showFloatingSnack(
        _products[i].isAvailable
            ? '${_products[i].name} ahora disponible'
            : '${_products[i].name} marcado como agotado',
      );
    }
  }

  void _toggleFeatured(String id) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1) {
      setState(() {
        _products[i] = _products[i].copyWith(
          isFeatured: !_products[i].isFeatured,
        );
      });
      HapticFeedback.lightImpact();
      _showFloatingSnack(
        _products[i].isFeatured
            ? '${_products[i].name} destacado ⭐'
            : '${_products[i].name} removido de destacados',
      );
    }
  }

  void _deleteProduct(String id) {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1) {
      final name = _products[i].name;
      showDialog(
        context: context,
        builder: (_) => _DeleteDialog(
          productName: name,
          onConfirm: () {
            setState(() => _products.removeAt(i));
            _showFloatingSnack('"$name" eliminado', isError: true);
          },
        ),
      );
    }
  }

  void _showFloatingSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: isError ? _C.error : _C.primary,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_R.md),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _showProductActions(BusinessProduct product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductActionsSheet(
        product: product,
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
        onDelete: () {
          Navigator.pop(context);
          _deleteProduct(product.id);
        },
        onToggleAvailability: () {
          Navigator.pop(context);
          _toggleProductAvailability(product.id);
        },
        onToggleFeatured: () {
          Navigator.pop(context);
          _toggleFeatured(product.id);
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1200;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _C.background,
      appBar: _buildAppBar(filtered.length),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              children: [
                _buildSearchBar(isDesktop),
                _buildCategoryBar(isDesktop),
                if (_filtersExpanded) _buildExpandedFilters(isDesktop),
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : _buildProductList(filtered, isDesktop),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        backgroundColor: _C.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Agregar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(int count) {
    return AppBar(
      backgroundColor: _C.surface,
      foregroundColor: _C.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: widget.isTab
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
              splashRadius: 22,
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis Productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _C.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            '$count producto${count != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 12.5, color: _C.textHint),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  _filtersExpanded
                      ? Icons.filter_list_off_rounded
                      : Icons.tune_rounded,
                  size: 22,
                ),
                onPressed: () =>
                    setState(() => _filtersExpanded = !_filtersExpanded),
                splashRadius: 22,
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _C.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: _C.surface, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$_activeFilterCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _C.divider),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Search bar
  // ─────────────────────────────────────────────
  Widget _buildSearchBar(bool isDesktop) {
    return Container(
      color: _C.surface,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16,
        12,
        isDesktop ? 24 : 16,
        8,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _C.surfaceSoft,
          borderRadius: BorderRadius.circular(_R.lg),
          border: Border.all(color: _C.divider.withOpacity(0.95)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 14, color: _C.textPrimary),
          decoration: InputDecoration(
            hintText: 'Buscar producto...',
            hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Icons.search_rounded,
                color: _C.primaryLight,
                size: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: _C.textHint,
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    splashRadius: 18,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Category bar — con chip "+" al final
  // ─────────────────────────────────────────────
  Widget _buildCategoryBar(bool isDesktop) {
    return Container(
      color: _C.surface,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
          // +1 para el chip de agregar
          itemCount: _categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            // Último ítem → botón "Nueva categoría"
            if (i == _categories.length) {
              return _AddCategoryChip(onTap: _showAddCategorySheet);
            }

            final cat = _categories[i];
            final isActive = cat == _selectedCategory;
            final isCustom = _customCategories.contains(cat);

            // Contar productos en esta categoría (para badge)
            final count = cat == 'Todos'
                ? null
                : _products.where((p) => p.category == cat).length;

            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              onLongPress: isCustom ? () => _showCategoryOptions(cat) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? _C.primary : _C.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? _C.primary
                        : isCustom
                        ? _C.primary.withOpacity(0.25)
                        : _C.divider,
                    width: isCustom ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicador visual de categoría custom
                    if (isCustom && !isActive) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _C.primary.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      cat,
                      style: TextStyle(
                        color: isActive ? Colors.white : _C.textSecondary,
                        fontSize: 13,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    // Badge de cantidad si hay productos
                    if (count != null && count > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withOpacity(0.25)
                              : _C.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isActive ? Colors.white : _C.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Filtros expandibles
  // ─────────────────────────────────────────────
  Widget _buildExpandedFilters(bool isDesktop) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      color: _C.surface,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16,
        6,
        isDesktop ? 24 : 16,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: _C.divider, height: 1),
          const SizedBox(height: 10),

          // Disponibilidad
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Disponibilidad',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.textHint,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 12),
                ..._availabilityFilters.map((f) {
                  final isActive = f == _selectedAvailability;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedAvailability = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? _C.accent : _C.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? _C.accent : _C.divider,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isActive ? Colors.white : _C.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Ordenar por
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Ordenar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.textHint,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 12),
                ..._sortOptions.map((s) {
                  final isActive = s == _sortBy;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _sortBy = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? _C.primary : _C.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? _C.primary : _C.divider,
                          ),
                        ),
                        child: Text(
                          s,
                          style: TextStyle(
                            color: isActive ? Colors.white : _C.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          if (_hasActiveFilters) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() {
                _selectedCategory = 'Todos';
                _selectedAvailability = 'Todos';
                _sortBy = 'Nombre';
              }),
              child: const Text(
                'Limpiar filtros',
                style: TextStyle(
                  color: _C.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Product list
  // ─────────────────────────────────────────────
  Widget _buildProductList(List<BusinessProduct> products, bool isDesktop) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16,
        16,
        isDesktop ? 24 : 16,
        110,
      ),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final product = products[i];
        final delay = (i * 0.06).clamp(0.0, 0.5);
        return AnimatedBuilder(
          animation: _entryController,
          builder: (_, child) {
            final t = Curves.easeOutCubic.transform(
              ((_entryController.value - delay) / (1.0 - delay)).clamp(
                0.0,
                1.0,
              ),
            );
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - t)),
                child: child,
              ),
            );
          },
          child: _ProductCard(
            product: product,
            onTap: () => _showProductActions(product),
            onToggleAvailability: () => _toggleProductAvailability(product.id),
            onToggleFeatured: () => _toggleFeatured(product.id),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Empty state
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    final hasSearch = _searchQuery.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _C.surfaceSoft,
                borderRadius: BorderRadius.circular(_R.xl),
                border: Border.all(color: _C.divider),
              ),
              child: Icon(
                hasSearch
                    ? Icons.search_off_rounded
                    : Icons.inventory_2_outlined,
                size: 40,
                color: _C.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasSearch
                  ? 'Sin resultados para\n"$_searchQuery"'
                  : 'No hay productos aún',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _C.textPrimary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Prueba con otro término o ajusta los filtros'
                  : 'Agrega tu primer producto para comenzar a vender',
              style: const TextStyle(
                color: _C.textHint,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductFormScreen()),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Agregar producto',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_R.md),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Add Category Chip — botón "+" en la barra
// ═════════════════════════════════════════════
class _AddCategoryChip extends StatefulWidget {
  final VoidCallback onTap;
  const _AddCategoryChip({required this.onTap});

  @override
  State<_AddCategoryChip> createState() => _AddCategoryChipState();
}

class _AddCategoryChipState extends State<_AddCategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _pressed ? _C.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _C.accent,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 14, color: _C.accent),
            const SizedBox(width: 5),
            const Text(
              'Nueva',
              style: TextStyle(
                color: _C.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Add / Rename Category Sheet
// ═════════════════════════════════════════════
class _AddCategorySheet extends StatefulWidget {
  final List<String> existingCategories;
  final String? initialValue;
  final bool isRename;
  final ValueChanged<String> onAdd;

  const _AddCategorySheet({
    required this.existingCategories,
    required this.onAdd,
    this.initialValue,
    this.isRename = false,
  });

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  late final TextEditingController _ctrl;
  String _error = '';

  // Sugerencias rápidas de categorías comunes
  static const _suggestions = [
    'Frutas y Verduras',
    'Congelados',
    'Cereales',
    'Mascotas',
    'Higiene Personal',
    'Bebés',
    'Electrónica',
    'Papelería',
    'Ferretería',
    'Ropa',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _ctrl.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'El nombre no puede estar vacío');
      return;
    }
    if (value.length < 2) {
      setState(() => _error = 'Mínimo 2 caracteres');
      return;
    }
    // Verificar duplicado (ignorar si es renombrar con mismo nombre)
    final isDuplicate = widget.existingCategories
        .where((c) => c != widget.initialValue)
        .any((c) => c.toLowerCase() == value.toLowerCase());
    if (isDuplicate) {
      setState(() => _error = 'Ya existe una categoría con ese nombre');
      return;
    }
    Navigator.pop(context);
    widget.onAdd(value);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.xl)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _C.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.isRename
                      ? Icons.drive_file_rename_outline_rounded
                      : Icons.category_outlined,
                  color: _C.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.isRename ? 'Renombrar categoría' : 'Nueva categoría',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _C.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Campo de texto
          Container(
            decoration: BoxDecoration(
              color: _C.background,
              borderRadius: BorderRadius.circular(_R.md),
              border: Border.all(
                color: _error.isNotEmpty ? _C.error : _C.divider,
                width: _error.isNotEmpty ? 1.5 : 1.0,
              ),
            ),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 30,
              onChanged: (_) {
                if (_error.isNotEmpty) setState(() => _error = '');
              },
              onSubmitted: (_) => _submit(),
              style: const TextStyle(
                fontSize: 15,
                color: _C.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Ej: Frutas y Verduras',
                hintStyle: const TextStyle(color: _C.textHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                counterText: '',
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: _C.textHint,
                          size: 18,
                        ),
                        onPressed: () {
                          _ctrl.clear();
                          setState(() => _error = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Error
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: _error.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 13,
                          color: _C.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _error,
                          style: const TextStyle(
                            color: _C.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Sugerencias rápidas (solo en modo agregar)
          if (!widget.isRename) ...[
            const SizedBox(height: 16),
            const Text(
              'Sugerencias',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _C.textHint,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestions
                  .where(
                    (s) => !widget.existingCategories.any(
                      (e) => e.toLowerCase() == s.toLowerCase(),
                    ),
                  )
                  .take(6) // máximo 6 sugerencias
                  .map(
                    (s) => _SuggestionChip(
                      label: s,
                      onTap: () {
                        _ctrl.text = s;
                        _ctrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: s.length),
                        );
                        setState(() => _error = '');
                      },
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 20),

          // Botón confirmar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_R.md),
                ),
              ),
              child: Text(
                widget.isRename ? 'Guardar cambios' : 'Crear categoría',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de sugerencia en el sheet de nueva categoría
class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _C.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 12, color: _C.textHint),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: _C.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Category Options Sheet (Renombrar / Eliminar)
// ═════════════════════════════════════════════
class _CategoryOptionsSheet extends StatelessWidget {
  final String categoryName;
  final int productsCount;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _CategoryOptionsSheet({
    required this.categoryName,
    required this.productsCount,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _C.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _C.accentSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: _C.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: _C.textPrimary,
                        ),
                      ),
                      Text(
                        '$productsCount producto${productsCount != 1 ? 's' : ''} en esta categoría',
                        style: const TextStyle(
                          color: _C.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Divider(color: _C.divider, height: 1),
          ),

          _SheetAction(
            icon: Icons.drive_file_rename_outline_rounded,
            label: 'Renombrar categoría',
            onTap: onRename,
          ),
          _SheetAction(
            icon: Icons.delete_outline_rounded,
            iconColor: _C.error,
            labelColor: _C.error,
            label: 'Eliminar categoría',
            onTap: onDelete,
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Delete Category Dialog
// ═════════════════════════════════════════════
class _DeleteCategoryDialog extends StatelessWidget {
  final String categoryName;
  final int productsCount;
  final VoidCallback onConfirm;

  const _DeleteCategoryDialog({
    required this.categoryName,
    required this.productsCount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_R.xl)),
      backgroundColor: _C.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _C.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: _C.error,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Eliminar categoría',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _C.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: '¿Eliminar la categoría '),
                  TextSpan(
                    text: '"$categoryName"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _C.textPrimary,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            if (productsCount > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _C.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$productsCount producto${productsCount != 1 ? 's' : ''} '
                        'quedará${productsCount != 1 ? 'n' : ''} sin categoría asignada.',
                        style: const TextStyle(
                          color: _C.textSecondary,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _C.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: _C.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Product Card
// ═════════════════════════════════════════════
class _ProductCard extends StatelessWidget {
  final BusinessProduct product;
  final VoidCallback onTap;
  final VoidCallback onToggleAvailability;
  final VoidCallback onToggleFeatured;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onToggleAvailability,
    required this.onToggleFeatured,
  });

  int get _discountPercent {
    final op = product.originalPrice;
    if (op == null || op <= product.price) return 0;
    return (((op - product.price) / op) * 100).round();
  }

  Color get _stockColor {
    if (product.stock == 0) return _C.error;
    if (product.stock <= 5) return _C.warning;
    return _C.success;
  }

  String get _stockLabel {
    if (product.stock == 0) return 'Agotado';
    if (product.stock <= 5) return '¡Quedan ${product.stock}!';
    return '${product.stock} en stock';
  }

  @override
  Widget build(BuildContext context) {
    final discountPct = _discountPercent;

    return Material(
      color: _C.surface,
      borderRadius: BorderRadius.circular(_R.lg),
      elevation: product.isAvailable ? 1.5 : 0,
      shadowColor: const Color(0x140F2B46),
      child: InkWell(
        borderRadius: BorderRadius.circular(_R.lg),
        splashColor: _C.primary.withOpacity(0.04),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_R.lg),
            border: Border.all(
              color: !product.isAvailable
                  ? _C.divider
                  : product.isFeatured
                  ? _C.accent.withOpacity(0.4)
                  : _C.divider,
              width: product.isFeatured ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(_R.lg),
                ),
                child: SizedBox(
                  width: 98,
                  height: 118,
                  child: _ProductImagePlaceholder(
                    isAvailable: product.isAvailable,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 12, 10, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.isFeatured ||
                                    !product.isAvailable ||
                                    discountPct > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        if (product.isFeatured)
                                          _SmallBadge(
                                            '⭐ Destacado',
                                            _C.accent,
                                            _C.accentSoft,
                                          ),
                                        if (product.isFeatured &&
                                            !product.isAvailable)
                                          const SizedBox(width: 4),
                                        if (!product.isAvailable)
                                          _SmallBadge(
                                            'Agotado',
                                            _C.error,
                                            _C.error.withOpacity(0.1),
                                          ),
                                        if (discountPct > 0 &&
                                            product.isAvailable)
                                          _SmallBadge(
                                            '-$discountPct%',
                                            _C.accent,
                                            _C.accentSoft,
                                          ),
                                      ],
                                    ),
                                  ),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 14.8,
                                    fontWeight: FontWeight.w700,
                                    color: product.isAvailable
                                        ? _C.textPrimary
                                        : _C.textHint,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product.category,
                                  style: const TextStyle(
                                    color: _C.textHint,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.more_vert_rounded,
                                size: 18,
                                color: _C.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: product.isAvailable
                                  ? _C.primaryLight
                                  : _C.textHint,
                              letterSpacing: -0.4,
                            ),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: _C.textHint,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: _C.textHint,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _C.starColor.withOpacity(0.11),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 11,
                                  color: _C.starColor,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${product.rating}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _C.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${product.salesCount} ventas',
                            style: const TextStyle(
                              color: _C.textHint,
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _stockColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _stockLabel,
                              style: TextStyle(
                                color: _stockColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _ToggleChip(
                            label: product.isAvailable
                                ? 'Disponible'
                                : 'No disponible',
                            isActive: product.isAvailable,
                            activeColor: _C.success,
                            icon: product.isAvailable
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            onTap: onToggleAvailability,
                          ),
                          const SizedBox(width: 8),
                          _ToggleChip(
                            label: product.isFeatured
                                ? 'Destacado'
                                : 'Destacar',
                            isActive: product.isFeatured,
                            activeColor: _C.accent,
                            icon: product.isFeatured
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            onTap: onToggleFeatured,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;
  const _SmallBadge(this.label, this.textColor, this.bgColor);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: textColor.withOpacity(0.15)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _ToggleChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final IconData icon;
  final VoidCallback onTap;
  const _ToggleChip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ToggleChip> createState() => _ToggleChipState();
}

class _ToggleChipState extends State<_ToggleChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: widget.isActive
              ? widget.activeColor.withOpacity(_pressed ? 0.2 : 0.1)
              : _pressed
              ? _C.divider
              : _C.surfaceSoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isActive
                ? widget.activeColor.withOpacity(0.4)
                : _C.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 13,
              color: widget.isActive ? widget.activeColor : _C.textHint,
            ),
            const SizedBox(width: 5),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: widget.isActive ? widget.activeColor : _C.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  final bool isAvailable;
  const _ProductImagePlaceholder({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isAvailable ? _C.surfaceSoft : const Color(0xFFECEFF1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 22,
            color: isAvailable ? _C.primary : _C.textHint,
          ),
          const SizedBox(height: 4),
          Text(
            'Foto',
            style: TextStyle(
              fontSize: 10,
              color: isAvailable ? _C.primary : _C.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Product Actions Sheet
// ═════════════════════════════════════════════
class _ProductActionsSheet extends StatelessWidget {
  final BusinessProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;
  final VoidCallback onToggleFeatured;

  const _ProductActionsSheet({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
    required this.onToggleFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _C.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _C.surfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.divider),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: _C.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _C.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)} · ${product.category}',
                        style: const TextStyle(
                          color: _C.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Divider(color: _C.divider, height: 1),
          ),
          _SheetAction(
            icon: Icons.edit_outlined,
            label: 'Editar producto',
            onTap: onEdit,
          ),
          _SheetAction(
            icon: product.isAvailable
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            label: product.isAvailable
                ? 'Marcar como agotado'
                : 'Marcar como disponible',
            onTap: onToggleAvailability,
          ),
          _SheetAction(
            icon: product.isFeatured
                ? Icons.star_border_rounded
                : Icons.star_rounded,
            iconColor: _C.accent,
            label: product.isFeatured
                ? 'Quitar de destacados'
                : 'Marcar como destacado',
            onTap: onToggleFeatured,
          ),
          _SheetAction(
            icon: Icons.delete_outline_rounded,
            iconColor: _C.error,
            labelColor: _C.error,
            label: 'Eliminar producto',
            onTap: onDelete,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? _C.textSecondary;
    final lc = labelColor ?? _C.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ic.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: ic),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: lc,
                  fontSize: 14.5,
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

// ═════════════════════════════════════════════
// Delete Product Dialog
// ═════════════════════════════════════════════
class _DeleteDialog extends StatelessWidget {
  final String productName;
  final VoidCallback onConfirm;
  const _DeleteDialog({required this.productName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_R.xl)),
      backgroundColor: _C.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _C.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: _C.error,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Eliminar producto',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _C.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: '¿Eliminar '),
                  TextSpan(
                    text: '"$productName"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _C.textPrimary,
                    ),
                  ),
                  const TextSpan(text: '? Esta acción no se puede deshacer.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _C.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: _C.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Modelo
// ═════════════════════════════════════════════
class BusinessProduct {
  final String id, name, description, category, unit;
  final double price;
  final double? originalPrice;
  final int stock, salesCount;
  final bool isAvailable, isFeatured;
  final List<String> images;
  final double rating;
  final DateTime createdAt;

  BusinessProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.unit,
    required this.stock,
    required this.isAvailable,
    required this.images,
    required this.rating,
    required this.salesCount,
    required this.createdAt,
    this.isFeatured = false,
  });

  BusinessProduct copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    String? unit,
    int? stock,
    int? salesCount,
    bool? isAvailable,
    bool? isFeatured,
    List<String>? images,
    double? rating,
    DateTime? createdAt,
  }) => BusinessProduct(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    originalPrice: originalPrice ?? this.originalPrice,
    category: category ?? this.category,
    unit: unit ?? this.unit,
    stock: stock ?? this.stock,
    salesCount: salesCount ?? this.salesCount,
    isAvailable: isAvailable ?? this.isAvailable,
    isFeatured: isFeatured ?? this.isFeatured,
    images: images ?? this.images,
    rating: rating ?? this.rating,
    createdAt: createdAt ?? this.createdAt,
  );
}
