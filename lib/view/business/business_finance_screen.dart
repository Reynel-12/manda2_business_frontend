import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BusinessFinanceScreen extends StatefulWidget {
  const BusinessFinanceScreen({super.key});

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

  String _selectedPeriod = 'Esta Semana';
  List<String> _periods = [
    'Esta Semana',
    'Semana Pasada',
    'Este Mes',
    'Mes Pasado',
    'Este Año',
  ];

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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _calculateSummary();

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
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final summaryCrossCount = isDesktop
        ? 4
        : isTablet
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Finanzas'),
        backgroundColor: const Color(0xFF05386B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 64
                : isTablet
                ? 32
                : 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 32),
              _buildSummaryGrid(summaryCrossCount),
              const SizedBox(height: 32),
              _buildSalesChart(),
              const SizedBox(height: 32),
              _buildCommissionInfo(),
              const SizedBox(height: 32),
              _buildSettlements(isDesktop || isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedPeriod,
      items: _periods
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
      onChanged: (v) => setState(() => _selectedPeriod = v!),
      decoration: InputDecoration(
        labelText: 'Período',
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildSummaryGrid(int crossCount) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        _buildSummaryCard(
          'Ventas Totales',
          _financialSummary.totalSales,
          Icons.trending_up,
          const Color(0xFF05386B),
        ),
        _buildSummaryCard(
          'Comisión (10%)',
          _financialSummary.commission,
          Icons.percent,
          const Color(0xFFFF6B00),
        ),
        _buildSummaryCard(
          'Monto Neto',
          _financialSummary.netAmount,
          Icons.account_balance_wallet,
          Colors.green,
        ),
        _buildSummaryCard(
          'Pendiente Liquidar',
          _financialSummary.pendingSettlements,
          Icons.pending,
          Colors.orange,
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(color: Colors.grey[600])),
            Text(
              _currencyFormat.format(amount),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ventas Semanales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: _weeklySalesData,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.amount,
                    color: const Color(0xFF05386B),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                color: Color(0xFF05386B),
              ),
            ),
            const SizedBox(height: 16),
            const Text('10% sobre ventas, cubre plataforma y soporte.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettlements(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Liquidaciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF05386B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.request_page),
                  label: const Text('Solicitar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: isWide ? _buildSettlementsTable() : _buildSettlementsList(),
        ),
      ],
    );
  }

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
