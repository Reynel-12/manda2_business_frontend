import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manda2_business_frontend/view/business/business_finance_screen.dart';
import 'package:manda2_business_frontend/view/business/business_product_screen.dart';
import 'package:manda2_business_frontend/view/business/business_settings.dart';

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
}

class _R {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 24.0;
}

// ─────────────────────────────────────────────
// BusinessDashboardScreen
// ─────────────────────────────────────────────
class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<BusinessOrder> _orders = [];
  BusinessStore? _storeInfo;
  BusinessStats? _stats;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ── Lifecycle ───────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadStoreData();
    _loadOrders();
    _calculateStats();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ── Data (sin cambios) ───────────────────────
  void _loadStoreData() {
    _storeInfo = BusinessStore(
      id: 'STORE-001',
      name: 'Pulpería "El Buen Precio"',
      category: 'Supermercado',
      ownerName: 'Carlos Rodríguez',
      phone: '+504 1234-5678',
      rating: 4.8,
      totalOrders: 1245,
      isOpen: true,
      openingTime: '7:00 AM',
      closingTime: '10:00 PM',
      email: '',
      address: '',
    );
  }

  void _loadOrders() {
    _orders = [
      BusinessOrder(
        id: 'ORD-2024-001',
        customerName: 'María González',
        customerPhone: '+504 9876-5432',
        items: [
          OrderItem(name: 'Leche Entera 1L', quantity: 2, price: 2.50),
          OrderItem(name: 'Pan Integral', quantity: 1, price: 1.75),
          OrderItem(name: 'Huevos x12', quantity: 1, price: 3.20),
        ],
        totalAmount: 9.95,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedDeliveryTime: 20,
        status: OrderStatus.pending,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Barrio Los Pinos, Casa #45',
        notes: 'Casa color azul, portón negro',
      ),
      BusinessOrder(
        id: 'ORD-2024-002',
        customerName: 'José Martínez',
        customerPhone: '+504 8765-4321',
        items: [
          OrderItem(name: 'Arroz 5kg', quantity: 1, price: 8.90),
          OrderItem(name: 'Aceite 1L', quantity: 1, price: 4.30),
          OrderItem(name: 'Frijoles 1kg', quantity: 2, price: 2.75),
        ],
        totalAmount: 18.70,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        estimatedDeliveryTime: 25,
        status: OrderStatus.preparing,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Residencial Las Flores, Casa #8',
        notes: 'Entregar en la puerta trasera',
      ),
      BusinessOrder(
        id: 'ORD-2024-003',
        customerName: 'Ana López',
        customerPhone: '+504 555-1234',
        items: [
          OrderItem(name: 'Jugo de Naranja 1L', quantity: 1, price: 3.50),
          OrderItem(name: 'Galletas de Chocolate', quantity: 2, price: 2.20),
          OrderItem(name: 'Queso 250g', quantity: 1, price: 4.75),
        ],
        totalAmount: 12.65,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedDeliveryTime: 15,
        status: OrderStatus.ready,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Colonia San José, Apartamento 302',
        notes: 'Pedir en recepción',
      ),
      BusinessOrder(
        id: 'ORD-2024-004',
        customerName: 'Roberto García',
        customerPhone: '+504 777-8888',
        items: [
          OrderItem(name: 'Pollo a la Parrilla', quantity: 1, price: 8.99),
          OrderItem(name: 'Ensalada César', quantity: 1, price: 4.50),
          OrderItem(name: 'Refresco 500ml', quantity: 2, price: 1.25),
        ],
        totalAmount: 15.99,
        deliveryFee: 2.00,
        orderTime: DateTime.now().subtract(const Duration(hours: 1)),
        estimatedDeliveryTime: 18,
        status: OrderStatus.onTheWay,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Urbanización Bella Vista, Casa #23',
        notes: 'Casa con jardín grande',
      ),
      BusinessOrder(
        id: 'ORD-2024-005',
        customerName: 'Laura Fernández',
        customerPhone: '+504 666-9999',
        items: [
          OrderItem(name: 'Detergente 2L', quantity: 1, price: 6.80),
          OrderItem(name: 'Suavizante 1L', quantity: 1, price: 5.25),
          OrderItem(name: 'Jabón de barra', quantity: 3, price: 1.50),
        ],
        totalAmount: 16.55,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        estimatedDeliveryTime: 22,
        status: OrderStatus.delivered,
        paymentMethod: 'Efectivo',
        deliveryAddress: 'Colonia Miraflores, Casa #12',
        notes: '',
      ),
      BusinessOrder(
        id: 'ORD-2024-006',
        customerName: 'Miguel Ángel',
        customerPhone: '+504 333-4444',
        items: [
          OrderItem(name: 'Vino Tinto 750ml', quantity: 1, price: 12.99),
          OrderItem(name: 'Cerveza Nacional 6-pack', quantity: 1, price: 7.50),
        ],
        totalAmount: 20.49,
        deliveryFee: 1.50,
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        estimatedDeliveryTime: 25,
        status: OrderStatus.cancelled,
        paymentMethod: 'Tarjeta',
        deliveryAddress: 'Residencial Las Flores',
        notes: 'Cliente canceló el pedido',
      ),
    ];
  }

  void _calculateStats() {
    final today = DateTime.now();
    final todayOrders = _orders
        .where(
          (o) =>
              o.orderTime.day == today.day &&
              o.orderTime.month == today.month &&
              o.orderTime.year == today.year,
        )
        .toList();

    _stats = BusinessStats(
      todayOrders: todayOrders.length,
      todayRevenue: todayOrders.fold(0.0, (s, o) => s + o.totalAmount),
      pendingOrders: _orders
          .where((o) => o.status == OrderStatus.pending)
          .length,
      preparingOrders: _orders
          .where((o) => o.status == OrderStatus.preparing)
          .length,
      readyOrders: _orders.where((o) => o.status == OrderStatus.ready).length,
      totalOrders: _orders.length,
      totalRevenue: _orders.fold(0.0, (s, o) => s + o.totalAmount),
      averageOrderValue: _orders.isEmpty
          ? 0.0
          : _orders.fold(0.0, (s, o) => s + o.totalAmount) / _orders.length,
    );
  }

  // ── Business logic (sin cambios) ────────────
  void _acceptOrder(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i != -1 && _orders[i].status == OrderStatus.pending) {
      setState(() {
        _orders[i] = _orders[i].copyWith(
          status: OrderStatus.preparing,
          acceptedTime: DateTime.now(),
        );
        _calculateStats();
      });
      _showFloatingSnack(
        'Pedido $orderId aceptado ✓',
        action: SnackBarAction(
          label: 'Ver',
          textColor: _C.accent,
          onPressed: () => _viewOrderDetails(_orders[i]),
        ),
      );
    }
  }

  void _markOrderReady(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i != -1 && _orders[i].status == OrderStatus.preparing) {
      setState(() {
        _orders[i] = _orders[i].copyWith(
          status: OrderStatus.ready,
          readyTime: DateTime.now(),
        );
        _calculateStats();
      });
      _showFloatingSnack('Pedido $orderId marcado como listo ✓');
    }
  }

  void _finalizeOrder(String orderId) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i != -1 && _orders[i].status == OrderStatus.ready) {
      setState(() {
        _orders[i] = _orders[i].copyWith(
          status: OrderStatus.delivered,
          deliveredTime: DateTime.now(),
        );
        _calculateStats();
      });
      _showFloatingSnack('Pedido $orderId entregado ✓');
    }
  }

  void _cancelOrder(String orderId, {required String reason}) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i != -1 &&
        _orders[i].status != OrderStatus.delivered &&
        _orders[i].status != OrderStatus.cancelled) {
      setState(() {
        _orders[i] = _orders[i].copyWith(
          status: OrderStatus.cancelled,
          cancelledTime: DateTime.now(),
          cancelReason: reason.trim(),
        );
        _calculateStats();
      });
      _showFloatingSnack('Pedido $orderId cancelado', isError: true);
    }
  }

  void _toggleStoreStatus() {
    if (_storeInfo != null) {
      setState(() {
        _storeInfo = _storeInfo!.copyWith(isOpen: !_storeInfo!.isOpen);
      });
      HapticFeedback.lightImpact();
      _showFloatingSnack(
        _storeInfo!.isOpen ? 'Negocio abierto' : 'Negocio cerrado',
      );
    }
  }

  void _showFloatingSnack(
    String msg, {
    bool isError = false,
    SnackBarAction? action,
  }) {
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
          action: action,
        ),
      );
  }

  // ── Dialogs (sin cambios funcionales, mejorados visualmente) ──
  Future<void> _confirmAcceptOrder(BusinessOrder order) async {
    final ok = await _showConfirmDialog(
      title: 'Aceptar pedido',
      body:
          '¿Aceptar el pedido ${order.id} de ${order.customerName}?\n\nPasará a preparación.',
      confirmLabel: 'Sí, aceptar',
      confirmColor: _C.accent,
    );
    if (ok == true) _acceptOrder(order.id);
  }

  Future<void> _confirmFinalizeOrder(BusinessOrder order) async {
    final ok = await _showConfirmDialog(
      title: 'Finalizar pedido',
      body: '¿Confirmas que el pedido ${order.id} fue entregado?',
      confirmLabel: 'Sí, finalizar',
      confirmColor: _C.primary,
    );
    if (ok == true) _finalizeOrder(order.id);
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => _AppDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
      ),
    );
  }

  Future<void> _promptCancelOrder(
    BusinessOrder order, {
    String title = 'Cancelar pedido',
    String confirmLabel = 'Sí, cancelar',
  }) async {
    final reasonController = TextEditingController();
    try {
      final result = await showDialog<String?>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _CancelDialog(
          orderId: order.id,
          title: title,
          confirmLabel: confirmLabel,
          controller: reasonController,
        ),
      );
      if (result != null) _cancelOrder(order.id, reason: result);
    } finally {
      reasonController.dispose();
    }
  }

  void _viewOrderDetails(BusinessOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _OrderDetailsSheet(
        order: order,
        onAccept: () {
          Navigator.pop(context);
          _confirmAcceptOrder(order);
        },
        onMarkReady: () {
          Navigator.pop(context);
          _markOrderReady(order.id);
        },
        onFinalize: () {
          Navigator.pop(context);
          _confirmFinalizeOrder(order);
        },
        onCancel: () {
          Navigator.pop(context);
          _promptCancelOrder(order);
        },
        onReject: () {
          Navigator.pop(context);
          _promptCancelOrder(
            order,
            title: 'Rechazar pedido',
            confirmLabel: 'Sí, rechazar',
          );
        },
        getStatusText: _getStatusText,
        getStatusColor: _getStatusColor,
        getStatusIconColor: _getStatusIconColor,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1200;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _C.background,
      appBar: _buildAppBar(),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoreHeader(isDesktop || isTablet),
                      const SizedBox(height: 26),
                      _buildStatsRow(isDesktop, isTablet),
                      const SizedBox(height: 30),
                      _buildOrdersSection(isDesktop, isTablet),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // Bottom nav reactivado y modernizado
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.surface,
      foregroundColor: _C.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      // leading: IconButton(
      //   icon: const Icon(Icons.menu_rounded),
      //   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      //   splashRadius: 22,
      // ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _C.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            'Vista del negocio',
            style: TextStyle(fontSize: 12.5, color: _C.textHint),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 22),
          onPressed: () {},
          splashRadius: 22,
        ),
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 22),
          onPressed: () {
            setState(() {
              _loadOrders();
              _calculateStats();
            });
            HapticFeedback.lightImpact();
          },
          splashRadius: 22,
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _C.divider),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Store header — rediseñado
  // ─────────────────────────────────────────────
  Widget _buildStoreHeader(bool isWide) {
    final store = _storeInfo!;
    final isOpen = store.isOpen;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.xl),
        border: Border.all(color: _C.divider.withOpacity(0.95)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F2B46),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _StoreInfo(store: store)),
                const SizedBox(width: 20),
                _StoreStatusToggle(
                  isOpen: isOpen,
                  onToggle: _toggleStoreStatus,
                  openingTime: store.openingTime,
                  closingTime: store.closingTime,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StoreInfo(store: store),
                const SizedBox(height: 16),
                const Divider(color: _C.divider, height: 1),
                const SizedBox(height: 16),
                _StoreStatusToggle(
                  isOpen: isOpen,
                  onToggle: _toggleStoreStatus,
                  openingTime: store.openingTime,
                  closingTime: store.closingTime,
                  horizontal: true,
                ),
              ],
            ),
    );
  }

  // ─────────────────────────────────────────────
  // Stats — horizontal scroll en móvil
  // ─────────────────────────────────────────────
  Widget _buildStatsRow(bool isDesktop, bool isTablet) {
    final stats = _stats!;
    final cards = [
      _StatData(
        Icons.shopping_bag_outlined,
        '${stats.todayOrders}',
        'Pedidos hoy',
        _C.primary,
      ),
      _StatData(
        Icons.attach_money_rounded,
        '\$${stats.todayRevenue.toStringAsFixed(0)}',
        'Ventas hoy',
        _C.accent,
      ),
      _StatData(
        Icons.schedule_rounded,
        '${stats.pendingOrders}',
        'Pendientes',
        _C.warning,
      ),
      _StatData(
        Icons.restaurant_outlined,
        '${stats.preparingOrders}',
        'Preparando',
        _C.primaryLight,
      ),
    ];

    if (isDesktop || isTablet) {
      return Row(
        children: cards
            .map(
              (d) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _StatCard(data: d),
                ),
              ),
            )
            .toList(),
      );
    }

    // Móvil: scroll horizontal compacto
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _StatCardCompact(data: cards[i]),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Orders section
  // ─────────────────────────────────────────────
  Widget _buildOrdersSection(bool isDesktop, bool isTablet) {
    // Ordenar: urgentes primero
    final sorted = [..._orders]
      ..sort((a, b) {
        return _orderPriority(a.status).compareTo(_orderPriority(b.status));
      });

    final activeOrders = sorted
        .where(
          (o) =>
              o.status != OrderStatus.delivered &&
              o.status != OrderStatus.cancelled,
        )
        .toList();
    final finishedOrders = sorted
        .where(
          (o) =>
              o.status == OrderStatus.delivered ||
              o.status == OrderStatus.cancelled,
        )
        .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.xl),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pedidos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _C.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_orders.length} total',
                  style: const TextStyle(
                    color: _C.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Pedidos activos ─────────────────────
          if (activeOrders.isNotEmpty) ...[
            _buildOrderGrid(activeOrders, isDesktop, isTablet),
          ],

          // ── Pedidos finalizados ─────────────────
          if (finishedOrders.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionDivider(label: 'Finalizados'),
            const SizedBox(height: 12),
            _buildOrderGrid(finishedOrders, isDesktop, isTablet, opacity: 0.65),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderGrid(
    List<BusinessOrder> orders,
    bool isDesktop,
    bool isTablet, {
    double opacity = 1.0,
  }) {
    final cols = isDesktop
        ? 3
        : isTablet
        ? 2
        : 1;
    return LayoutBuilder(
      builder: (_, constraints) {
        const spacing = 14.0;
        final w = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: orders
              .map(
                (o) => Opacity(
                  opacity: opacity,
                  child: SizedBox(
                    width: w,
                    child: _OrderCard(
                      order: o,
                      getStatusText: _getStatusText,
                      getStatusColor: _getStatusColor,
                      getStatusIconColor: _getStatusIconColor,
                      onViewDetails: () => _viewOrderDetails(o),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Bottom Nav — reactivado
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(color: _C.surface),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
          child: Row(
            children: [
              _BizNavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isActive: true,
                onTap: () {},
              ),
              _BizNavItem(
                icon: Icons.inventory_2_outlined,
                activeIcon: Icons.inventory_2_rounded,
                label: 'Productos',
                isActive: false,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BusinessProductsScreen(),
                  ),
                ),
              ),
              // _BizNavItem(
              //   icon: Icons.local_offer_outlined,
              //   activeIcon: Icons.local_offer_rounded,
              //   label: 'Promos',
              //   isActive: false,
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => const CreatePromotionScreen(),
              //     ),
              //   ),
              // ),
              _BizNavItem(
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet_rounded,
                label: 'Finanzas',
                isActive: false,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BusinessFinanceScreen(),
                  ),
                ),
              ),
              _BizNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: 'Ajustes',
                isActive: false,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BusinessSettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────
  int _orderPriority(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.onTheWay:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return 5;
    }
  }

  String _getStatusText(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.preparing:
        return 'Preparando';
      case OrderStatus.ready:
        return 'Listo';
      case OrderStatus.onTheWay:
        return 'En camino';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  Color _getStatusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return _C.warning;
      case OrderStatus.preparing:
        return _C.primaryLight;
      case OrderStatus.ready:
        return const Color(0xFF1F8A70);
      case OrderStatus.onTheWay:
        return _C.accent;
      case OrderStatus.delivered:
        return _C.success;
      case OrderStatus.cancelled:
        return _C.error;
    }
  }

  Color _getStatusIconColor(OrderStatus s) => _getStatusColor(s);

  // String _formatTime(DateTime d) =>
  //     '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  // String _formatDateTime(DateTime d) =>
  //     '${_formatTime(d)} · ${d.day}/${d.month}/${d.year}';
}

// ═════════════════════════════════════════════
// Sub-widgets
// ═════════════════════════════════════════════

/// Info de la tienda (nombre, categoría, rating)
class _StoreInfo extends StatelessWidget {
  final BusinessStore store;
  const _StoreInfo({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          store.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _C.textPrimary,
            letterSpacing: -0.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          store.category,
          style: const TextStyle(color: _C.textHint, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFA726), size: 16),
            const SizedBox(width: 4),
            Text(
              '${store.rating}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: _C.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '· ${store.totalOrders} pedidos',
              style: const TextStyle(color: _C.textHint, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

/// Toggle de apertura/cierre — claro y accionable
class _StoreStatusToggle extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final String openingTime;
  final String closingTime;
  final bool horizontal;

  const _StoreStatusToggle({
    required this.isOpen,
    required this.onToggle,
    required this.openingTime,
    required this.closingTime,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isOpen ? _C.success : _C.error;

    final badge = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            isOpen ? 'ABIERTO' : 'CERRADO',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );

    final toggleRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isOpen ? 'Cerrar negocio' : 'Abrir negocio',
          style: const TextStyle(
            color: _C.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: isOpen,
          onChanged: (_) => onToggle(),
          activeColor: _C.success,
          inactiveThumbColor: _C.error,
          inactiveTrackColor: _C.error.withOpacity(0.25),
        ),
      ],
    );

    final timeRow = Text(
      '$openingTime – $closingTime',
      style: const TextStyle(color: _C.textHint, fontSize: 12),
    );

    if (horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [badge, const SizedBox(height: 4), timeRow],
          ),
          toggleRow,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        badge,
        const SizedBox(height: 8),
        timeRow,
        const SizedBox(height: 8),
        toggleRow,
      ],
    );
  }
}

/// Stat card — versión desktop (vertical)
class _StatData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatData(this.icon, this.value, this.label, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.lg),
        border: Border.all(color: _C.divider),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B0F2B46),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_R.sm),
                ),
                child: Icon(data.icon, size: 18, color: data.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: data.color,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: const TextStyle(color: _C.textHint, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Stat card — versión móvil horizontal (scroll)
class _StatCardCompact extends StatelessWidget {
  final _StatData data;
  const _StatCardCompact({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.md),
        border: Border.all(color: _C.divider),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F2B46),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 18, color: data.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: data.color,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  data.label,
                  style: const TextStyle(color: _C.textHint, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Divider de sección con label
class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _C.textHint,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(child: Divider(color: _C.divider, height: 1)),
    ],
  );
}

/// Order card rediseñada con indicador de urgencia
class _OrderCard extends StatelessWidget {
  final BusinessOrder order;
  final String Function(OrderStatus) getStatusText;
  final Color Function(OrderStatus) getStatusColor;
  final Color Function(OrderStatus) getStatusIconColor;
  final VoidCallback onViewDetails;

  const _OrderCard({
    required this.order,
    required this.getStatusText,
    required this.getStatusColor,
    required this.getStatusIconColor,
    required this.onViewDetails,
  });

  bool get _isUrgent =>
      order.status == OrderStatus.pending || order.status == OrderStatus.ready;

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(order.status);
    final isActive =
        order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled;

    return Material(
      color: _C.surface,
      borderRadius: BorderRadius.circular(_R.lg),
      elevation: isActive ? 1.5 : 0,
      shadowColor: const Color(0x140F2B46),
      child: InkWell(
        borderRadius: BorderRadius.circular(_R.lg),
        splashColor: _C.primary.withOpacity(0.04),
        onTap: onViewDetails,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_R.lg),
            border: Border.all(
              color: _isUrgent ? statusColor.withOpacity(0.35) : _C.divider,
              width: _isUrgent ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header de la card ──────────────
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.07),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(_R.lg),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: _C.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusText(order.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Cuerpo ─────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: _C.surfaceSoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: _C.primary,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: _C.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                order.deliveryAddress,
                                style: const TextStyle(
                                  color: _C.textHint,
                                  fontSize: 11.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Items (máx 2)
                    ...order.items
                        .take(2)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                const Text(
                                  '·  ',
                                  style: TextStyle(
                                    color: _C.textHint,
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${item.name} ×${item.quantity}',
                                    style: const TextStyle(
                                      color: _C.textSecondary,
                                      fontSize: 12.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    if (order.items.length > 2)
                      Text(
                        '+${order.items.length - 2} más',
                        style: const TextStyle(
                          color: _C.textHint,
                          fontSize: 12,
                        ),
                      ),

                    const SizedBox(height: 12),
                    const Divider(color: _C.divider, height: 1),
                    const SizedBox(height: 10),

                    // Footer: precio + botón de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _C.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        _OrderActionChip(
                          order: order,
                          statusColor: statusColor,
                          onViewDetails: onViewDetails,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip de acción contextual según estado
class _OrderActionChip extends StatelessWidget {
  final BusinessOrder order;
  final Color statusColor;
  final VoidCallback onViewDetails;

  const _OrderActionChip({
    required this.order,
    required this.statusColor,
    required this.onViewDetails,
  });

  String get _label {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Revisar ·';
      case OrderStatus.preparing:
        return 'Marcar listo';
      case OrderStatus.ready:
        return 'Finalizar ·';
      default:
        return 'Ver detalles';
    }
  }

  bool get _isUrgent =>
      order.status == OrderStatus.pending || order.status == OrderStatus.ready;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _isUrgent ? statusColor : _C.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isUrgent ? Colors.transparent : _C.divider,
          ),
        ),
        child: Text(
          _label,
          style: TextStyle(
            color: _isUrgent ? Colors.white : _C.textSecondary,
            fontSize: 11.8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Bottom nav item para la app de negocio
class _BizNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BizNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? _C.primary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: isActive ? _C.primary : _C.textHint,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? _C.primary : _C.textHint,
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
// Dialogs mejorados
// ═════════════════════════════════════════════
class _AppDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final Color confirmColor;
  const _AppDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.confirmColor,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(
                color: _C.textSecondary,
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
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
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
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

class _CancelDialog extends StatefulWidget {
  final String orderId;
  final String title;
  final String confirmLabel;
  final TextEditingController controller;
  const _CancelDialog({
    required this.orderId,
    required this.title,
    required this.confirmLabel,
    required this.controller,
  });

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  String? _error;

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
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _C.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pedido: ${widget.orderId}',
              style: const TextStyle(color: _C.textHint, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widget.controller,
              autofocus: true,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 14, color: _C.textPrimary),
              decoration: InputDecoration(
                hintText: 'Ej. Sin stock · Cliente no responde',
                hintStyle: const TextStyle(color: _C.textHint),
                errorText: _error,
                labelText: 'Motivo de cancelación',
                labelStyle: const TextStyle(color: _C.textSecondary),
                filled: true,
                fillColor: _C.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_R.md),
                  borderSide: const BorderSide(color: _C.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_R.md),
                  borderSide: const BorderSide(color: _C.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_R.md),
                  borderSide: const BorderSide(color: _C.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_R.md),
                  borderSide: const BorderSide(color: _C.error),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(color: _C.error.withOpacity(0.8), fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, null),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _C.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_R.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: _C.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final r = widget.controller.text.trim();
                      if (r.isEmpty) {
                        setState(() => _error = 'Ingresa un motivo');
                        return;
                      }
                      Navigator.pop(context, r);
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
                    child: Text(
                      widget.confirmLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
// Order Details Sheet
// ═════════════════════════════════════════════
class _OrderDetailsSheet extends StatelessWidget {
  final BusinessOrder order;
  final VoidCallback onAccept;
  final VoidCallback onMarkReady;
  final VoidCallback onFinalize;
  final VoidCallback onCancel;
  final VoidCallback onReject;
  final String Function(OrderStatus) getStatusText;
  final Color Function(OrderStatus) getStatusColor;
  final Color Function(OrderStatus) getStatusIconColor;

  const _OrderDetailsSheet({
    required this.order,
    required this.onAccept,
    required this.onMarkReady,
    required this.onFinalize,
    required this.onCancel,
    required this.onReject,
    required this.getStatusText,
    required this.getStatusColor,
    required this.getStatusIconColor,
  });

  String _fmt(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  String _fmtFull(DateTime d) => '${_fmt(d)} · ${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(order.status);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_R.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _C.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.25)),
                  ),
                  child: Text(
                    getStatusText(order.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de progreso
                  _ProgressBar(
                    order: order,
                    getStatusColor: getStatusColor,
                    formatTime: _fmt,
                  ),
                  const SizedBox(height: 16),

                  // Info cliente
                  _DetailSection(
                    label: 'Cliente',
                    children: [
                      _DetailRow(
                        Icons.person_outline_rounded,
                        'Nombre',
                        order.customerName,
                      ),
                      _DetailRow(
                        Icons.phone_outlined,
                        'Teléfono',
                        order.customerPhone,
                      ),
                      _DetailRow(
                        Icons.location_on_outlined,
                        'Dirección',
                        order.deliveryAddress,
                      ),
                      _DetailRow(
                        Icons.access_time_outlined,
                        'Hora pedido',
                        _fmtFull(order.orderTime),
                      ),
                      _DetailRow(
                        Icons.timer_outlined,
                        'Tiempo est.',
                        '${order.estimatedDeliveryTime} min',
                      ),
                      _DetailRow(
                        Icons.payment_outlined,
                        'Pago',
                        order.paymentMethod,
                      ),
                      if (order.status == OrderStatus.cancelled &&
                          (order.cancelReason?.trim().isNotEmpty ?? false))
                        _DetailRow(
                          Icons.cancel_outlined,
                          'Motivo cancelación',
                          order.cancelReason!.trim(),
                          valueColor: _C.error,
                        ),
                      if (order.notes.isNotEmpty)
                        _DetailRow(
                          Icons.note_alt_outlined,
                          'Notas',
                          order.notes,
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Items del pedido — con precio unitario
                  _DetailSection(
                    label: 'Ítems del pedido',
                    children: [
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: _C.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '×${item.quantity}  ·  \$${item.price.toStringAsFixed(2)} c/u',
                                      style: const TextStyle(
                                        color: _C.textHint,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: _C.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: _C.divider, height: 16),
                      _TotalRow(
                        'Subtotal',
                        order.totalAmount - order.deliveryFee,
                      ),
                      _TotalRow('Tarifa de entrega', order.deliveryFee),
                      _TotalRow('Total', order.totalAmount, isTotal: true),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Acciones
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  12,
            ),
            child: _OrderActions(
              order: order,
              onAccept: onAccept,
              onMarkReady: onMarkReady,
              onFinalize: onFinalize,
              onCancel: onCancel,
              onReject: onReject,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barra de progreso del pedido — visible y clara
class _ProgressBar extends StatelessWidget {
  final BusinessOrder order;
  final Color Function(OrderStatus) getStatusColor;
  final String Function(DateTime) formatTime;

  const _ProgressBar({
    required this.order,
    required this.getStatusColor,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _C.error.withOpacity(0.07),
          borderRadius: BorderRadius.circular(_R.md),
          border: Border.all(color: _C.error.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: _C.error, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Pedido cancelado',
              style: TextStyle(
                color: _C.error,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            if (order.cancelledTime != null)
              Text(
                formatTime(order.cancelledTime!),
                style: const TextStyle(color: _C.textHint, fontSize: 12),
              ),
          ],
        ),
      );
    }

    final steps = [
      _StepDef('Recibido', Icons.schedule_rounded, true, order.orderTime),
      _StepDef(
        'Aceptado',
        Icons.thumb_up_alt_rounded,
        order.acceptedTime != null,
        order.acceptedTime,
      ),
      _StepDef(
        'Listo',
        Icons.inventory_2_outlined,
        order.readyTime != null,
        order.readyTime,
      ),
      _StepDef(
        'Entregado',
        Icons.check_circle_rounded,
        order.deliveredTime != null,
        order.deliveredTime,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0F8),
        borderRadius: BorderRadius.circular(_R.md),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = steps[i ~/ 2 + 1].isDone;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? _C.primary : _C.divider,
              ),
            );
          }
          final step = steps[i ~/ 2];
          return _StepDot(step: step, formatTime: formatTime);
        }),
      ),
    );
  }
}

class _StepDef {
  final String label;
  final IconData icon;
  final bool isDone;
  final DateTime? time;
  const _StepDef(this.label, this.icon, this.isDone, this.time);
}

class _StepDot extends StatelessWidget {
  final _StepDef step;
  final String Function(DateTime) formatTime;
  const _StepDot({required this.step, required this.formatTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: step.isDone ? _C.primary : _C.divider,
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 15,
            color: step.isDone ? Colors.white : _C.textHint,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          step.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: step.isDone ? FontWeight.w700 : FontWeight.w400,
            color: step.isDone ? _C.primary : _C.textHint,
          ),
        ),
        if (step.time != null)
          Text(
            formatTime(step.time!),
            style: const TextStyle(fontSize: 9.5, color: _C.textHint),
          ),
      ],
    );
  }
}

/// Sección con label en el sheet
class _DetailSection extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _DetailSection({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(_R.md),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: _C.textHint,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(this.icon, this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _C.textHint),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: _C.textHint, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? _C.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  const _TotalRow(this.label, this.amount, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              color: isTotal ? _C.textPrimary : _C.textHint,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 17 : 13,
              color: _C.primary,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Acciones del order sheet — sin cambios funcionales
class _OrderActions extends StatelessWidget {
  final BusinessOrder order;
  final VoidCallback onAccept;
  final VoidCallback onMarkReady;
  final VoidCallback onFinalize;
  final VoidCallback onCancel;
  final VoidCallback onReject;

  const _OrderActions({
    required this.order,
    required this.onAccept,
    required this.onMarkReady,
    required this.onFinalize,
    required this.onCancel,
    required this.onReject,
  });

  Widget _closeBtn(BuildContext context) => OutlinedButton(
    onPressed: () => Navigator.pop(context),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: _C.divider),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_R.md)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    child: const Text('Cerrar', style: TextStyle(color: _C.textSecondary)),
  );

  Widget _primaryBtn(String label, Color bg, VoidCallback onTap) => Expanded(
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_R.md),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    switch (order.status) {
      case OrderStatus.pending:
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _closeBtn(context)),
                const SizedBox(width: 12),
                _primaryBtn('Aceptar', _C.accent, onAccept),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onReject,
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
                  'Rechazar pedido',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.preparing:
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _closeBtn(context)),
                const SizedBox(width: 12),
                _primaryBtn('Marcar listo', _C.primary, onMarkReady),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
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
                  'Cancelar pedido',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.ready:
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _closeBtn(context)),
                const SizedBox(width: 12),
                _primaryBtn('Finalizar', _C.primary, onFinalize),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
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
                  'Cancelar pedido',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.onTheWay:
        return Column(
          children: [
            SizedBox(width: double.infinity, child: _closeBtn(context)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
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
                  'Cancelar pedido',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );

      default:
        return SizedBox(width: double.infinity, child: _closeBtn(context));
    }
  }
}

// ═════════════════════════════════════════════
// Modelos (sin cambios)
// ═════════════════════════════════════════════
enum OrderStatus { pending, preparing, ready, onTheWay, delivered, cancelled }

class BusinessOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final DateTime orderTime;
  final int estimatedDeliveryTime;
  OrderStatus status;
  final String paymentMethod;
  final String deliveryAddress;
  final String notes;
  DateTime? acceptedTime;
  DateTime? readyTime;
  DateTime? deliveredTime;
  DateTime? cancelledTime;
  String? cancelReason;

  BusinessOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.orderTime,
    required this.estimatedDeliveryTime,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.notes,
    this.acceptedTime,
    this.readyTime,
    this.deliveredTime,
    this.cancelledTime,
    this.cancelReason,
  });

  BusinessOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    List<OrderItem>? items,
    double? totalAmount,
    double? deliveryFee,
    DateTime? orderTime,
    int? estimatedDeliveryTime,
    OrderStatus? status,
    String? paymentMethod,
    String? deliveryAddress,
    String? notes,
    DateTime? acceptedTime,
    DateTime? readyTime,
    DateTime? deliveredTime,
    DateTime? cancelledTime,
    String? cancelReason,
  }) => BusinessOrder(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone ?? this.customerPhone,
    items: items ?? this.items,
    totalAmount: totalAmount ?? this.totalAmount,
    deliveryFee: deliveryFee ?? this.deliveryFee,
    orderTime: orderTime ?? this.orderTime,
    estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    notes: notes ?? this.notes,
    acceptedTime: acceptedTime ?? this.acceptedTime,
    readyTime: readyTime ?? this.readyTime,
    deliveredTime: deliveredTime ?? this.deliveredTime,
    cancelledTime: cancelledTime ?? this.cancelledTime,
    cancelReason: cancelReason ?? this.cancelReason,
  );
}

// class _OrderStep {
//   final String label;
//   final IconData icon;
//   final bool isActive;
//   final bool isDone;
//   final String? time;
//   const _OrderStep({
//     required this.label,
//     required this.icon,
//     required this.isActive,
//     required this.isDone,
//     this.time,
//   });
// }

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class BusinessStore {
  final String id, name, category, ownerName, phone, email, address;
  final double rating;
  final int totalOrders;
  bool isOpen;
  final String openingTime, closingTime;

  BusinessStore({
    required this.id,
    required this.name,
    required this.category,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
    required this.totalOrders,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });

  BusinessStore copyWith({
    String? id,
    String? name,
    String? category,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    double? rating,
    int? totalOrders,
    bool? isOpen,
    String? openingTime,
    String? closingTime,
  }) => BusinessStore(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    ownerName: ownerName ?? this.ownerName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    rating: rating ?? this.rating,
    totalOrders: totalOrders ?? this.totalOrders,
    isOpen: isOpen ?? this.isOpen,
    openingTime: openingTime ?? this.openingTime,
    closingTime: closingTime ?? this.closingTime,
  );
}

class BusinessStats {
  final int todayOrders,
      pendingOrders,
      preparingOrders,
      readyOrders,
      totalOrders;
  final double todayRevenue, totalRevenue, averageOrderValue;
  const BusinessStats({
    required this.todayOrders,
    required this.todayRevenue,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageOrderValue,
  });
}
