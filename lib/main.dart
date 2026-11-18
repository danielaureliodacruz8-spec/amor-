import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const AmorVendasApp());

const _plum = Color(0xFF78566E);
const _rose = Color(0xFFB9778F);
const _roseLight = Color(0xFFF6E9EE);
const _lavender = Color(0xFFECE8F4);
const _cream = Color(0xFFFFFBF8);
const _ink = Color(0xFF392F38);
const _muted = Color(0xFF817780);

String _money(num value) => 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
String _two(int value) => value.toString().padLeft(2, '0');

String _dateTime(DateTime value) {
  final local = value.toLocal();
  return '${_two(local.day)}/${_two(local.month)}/${local.year} às ${_two(local.hour)}:${_two(local.minute)}';
}

double _parseMoney(String value) =>
    double.tryParse(value.trim().replaceAll('R\$', '').replaceAll(' ', '').replaceAll(',', '.')) ?? 0;

class AmorVendasApp extends StatelessWidget {
  const AmorVendasApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Amor — Vendas da Cássia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: _cream,
          colorScheme: ColorScheme.fromSeed(seedColor: _plum, surface: _cream),
          fontFamily: 'Roboto',
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(color: _muted),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFEDE4E9))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: _rose, width: 1.4)),
          ),
        ),
        home: const AmorSplashScreen(),
      );
}


class AmorSplashScreen extends StatefulWidget {
  const AmorSplashScreen({super.key});

  @override
  State<AmorSplashScreen> createState() => _AmorSplashScreenState();
}

class _AmorSplashScreenState extends State<AmorSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..repeat(reverse: true);

  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _fade.forward();
    Future<void>.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, animation, secondaryAnimation) => const SalesHome(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 550),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF32172F), Color(0xFF713B62), Color(0xFFB56F91)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: -85, right: -65, child: _glow(230, 0.10)),
            Positioned(bottom: -105, left: -75, child: _glow(270, 0.09)),
            Positioned(top: 105, left: 35, child: _sparkle(18)),
            Positioned(top: 175, right: 42, child: _sparkle(13)),
            Positioned(bottom: 155, left: 55, child: _sparkle(12)),
            FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) {
                      final scale = 0.96 + (_pulse.value * 0.09);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 214,
                          height: 214,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.30),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB8D2).withValues(alpha: 0.22),
                                blurRadius: 48,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 166,
                              height: 166,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFFFD9E7), Color(0xFFE98BAF)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.16),
                                    blurRadius: 28,
                                    offset: const Offset(0, 13),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFF9B315F),
                                size: 91,
                                shadows: [
                                  Shadow(color: Color(0x66FFFFFF), blurRadius: 15),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 42),
                  const Text(
                    'CÁSSIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      letterSpacing: 5.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Deus te ama.',
                    style: TextStyle(
                      color: Color(0xFFFFE8F0),
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'E seu marido Daniel também! ❤️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 42,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD8E6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Feito com amor, especialmente para você',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFEED9E5),
                      fontSize: 12,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const Spacer(flex: 3),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 34),
                    child: Text(
                      'AMOR VENDAS',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 10,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _glow(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFC6DC).withValues(alpha: opacity),
        ),
      );

  Widget _sparkle(double size) => Icon(
        Icons.auto_awesome,
        size: size,
        color: const Color(0xFFFFE5EF).withValues(alpha: 0.75),
      );
}

class SalesHome extends StatefulWidget {
  const SalesHome({super.key});

  @override
  State<SalesHome> createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  final SharedPreferencesAsync _storage = SharedPreferencesAsync();
  final TextEditingController _search = TextEditingController();
  List<Map<String, dynamic>> _sales = [];
  int _tab = 0;
  DateTime _now = DateTime.now();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    Future<void>.delayed(const Duration(minutes: 1), _tick);
  }

  void _tick() {
    if (!mounted) return;
    setState(() => _now = DateTime.now());
    Future<void>.delayed(const Duration(minutes: 1), _tick);
  }

  Future<void> _load() async {
    final saved = await _storage.getStringList('sales') ?? [];
    if (!mounted) return;
    setState(() {
      _sales = saved.map((item) => Map<String, dynamic>.from(jsonDecode(item))).toList();
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await _storage.setStringList('sales', _sales.map(jsonEncode).toList());
  }

  List<String> get _customers {
    final values = <String, String>{};
    for (final sale in _sales) {
      final name = (sale['customer'] ?? '').toString().trim();
      if (name.isNotEmpty) values.putIfAbsent(name.toLowerCase(), () => name);
    }
    return values.values.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  List<Map<String, dynamic>> _customerSales(String customer) => _sales
      .where((sale) => (sale['customer'] ?? '').toString().toLowerCase() == customer.toLowerCase())
      .toList()
    ..sort((a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String));

  double _saleTotal(Map<String, dynamic> sale) => (sale['total'] as num).toDouble();

  double _customerDue(String customer) => _customerSales(customer)
      .where((sale) => sale['status'] == 'open')
      .fold(0, (sum, sale) => sum + _saleTotal(sale));

  double get _openBalance => _sales
      .where((sale) => sale['status'] == 'open')
      .fold(0, (sum, sale) => sum + _saleTotal(sale));

  double get _todaySales => _sales.where((sale) {
    final date = DateTime.tryParse(sale['createdAt'] as String)?.toLocal();
    return date != null && date.year == _now.year && date.month == _now.month && date.day == _now.day;
  }).fold(0, (sum, sale) => sum + _saleTotal(sale));

  Future<void> _newSale({String? customer}) async {
    final sale = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cream,
      builder: (_) => NewSaleSheet(customers: _customers, initialCustomer: customer),
    );
    if (sale == null || !mounted) return;
    final entered = (sale['customer'] as String).trim().replaceAll(RegExp(r'\s+'), ' ');
    final matchingCustomers = _customers.where((name) => name.toLowerCase() == entered.toLowerCase()).toList();
    final canonical = matchingCustomers.isEmpty ? null : matchingCustomers.first;
    sale['customer'] = canonical ?? entered;
    sale['id'] = DateTime.now().microsecondsSinceEpoch.toString();
    sale['createdAt'] = DateTime.now().toIso8601String();
    setState(() => _sales.add(sale));
    await _persist();
    _toast('Venda de ${sale['customer']} salva no histórico.');
  }

  Future<void> _markPaid(String id) async {
    final index = _sales.indexWhere((sale) => sale['id'] == id);
    if (index < 0) return;
    setState(() => _sales[index]['status'] = 'paid');
    await _persist();
    if (mounted) _toast('Venda marcada como paga.');
  }

  Future<void> _report(String customer) async {
    final sales = _customerSales(customer);
    if (sales.isEmpty) return;
    final allTotal = sales.fold<double>(0, (sum, sale) => sum + _saleTotal(sale));
    final due = sales.where((sale) => sale['status'] == 'open').fold<double>(0, (sum, sale) => sum + _saleTotal(sale));
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(34),
      build: (_) => [
        pw.Text('RELATÓRIO DE COMPRAS', style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#78566E'))),
        pw.SizedBox(height: 6),
        pw.Text('Cliente: $customer', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.Text('Gerado em: ${_dateTime(DateTime.now())}', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 18),
        ...sales.reversed.map((sale) {
          final date = DateTime.tryParse(sale['createdAt'] as String) ?? DateTime.now();
          final items = List<Map<String, dynamic>>.from(sale['items'] as List);
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 14),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#E8DDE4')), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(_dateTime(date), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(sale['status'] == 'open' ? 'EM ABERTO' : 'PAGO', style: pw.TextStyle(fontSize: 9, color: PdfColor.fromHex(sale['status'] == 'open' ? '#A95E79' : '#55816D'))),
              ]),
              pw.SizedBox(height: 7),
              ...items.map((item) {
                final quantity = (item['quantity'] as num).toInt();
                final unit = (item['unitPrice'] as num).toDouble();
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Expanded(child: pw.Text('$quantity × ${item['name']}  (${_money(unit)} cada)')),
                    pw.Text(_money(quantity * unit)),
                  ]),
                );
              }),
              pw.Divider(),
              pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('Total desta compra: ${_money(_saleTotal(sale))}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ]),
          );
        }),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1.2),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Total das compras'), pw.Text(_money(allTotal), style: pw.TextStyle(fontWeight: pw.FontWeight.bold))]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('VALOR EM ABERTO'), pw.Text(_money(due), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#A95E79')))]),
      ],
    ));
    await Printing.layoutPdf(name: 'Relatorio_${customer.replaceAll(' ', '_')}', onLayout: (_) async => pdf.save());
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _plum))
              : Column(children: [
                  _header(),
                  Expanded(child: _tab == 0 ? _dashboard() : _tab == 1 ? _customersPage() : _reportsPage()),
                ]),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: _lavender,
          selectedIndex: _tab,
          onDestinationSelected: (value) => setState(() => _tab = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people_rounded), label: 'Clientes'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Relatórios'),
          ],
        ),
      );

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: _roseLight),
            child: const Icon(Icons.favorite_rounded, color: _plum),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_tab == 0 ? 'Olá, Cássia, boas vendas!' : _tab == 1 ? 'Seus clientes' : 'Relatórios', style: const TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w700)),
            Text(_dateTime(_now), style: const TextStyle(color: _muted, fontSize: 12)),
          ])),
          IconButton.filledTonal(onPressed: () => _newSale(), tooltip: 'Adicionar venda', icon: const Icon(Icons.add_shopping_cart_rounded, color: _plum)),
        ]),
      );

  Widget _dashboard() {
    final recent = _sales.toList()..sort((a, b) => (b['createdAt'] as String).compareTo(a['createdAt'] as String));
    return ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 26), children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [_plum, _rose], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(26)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Um carinho em cada venda', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          const Text('Suas vendas,\ncom tudo organizado.', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: () => _newSale(), icon: const Icon(Icons.add), label: const Text('Adicionar uma venda'), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _plum)),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _metric('Vendido hoje', _money(_todaySales), Icons.wb_sunny_outlined, _lavender)),
        const SizedBox(width: 10),
        Expanded(child: _metric('Em aberto', _money(_openBalance), Icons.favorite_border, _roseLight)),
      ]),
      const SizedBox(height: 10),
      _metric('Clientes cadastrados', '${_customers.length}', Icons.people_outline, const Color(0xFFE8F0EA)),
      const SizedBox(height: 22),
      _sectionTitle('Vendas recentes', action: 'Ver clientes', onPressed: () => setState(() => _tab = 1)),
      const SizedBox(height: 8),
      if (recent.isEmpty)
        _emptyCard('As vendas aparecerão aqui', 'Toque em “Adicionar uma venda” para começar.')
      else
        ...recent.take(5).map((sale) => _saleCard(sale)),
    ]);
  }

  Widget _metric(String title, String value, IconData icon, Color color) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF0E8EC))),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: _plum, size: 21)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: _muted, fontSize: 11)), const SizedBox(height: 3), Text(value, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700, fontSize: 15))])),
        ]),
      );

  Widget _customersPage() {
    final query = _search.text.trim().toLowerCase();
    final customers = _customers.where((name) => name.toLowerCase().contains(query)).toList();
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(18, 10, 18, 8), child: TextField(controller: _search, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar pelo nome da pessoa'))),
      Expanded(child: customers.isEmpty
          ? _emptyCard('Ainda não há clientes', 'O nome aparecerá aqui depois que Cássia registrar uma venda.')
          : ListView.builder(padding: const EdgeInsets.fromLTRB(18, 4, 18, 24), itemCount: customers.length, itemBuilder: (_, index) {
              final customer = customers[index];
              final sales = _customerSales(customer);
              final due = _customerDue(customer);
              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFF0E8EC))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  leading: CircleAvatar(backgroundColor: _roseLight, foregroundColor: _plum, child: Text(customer.substring(0, 1).toUpperCase())),
                  title: Text(customer, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700)),
                  subtitle: Text('${sales.length} ${sales.length == 1 ? 'compra' : 'compras'}  •  ${due > 0 ? 'Deve ${_money(due)}' : 'Sem valores em aberto'}', style: const TextStyle(color: _muted, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, color: _muted),
                  onTap: () => _showCustomer(customer),
                ),
              );
            })),
    ]);
  }

  Widget _reportsPage() {
    final debtors = _customers.where((name) => _customerDue(name) > 0).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 26), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(20)), child: const Text('Relatórios por cliente mostram cada mercadoria, a data da compra, o total e o que ainda está em aberto.', style: TextStyle(color: _ink, height: 1.35))),
      const SizedBox(height: 18),
      _sectionTitle('Valores em aberto'),
      const SizedBox(height: 8),
      if (debtors.isEmpty)
        _emptyCard('Tudo em dia por aqui', 'Quando houver uma venda em aberto, o cliente aparecerá nesta lista.')
      else
        ...debtors.map((name) => Card(
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFF0E8EC))),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: _roseLight, child: Icon(Icons.receipt_long, color: _plum)),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: _ink)),
            subtitle: Text('Deve ${_money(_customerDue(name))}', style: const TextStyle(color: _rose, fontWeight: FontWeight.w600)),
            trailing: IconButton(tooltip: 'Gerar relatório', onPressed: () => _report(name), icon: const Icon(Icons.picture_as_pdf_outlined, color: _plum)),
            onTap: () => _showCustomer(name),
          ),
        )),
      if (_customers.isNotEmpty) ...[
        const SizedBox(height: 10),
        _sectionTitle('Relatório de qualquer cliente'),
        const SizedBox(height: 7),
        ..._customers.map((name) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: const Icon(Icons.person_outline, color: _plum),
          title: Text(name),
          trailing: TextButton.icon(onPressed: () => _report(name), icon: const Icon(Icons.print_outlined), label: const Text('Relatório')),
        )),
      ],
    ]);
  }

  Widget _saleCard(Map<String, dynamic> sale) {
    final date = DateTime.tryParse(sale['createdAt'] as String) ?? DateTime.now();
    final items = List<Map<String, dynamic>>.from(sale['items'] as List);
    final first = items.isEmpty ? '' : items.first['name'].toString();
    final summary = items.length > 1 ? '$first e mais ${items.length - 1}' : first;
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17), side: const BorderSide(color: Color(0xFFF0E8EC))),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: _lavender, child: Icon(Icons.shopping_bag_outlined, color: _plum)),
        title: Text('${sale['customer']}  •  ${_money(_saleTotal(sale))}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink)),
        subtitle: Text('$summary\n${_dateTime(date)}  •  ${sale['status'] == 'open' ? 'Em aberto' : 'Pago'}', style: const TextStyle(color: _muted, fontSize: 11, height: 1.4)),
        isThreeLine: true,
        onTap: () => _showCustomer(sale['customer'].toString()),
      ),
    );
  }

  Widget _sectionTitle(String title, {String? action, VoidCallback? onPressed}) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700, fontSize: 16)),
        if (action != null) TextButton(onPressed: onPressed, child: Text(action, style: const TextStyle(color: _plum))),
      ]);

  Widget _emptyCard(String title, String subtitle) => Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF0E8EC))),
        child: Column(children: [const Icon(Icons.spa_outlined, color: _rose, size: 30), const SizedBox(height: 8), Text(title, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: _muted, fontSize: 12))]),
      );

  Future<void> _showCustomer(String customer) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cream,
      builder: (sheetContext) => StatefulBuilder(builder: (context, refreshSheet) {
        final currentSales = _customerSales(customer);
        final due = _customerDue(customer);
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .88,
            child: Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(20, 15, 20, 8), child: Row(children: [
                CircleAvatar(backgroundColor: _roseLight, child: Text(customer.substring(0, 1).toUpperCase(), style: const TextStyle(color: _plum, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(customer, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _ink)), Text(due > 0 ? 'Em aberto: ${_money(due)}' : 'Sem valores em aberto', style: const TextStyle(color: _muted, fontSize: 12))])),
                IconButton(onPressed: () => _report(customer), tooltip: 'Gerar relatório', icon: const Icon(Icons.picture_as_pdf_outlined, color: _plum)),
              ])),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5), child: FilledButton.icon(onPressed: () { Navigator.pop(sheetContext); _newSale(customer: customer); }, icon: const Icon(Icons.add), label: const Text('Adicionar outra compra'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(46), backgroundColor: _plum))),
              Expanded(child: currentSales.isEmpty
                  ? _emptyCard('Sem compras registradas', 'Adicione uma venda para começar o histórico.')
                  : ListView.builder(padding: const EdgeInsets.fromLTRB(18, 8, 18, 24), itemCount: currentSales.length, itemBuilder: (context, index) {
                      final sale = currentSales[index];
                      final items = List<Map<String, dynamic>>.from(sale['items'] as List);
                      final date = DateTime.tryParse(sale['createdAt'] as String) ?? DateTime.now();
                      return Card(color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFF0E8EC))), child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [Expanded(child: Text(_dateTime(date), style: const TextStyle(color: _muted, fontSize: 12))), _statusChip(sale['status'] == 'open')]),
                        const Divider(height: 18),
                        ...items.map((item) {
                          final qty = (item['quantity'] as num).toInt();
                          final unit = (item['unitPrice'] as num).toDouble();
                          return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [Expanded(child: Text('$qty × ${item['name']}', style: const TextStyle(color: _ink))), Text(_money(qty * unit), style: const TextStyle(fontWeight: FontWeight.w600, color: _ink))]));
                        }),
                        const Divider(height: 16),
                        Row(children: [const Expanded(child: Text('Total da compra', style: TextStyle(fontWeight: FontWeight.w700, color: _ink))), Text(_money(_saleTotal(sale)), style: const TextStyle(fontWeight: FontWeight.w700, color: _plum))]),
                        if (sale['status'] == 'open') Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () async { await _markPaid(sale['id'].toString()); refreshSheet(() {}); }, icon: const Icon(Icons.check_circle_outline), label: const Text('Marcar como paga'))),
                      ])));
                    })),
              Padding(padding: const EdgeInsets.fromLTRB(18, 4, 18, 12), child: OutlinedButton.icon(onPressed: () => _report(customer), icon: const Icon(Icons.print_outlined), label: const Text('Gerar relatório de compras e saldo'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), foregroundColor: _plum))),
            ]),
          ),
        );
      }),
    );
  }

  Widget _statusChip(bool open) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: open ? _roseLight : const Color(0xFFE8F0EA), borderRadius: BorderRadius.circular(30)), child: Text(open ? 'Em aberto' : 'Pago', style: TextStyle(color: open ? _rose : const Color(0xFF557B68), fontSize: 11, fontWeight: FontWeight.w600)));
}

class _SaleLineDraft {
  final name = TextEditingController();
  final quantity = TextEditingController(text: '1');
  final price = TextEditingController();
  void dispose() { name.dispose(); quantity.dispose(); price.dispose(); }
}

class NewSaleSheet extends StatefulWidget {
  const NewSaleSheet({super.key, required this.customers, this.initialCustomer});
  final List<String> customers;
  final String? initialCustomer;

  @override
  State<NewSaleSheet> createState() => _NewSaleSheetState();
}

class _NewSaleSheetState extends State<NewSaleSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _customer;
  final List<_SaleLineDraft> _lines = [_SaleLineDraft()];
  String _status = 'open';
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _customer = TextEditingController(text: widget.initialCustomer ?? '');
    _date = DateTime.now();
  }

  double get _total => _lines.fold(0, (sum, line) => sum + (_parseMoney(line.price.text) * (int.tryParse(line.quantity.text) ?? 0)));

  @override
  void dispose() {
    _customer.dispose();
    for (final line in _lines) { line.dispose(); }
    super.dispose();
  }

  void _addLine() => setState(() => _lines.add(_SaleLineDraft()));

  void _removeLine(int index) {
    if (_lines.length == 1) return;
    setState(() { _lines.removeAt(index).dispose(); });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final items = _lines.map((line) => {
      'name': line.name.text.trim(),
      'quantity': int.parse(line.quantity.text.trim()),
      'unitPrice': _parseMoney(line.price.text),
    }).toList();
    Navigator.pop(context, {
      'customer': _customer.text.trim(),
      'items': items,
      'total': _total,
      'status': _status,
      'createdAt': _date.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .94,
          child: Form(key: _formKey, child: Column(children: [
            Padding(padding: const EdgeInsets.fromLTRB(20, 16, 14, 8), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Nova venda', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: _ink)), const SizedBox(height: 3), Text(_dateTime(_date), style: const TextStyle(color: _muted, fontSize: 12))])), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))])),
            Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 18), children: [
              TextFormField(controller: _customer, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Nome da pessoa', prefixIcon: Icon(Icons.person_outline), hintText: 'Ex.: Ana Souza'), validator: (value) => value == null || value.trim().isEmpty ? 'Informe o nome da pessoa.' : null),
              const SizedBox(height: 18),
              Row(children: [const Expanded(child: Text('Mercadorias', style: TextStyle(fontSize: 16, color: _ink, fontWeight: FontWeight.w700))), TextButton.icon(onPressed: _addLine, icon: const Icon(Icons.add_circle_outline), label: const Text('Adicionar mais'))]),
              const SizedBox(height: 4),
              ...List.generate(_lines.length, (index) => _lineCard(index)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Pagamento', prefixIcon: Icon(Icons.payments_outlined)),
                items: const [DropdownMenuItem(value: 'open', child: Text('Em aberto (fiado)')), DropdownMenuItem(value: 'paid', child: Text('Já pago'))],
                onChanged: (value) => setState(() => _status = value ?? 'open'),
              ),
              const SizedBox(height: 14),
              Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(18)), child: Row(children: [const Expanded(child: Text('Valor total', style: TextStyle(color: _ink, fontWeight: FontWeight.w700))), Text(_money(_total), style: const TextStyle(color: _plum, fontSize: 20, fontWeight: FontWeight.w700))])),
            ])),
            Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 16), child: FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: const Text('Salvar venda'), style: FilledButton.styleFrom(backgroundColor: _plum, minimumSize: const Size.fromHeight(52)))),
          ])),
        ),
      );

  Widget _lineCard(int index) {
    final line = _lines[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFF0E8EC))),
      child: Column(children: [
        Row(children: [Expanded(child: Text('Mercadoria ${index + 1}', style: const TextStyle(color: _plum, fontWeight: FontWeight.w700, fontSize: 12))), if (_lines.length > 1) IconButton(visualDensity: VisualDensity.compact, onPressed: () => _removeLine(index), icon: const Icon(Icons.delete_outline, color: _muted, size: 20))]),
        TextFormField(controller: line.name, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(labelText: 'O que vendeu?', hintText: 'Ex.: Calça'), validator: (value) => value == null || value.trim().isEmpty ? 'Informe a mercadoria.' : null, onChanged: (_) => setState(() {})),
        const SizedBox(height: 9),
        Row(children: [
          SizedBox(width: 100, child: TextFormField(controller: line.quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade'), validator: (value) => (int.tryParse(value ?? '') ?? 0) < 1 ? 'Mín. 1' : null, onChanged: (_) => setState(() {}))),
          const SizedBox(width: 9),
          Expanded(child: TextFormField(controller: line.price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Valor unitário', prefixText: 'R\$ '), validator: (value) => _parseMoney(value ?? '') <= 0 ? 'Informe o valor.' : null, onChanged: (_) => setState(() {}))),
        ]),
      ]),
    );
  }
}

