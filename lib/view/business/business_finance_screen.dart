import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _C {
  static const primary = Color(0xFF0F2B46);
  static const primaryLight = Color(0xFF2C5B82);
  static const accent = Color(0xFFE96A2C);
  static const background = Color(0xFFF5F7FA);
  static const surface = Colors.white;
  static const surfaceSoft = Color(0xFFF9FBFD);
  static const textPrimary = Color(0xFF132238);
  static const textMuted = Color(0xFF8695A5);
  static const divider = Color(0xFFE7EDF2);
}

class BusinessFinanceScreen extends StatefulWidget {
  final bool isTab;
  const BusinessFinanceScreen({super.key, this.isTab = false});

  @override
  State<BusinessFinanceScreen> createState() => _BusinessFinanceScreenState();
}

class _BusinessFinanceScreenState extends State<BusinessFinanceScreen>
    with TickerProviderStateMixin {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  String _selectedPeriod = 'Hoy';
  final List<String> _periods = [
    'Hoy',
    'Esta semana',
    'Semana pasada',
    'Este mes',
    'Mes pasado',
    'Este año',
    'Personalizado',
  ];
  DateTimeRange? _customRange;

  // Datos de ejemplo para gráfico de ventas semanales
  List<SalesData> _weeklySalesData = [];

  // Datos de ejemplo para liquidaciones
  List<Settlement> _settlements = [];

  // Resumen financiero
  FinancialSummary _financialSummary = FinancialSummary(
    totalSales: 0,
    commission: 0,
    netAmount: 0,
    pendingSettlements: 0,
  );

  int? _selectedChartIndex;
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _calculateSummary();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      activationMode: ActivationMode.singleTap,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // Tus datos de ejemplo (mantengo igual)
    final now = DateTime.now();
    _weeklySalesData = [
      SalesData(
        day: 'Lun',
        date: now.subtract(const Duration(days: 6)),
        amount: 125000,
      ),
      SalesData(
        day: 'Mar',
        date: now.subtract(const Duration(days: 5)),
        amount: 98000,
      ),
      SalesData(
        day: 'Mié',
        date: now.subtract(const Duration(days: 4)),
        amount: 150000,
      ),
      SalesData(
        day: 'Jue',
        date: now.subtract(const Duration(days: 3)),
        amount: 175000,
      ),
      SalesData(
        day: 'Vie',
        date: now.subtract(const Duration(days: 2)),
        amount: 210000,
      ),
      SalesData(
        day: 'Sáb',
        date: now.subtract(const Duration(days: 1)),
        amount: 190000,
      ),
      SalesData(day: 'Dom', date: now, amount: 145000),
    ];

    _settlements = [
      Settlement(
        id: 'SET001',
        date: now.subtract(const Duration(days: 2)),
        amount: 450000,
        status: SettlementStatus.completed,
      ),
      Settlement(
        id: 'SET002',
        date: now.subtract(const Duration(days: 9)),
        amount: 380000,
        status: SettlementStatus.completed,
      ),
      Settlement(
        id: 'SET003',
        date: now.add(const Duration(days: 2)),
        amount: 520000,
        status: SettlementStatus.pending,
      ),
      Settlement(
        id: 'SET004',
        date: now.add(const Duration(days: 5)),
        amount: 480000,
        status: SettlementStatus.processing,
      ),
    ];
  }

  void _calculateSummary() {
    final totalSales = _weeklySalesData.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final commission = totalSales * 0.10;
    final netAmount = totalSales - commission;
    final pending = _settlements
        .where((s) => s.status == SettlementStatus.pending)
        .fold(0.0, (sum, item) => sum + item.amount);

    setState(() {
      _financialSummary = FinancialSummary(
        totalSales: totalSales,
        commission: commission,
        netAmount: netAmount,
        pendingSettlements: pending,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final isDesktop = size.width >= 1200;
    final summaryCrossCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;
    final horizontal = isDesktop
        ? 56.0
        : isTablet
        ? 32.0
        : 16.0;

    return Scaffold(
      backgroundColor: _C.background,
      appBar: AppBar(
        title: const Text(
          'Finanzas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _C.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: _C.surface,
        foregroundColor: _C.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.download_rounded),
        //     onPressed: () {},
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _C.divider),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 32),
              _buildSummaryGrid(summaryCrossCount, 84.0),
              const SizedBox(height: 32),
              _buildSalesChart(),
              const SizedBox(height: 32),
              _buildCommissionInfo(),
              // const SizedBox(height: 32),
              // _buildSettlements(isDesktop || isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedPeriod,
                items: _periods
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPeriod = v!),
                decoration: InputDecoration(
                  labelText: 'Período',
                  labelStyle: const TextStyle(color: _C.textMuted),
                  prefixIcon: const Icon(
                    Icons.calendar_today_rounded,
                    color: _C.primaryLight,
                  ),
                  filled: true,
                  fillColor: _C.surfaceSoft,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: _pickCustomRange,
              icon: const Icon(Icons.date_range_rounded),
              style: IconButton.styleFrom(
                backgroundColor: _C.surfaceSoft,
                foregroundColor: _C.primary,
              ),
            ),
          ],
        ),
        if (_customRange != null) ...[
          const SizedBox(height: 8),
          Text(
            'Rango: ${_dateFormat.format(_customRange!.start)} - ${_dateFormat.format(_customRange!.end)}',
            style: const TextStyle(
              color: _C.textMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          _customRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now),
      helpText: 'Selecciona un periodo',
      saveText: 'Aplicar',
    );
    if (picked == null) return;
    setState(() {
      _customRange = picked;
      _selectedPeriod = 'Personalizado';
    });
  }

  Widget _surfaceCard({required Widget child}) {
    return Card(
      elevation: 0,
      color: _C.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _C.divider),
      ),
      child: child,
    );
  }

  Widget _buildSummaryGrid(int crossCount, double cardHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 600;
    final double horizontal = isDesktop
        ? 56.0
        : isTablet
        ? 32.0
        : 16.0;

    final double gridWidth = screenWidth - (horizontal * 2);
    final double columnWidth = (gridWidth - (crossCount - 1) * 16) / crossCount;
    final double aspectRatio = columnWidth / cardHeight;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: aspectRatio,
      children: [
        _buildSummaryCard(
          'Ventas totales',
          _financialSummary.totalSales,
          Icons.trending_up,
          _C.primary,
        ),
        _buildSummaryCard(
          'Comisión (10%)',
          _financialSummary.commission,
          Icons.percent,
          _C.accent,
        ),
        _buildSummaryCard(
          'Monto neto',
          _financialSummary.netAmount,
          Icons.account_balance_wallet,
          const Color(0xFF10B981), // Emerald green
        ),
        _buildSummaryCard(
          'Pendiente liquidar',
          _financialSummary.pendingSettlements,
          Icons.pending,
          const Color(0xFFF59E0B), // Warm orange/amber
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.divider),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: color),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 22, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _C.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _currencyFormat.format(amount),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return _surfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ventas semanales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _C.textPrimary,
                  ),
                ),
                if (_selectedChartIndex != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedChartIndex = null),
                    icon: const Icon(Icons.clear_rounded, size: 16),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: _C.textMuted,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(
                    color: _C.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  axisLine: const AxisLine(color: _C.divider),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: _currencyFormat,
                  labelStyle: const TextStyle(
                    color: _C.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: const MajorGridLines(
                    color: _C.divider,
                    width: 1,
                    dashArray: <double>[4, 4],
                  ),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: _weeklySalesData,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.amount,
                    color: _C.primary,
                    enableTooltip: true,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    selectionBehavior: SelectionBehavior(
                      enable: true,
                      unselectedOpacity: 0.4,
                      selectedColor: _C.accent,
                    ),
                    onPointTap: (ChartPointDetails details) {
                      if (details.pointIndex != null) {
                        setState(() {
                          if (_selectedChartIndex == details.pointIndex) {
                            _selectedChartIndex = null;
                          } else {
                            _selectedChartIndex = details.pointIndex;
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _selectedChartIndex != null
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _C.surfaceSoft,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _C.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _C.accent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.insights_rounded,
                              size: 20,
                              color: _C.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detalle de selección: ${_weeklySalesData[_selectedChartIndex!].day}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: _C.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _currencyFormat.format(
                                    _weeklySalesData[_selectedChartIndex!]
                                        .amount,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _C.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 14,
                            color: _C.textMuted.withOpacity(0.7),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Toca una barra del gráfico para ver detalles exactos',
                            style: TextStyle(
                              color: _C.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionInfo() {
    return _surfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comisión',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _C.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text('10% sobre ventas, cubre plataforma y soporte.'),
          ],
        ),
      ),
    );
  }

  // Widget _buildSettlements(bool isWide) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       ConstrainedBox(
  //         constraints: const BoxConstraints(maxWidth: 800),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Flexible(
  //               child: Text(
  //                 'Liquidaciones',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: _C.textPrimary,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Flexible(
  //               child: ElevatedButton.icon(
  //                 onPressed: () {},
  //                 icon: const Icon(Icons.request_page),
  //                 label: const Text('Solicitar'),
  //                 style: ElevatedButton.styleFrom(backgroundColor: _C.accent),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       _surfaceCard(
  //         child: isWide ? _buildSettlementsTable() : _buildSettlementsList(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSettlementsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Monto')),
          DataColumn(label: Text('Estado')),
        ],
        rows: _settlements
            .map(
              (s) => DataRow(
                cells: [
                  DataCell(Text(s.id)),
                  DataCell(Text(_dateFormat.format(s.date))),
                  DataCell(Text(_currencyFormat.format(s.amount))),
                  DataCell(
                    Chip(
                      label: Text(_getStatusText(s.status)),
                      backgroundColor: _getStatusColor(s.status),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSettlementsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _settlements.length,
      itemBuilder: (context, i) {
        final s = _settlements[i];
        return ListTile(
          title: Text(s.id),
          subtitle: Text(_dateFormat.format(s.date)),
          trailing: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.end,
            spacing: 4,
            children: [
              Text(_currencyFormat.format(s.amount)),
              Chip(
                label: Text(_getStatusText(s.status)),
                backgroundColor: _getStatusColor(s.status),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.completed:
        return 'Completado';
      case SettlementStatus.processing:
        return 'Procesando';
      case SettlementStatus.pending:
        return 'Pendiente';
    }
  }

  Color _getStatusColor(SettlementStatus status) {
    switch (status) {
      case SettlementStatus.completed:
        return Colors.green;
      case SettlementStatus.processing:
        return Colors.orange;
      case SettlementStatus.pending:
        return Colors.blue;
    }
  }
}

// Mantén tus modelos FinancialSummary, Settlement, SalesData, SettlementStatus
class FinancialSummary {
  final double totalSales, commission, netAmount, pendingSettlements;
  const FinancialSummary({
    required this.totalSales,
    required this.commission,
    required this.netAmount,
    required this.pendingSettlements,
  });
}

class Settlement {
  final String id;
  final DateTime date;
  final double amount;
  final SettlementStatus status;
  const Settlement({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class SalesData {
  final String day;
  final DateTime date;
  final double amount;
  const SalesData({
    required this.day,
    required this.date,
    required this.amount,
  });
}

enum SettlementStatus { completed, processing, pending }
