import 'package:flutter/material.dart';

class DashboardGlobalPage extends StatefulWidget {
  const DashboardGlobalPage({super.key});

  @override
  State<DashboardGlobalPage> createState() => _DashboardGlobalPageState();
}

class _DashboardGlobalPageState extends State<DashboardGlobalPage> {
  final List<_Report> _allReports = _mockReports();

  DateTimeRange? _dateRange;
  final Set<String> _statusFilter = {'Baru', 'Diproses', 'Selesai'};
  final Set<String> _categoryFilter = {'Fisik', 'Verbal', 'Cyber', 'Sosial', 'Lainnya'};
  String _anonymousFilter = 'Semua'; // 'Semua' | 'Ya' | 'Tidak'
  String _evidenceFilter = 'Semua'; // 'Semua' | 'Ya' | 'Tidak'
  String _granularity = 'Harian'; // 'Harian' | 'Mingguan'

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(start: now.subtract(const Duration(days: 29)), end: now);
  }

  List<_Report> get _filtered {
    final range = _dateRange;
    return _allReports.where((r) {
      final inDate = range == null || (r.createdAt.isAfter(range.start.subtract(const Duration(days: 1))) && r.createdAt.isBefore(range.end.add(const Duration(days: 1))));
      final inStatus = _statusFilter.contains(r.status);
      final inCategory = _categoryFilter.contains(r.category);
      final inAnon = _anonymousFilter == 'Semua' || (_anonymousFilter == 'Ya' ? r.anonymous : !r.anonymous);
      final inEvidence = _evidenceFilter == 'Semua' || (_evidenceFilter == 'Ya' ? r.evidenceCount > 0 : r.evidenceCount == 0);
      return inDate && inStatus && inCategory && inAnon && inEvidence;
    }).toList();
  }

  // KPI calculations
  int get _total => _filtered.length;
  int get _baru => _filtered.where((r) => r.status == 'Baru').length;
  int get _diproses => _filtered.where((r) => r.status == 'Diproses').length;
  int get _selesai => _filtered.where((r) => r.status == 'Selesai').length;
  int get _backlog => _baru + _diproses;
  double get _rasioSelesai => _total == 0 ? 0 : _selesai / _total;
  double get _pctEvidence => _total == 0 ? 0 : _filtered.where((r) => r.evidenceCount > 0).length / _total;

  // Effectiveness
  Duration? get _avgResponseTime {
    final list = _filtered.where((r) => r.firstHandledAt != null).map((r) => r.firstHandledAt!.difference(r.createdAt)).toList();
    if (list.isEmpty) return null;
    final sumMs = list.fold<int>(0, (acc, d) => acc + d.inMilliseconds);
    return Duration(milliseconds: (sumMs / list.length).round());
  }

  Duration? get _avgResolutionTime {
    final list = _filtered.where((r) => r.resolvedAt != null).map((r) => r.resolvedAt!.difference(r.createdAt)).toList();
    if (list.isEmpty) return null;
    final sumMs = list.fold<int>(0, (acc, d) => acc + d.inMilliseconds);
    return Duration(milliseconds: (sumMs / list.length).round());
  }

  // Trend data and growth
  Map<String, List<_Point>> get _trendData {
    final range = _dateRange;
    if (range == null) {
      return {'Masuk': const [], 'Selesai': const []};
    }
    final spanDays = range.end.difference(range.start).inDays + 1;
    final bucketCount = _granularity == 'Harian' ? spanDays : (spanDays / 7).ceil();

    List<_Point> buildSeries(bool completed) {
      final List<_Point> points = [];
      for (int i = 0; i < bucketCount; i++) {
        DateTime start = _granularity == 'Harian' ? range.start.add(Duration(days: i)) : range.start.add(Duration(days: i * 7));
        DateTime end = _granularity == 'Harian' ? start : start.add(const Duration(days: 6));
        int count;
        if (!completed) {
          count = _filtered.where((r) => !r.createdAt.isBefore(start) && !r.createdAt.isAfter(end)).length;
        } else {
          count = _filtered.where((r) => r.resolvedAt != null && !r.resolvedAt!.isBefore(start) && !r.resolvedAt!.isAfter(end)).length;
        }
        points.add(_Point(x: i.toDouble(), y: count.toDouble()));
      }
      return points;
    }

    return {
      'Masuk': buildSeries(false),
      'Selesai': buildSeries(true),
    };
  }

  double get _growthVsPrev {
    final range = _dateRange;
    if (range == null) return 0;
    final length = range.end.difference(range.start).inDays + 1;
    final prevStart = range.start.subtract(Duration(days: length));
    final prevEnd = range.start.subtract(const Duration(days: 1));
    final curr = _allReports.where((r) => !r.createdAt.isBefore(range.start) && !r.createdAt.isAfter(range.end)).length;
    final prev = _allReports.where((r) => !r.createdAt.isBefore(prevStart) && !r.createdAt.isAfter(prevEnd)).length;
    if (prev == 0) return curr == 0 ? 0 : 1.0;
    return (curr - prev) / prev;
  }

  Map<String, int> get _categoryCounts {
    final map = <String, int>{'Fisik': 0, 'Verbal': 0, 'Cyber': 0, 'Sosial': 0, 'Lainnya': 0};
    for (final r in _filtered) {
      map[r.category] = (map[r.category] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final trend = _trendData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor Bullying'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7F55B1), Color(0xFFFFDBB6)],
            stops: [0.76, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _filtersBar(context),
                  const SizedBox(height: 16),
                  _kpiGrid(),
                  const SizedBox(height: 16),
                  _trendCard(trend),
                  const SizedBox(height: 16),
                  _distributionRow(),
                  const SizedBox(height: 16),
                  _effectivenessCard(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filtersBar(BuildContext context) {
    String rangeLabel() {
      if (_dateRange == null) return 'Semua waktu';
      final s = _dateRange!.start;
      final e = _dateRange!.end;
      String two(int n) => n.toString().padLeft(2, '0');
      String d(DateTime dt) => '${dt.year}-${two(dt.month)}-${two(dt.day)}';
      return '${d(s)} s/d ${d(e)}';
    }

    return Row(
      children: [
        Expanded(child: _pillButton(icon: Icons.date_range, label: rangeLabel(), onTap: _pickDateRange)),
        const SizedBox(width: 12),
        Expanded(child: _pillButton(icon: Icons.filter_list, label: 'Filter', onTap: _openFiltersDialog)),
      ],
    );
  }

  Widget _kpiGrid() {
    final items = [
      _KpiItem(title: 'Total', value: '$_total'),
      _KpiItem(title: 'Baru', value: '$_baru'),
      _KpiItem(title: 'Diproses', value: '$_diproses'),
      _KpiItem(title: 'Selesai', value: '$_selesai'),
      _KpiItem(title: 'Backlog', value: '$_backlog'),
      _KpiItem(title: 'Rasio Selesai', value: '${(_rasioSelesai * 100).toStringAsFixed(0)}%'),
      _KpiItem(title: '% dgn Bukti', value: '${(_pctEvidence * 100).toStringAsFixed(0)}%'),
    ];
    return _card(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: items.map((i) => _kpiTile(i)).toList(),
      ),
    );
  }

  Widget _trendCard(Map<String, List<_Point>> trend) {
    final growth = _growthVsPrev;
    final growthText = '${(growth * 100).abs().toStringAsFixed(0)}%';
    final growthIcon = growth >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
    final growthColor = growth >= 0 ? const Color(0xFF2E7D32) : const Color(0xFFB00020);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Tren Waktu', style: TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              _segmented(
                options: const ['Harian', 'Mingguan'],
                value: _granularity,
                onChanged: (v) => setState(() => _granularity = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(growthIcon, size: 16, color: growthColor),
              const SizedBox(width: 4),
              Text('Pertumbuhan vs periode sebelumnya: $growthText', style: TextStyle(color: growthColor)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: _LineChart(series: trend, lineColors: const [Color(0xFF2196F3), Color(0xFF2E7D32)]),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              _LegendDot(color: Color(0xFF2196F3), label: 'Masuk'),
              SizedBox(width: 12),
              _LegendDot(color: Color(0xFF2E7D32), label: 'Selesai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _distributionRow() {
    final statusMap = {
      'Baru': _baru,
      'Diproses': _diproses,
      'Selesai': _selesai,
    };
    final categoryMap = _categoryCounts;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Distribusi Status', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                SizedBox(height: 180, child: _DonutChart(data: statusMap, colors: const {
                  'Baru': Color(0xFF2196F3),
                  'Diproses': Color(0xFFFF9800),
                  'Selesai': Color(0xFF2E7D32),
                })),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Distribusi Kategori', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...categoryMap.entries.map((e) => _barRow(label: e.key, value: e.value, maxValue: categoryMap.values.isEmpty ? 1 : (categoryMap.values.reduce((a, b) => a > b ? a : b)))).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _effectivenessCard() {
    String fmt(Duration? d) {
      if (d == null) return '-';
      if (d.inHours < 48) return '${d.inHours} jam';
      return '${(d.inHours / 24).toStringAsFixed(1)} hari';
    }
    return _card(
      child: Row(
        children: [
          Expanded(child: _metricTile(title: 'Rata-rata respon awal', value: fmt(_avgResponseTime))),
          const SizedBox(width: 12),
          Expanded(child: _metricTile(title: 'Rata-rata penyelesaian', value: fmt(_avgResolutionTime))),
        ],
      ),
    );
  }

  // UI helpers
  Widget _pillButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7F55B1)),
            const SizedBox(width: 8),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _kpiTile(_KpiItem item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(item.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF7F55B1))),
        ],
      ),
    );
  }

  Widget _metricTile({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _segmented({required List<String> options, required String value, required ValueChanged<String> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((o) {
          final selected = o == value;
          return GestureDetector(
            onTap: () => onChanged(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF7F55B1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(o, style: TextStyle(color: selected ? Colors.white : const Color(0xFF7F55B1), fontWeight: FontWeight.w700)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _barRow({required String label, required int value, required int maxValue}) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(label, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(height: 14, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(8))),
                FractionallySizedBox(
                  widthFactor: ratio.clamp(0, 1),
                  child: Container(height: 14, decoration: BoxDecoration(color: const Color(0xFFB39DDB), borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 28, child: Text('$value', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initial = _dateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 29)), end: now);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
      helpText: 'Pilih rentang tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _openFiltersDialog() async {
    final tempStatus = {..._statusFilter};
    final tempCategory = {..._categoryFilter};
    String anon = _anonymousFilter;
    String evid = _evidenceFilter;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w700)),
                ...['Baru', 'Diproses', 'Selesai'].map((s) => CheckboxListTile(
                      value: tempStatus.contains(s),
                      onChanged: (v) {
                        if (v == true) {
                          tempStatus.add(s);
                        } else {
                          tempStatus.remove(s);
                        }
                        setState(() {});
                      },
                      title: Text(s),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    )),
                const SizedBox(height: 8),
                const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w700)),
                ...['Fisik', 'Verbal', 'Cyber', 'Sosial', 'Lainnya'].map((s) => CheckboxListTile(
                      value: tempCategory.contains(s),
                      onChanged: (v) {
                        if (v == true) {
                          tempCategory.add(s);
                        } else {
                          tempCategory.remove(s);
                        }
                        setState(() {});
                      },
                      title: Text(s),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    )),
                const SizedBox(height: 8),
                const Text('Ada bukti', style: TextStyle(fontWeight: FontWeight.w700)),
                ...['Semua', 'Ya', 'Tidak'].map((s) => RadioListTile<String>(
                      value: s,
                      groupValue: evid,
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => evid = v);
                        }
                      },
                      title: Text(s),
                      contentPadding: EdgeInsets.zero,
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _statusFilter
                    ..clear()
                    ..addAll({'Baru', 'Diproses', 'Selesai'});
                  _categoryFilter
                    ..clear()
                    ..addAll({'Fisik', 'Verbal', 'Cyber', 'Sosial', 'Lainnya'});
                  _anonymousFilter = 'Semua';
                  _evidenceFilter = 'Semua';
                });
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _statusFilter
                    ..clear()
                    ..addAll(tempStatus);
                  _categoryFilter
                    ..clear()
                    ..addAll(tempCategory);
                  _anonymousFilter = anon;
                  _evidenceFilter = evid;
                });
                Navigator.pop(context);
              },
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );
  }
}

class _KpiItem {
  _KpiItem({required this.title, required this.value});
  final String title;
  final String value;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

class _Point {
  const _Point({required this.x, required this.y});
  final double x;
  final double y;
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.series, required this.lineColors});
  final Map<String, List<_Point>> series;
  final List<Color> lineColors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(series: series, lineColors: lineColors),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.series, required this.lineColors});
  final Map<String, List<_Point>> series;
  final List<Color> lineColors;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 16.0;
    final chartRect = Rect.fromLTWH(padding, padding, size.width - 2 * padding, size.height - 2 * padding);

    double maxY = 1;
    for (final s in series.values) {
      for (final p in s) {
        if (p.y > maxY) maxY = p.y;
      }
    }
    if (maxY == 0) maxY = 1;

    final axisPaint = Paint()..color = const Color(0xFFE0E0E0)..strokeWidth = 1;
    // axes
    canvas.drawLine(Offset(chartRect.left, chartRect.bottom), Offset(chartRect.right, chartRect.bottom), axisPaint);
    canvas.drawLine(Offset(chartRect.left, chartRect.top), Offset(chartRect.left, chartRect.bottom), axisPaint);

    int colorIdx = 0;
    for (final entry in series.entries) {
      final points = entry.value;
      if (points.isEmpty) continue;
      final path = Path();
      for (int i = 0; i < points.length; i++) {
        final p = points[i];
        final dx = points.length == 1 ? chartRect.left : chartRect.left + (p.x / (points.length - 1)) * chartRect.width;
        final dy = chartRect.bottom - (p.y / maxY) * chartRect.height;
        if (i == 0) {
          path.moveTo(dx, dy);
        } else {
          path.lineTo(dx, dy);
        }
      }
      final paint = Paint()
        ..color = lineColors[colorIdx % lineColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, paint);
      colorIdx += 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.data, required this.colors});
  final Map<String, int> data;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutPainter(data: data, colors: colors),
      child: Center(
        child: Text('${data.values.fold<int>(0, (a, b) => a + b)}', style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.data, required this.colors});
  final Map<String, int> data;
  final Map<String, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold<int>(0, (a, b) => a + b);
    final rect = Offset.zero & size;
    final outer = Rect.fromCircle(center: rect.center, radius: size.shortestSide / 2 - 8);
    final startAngleBase = -3.14159 / 2;
    double start = startAngleBase;
    if (total == 0) {
      final paint = Paint()..color = const Color(0xFFE0E0E0)..style = PaintingStyle.stroke..strokeWidth = 14;
      canvas.drawArc(outer, 0, 6.28318, false, paint);
      return;
    }
    for (final entry in data.entries) {
      final sweep = (entry.value / total) * 6.28318;
      final paint = Paint()
        ..color = colors[entry.key] ?? Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(outer, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Report {
  _Report({
    required this.createdAt,
    required this.status,
    required this.category,
    required this.anonymous,
    required this.evidenceCount,
    this.firstHandledAt,
    this.resolvedAt,
  });
  final DateTime createdAt;
  final DateTime? firstHandledAt;
  final DateTime? resolvedAt;
  final String status; // 'Baru', 'Diproses', 'Selesai'
  final String category; // 'Fisik','Verbal','Cyber','Sosial','Lainnya'
  final bool anonymous;
  final int evidenceCount;
}

List<_Report> _mockReports() {
  final now = DateTime.now();
  DateTime d(int daysAgo, {int hour = 10}) => DateTime(now.year, now.month, now.day - daysAgo, hour);
  return [
    _Report(createdAt: d(1), status: 'Baru', category: 'Verbal', anonymous: false, evidenceCount: 2),
    _Report(createdAt: d(2), status: 'Diproses', category: 'Sosial', anonymous: true, evidenceCount: 0, firstHandledAt: d(2, hour: 15)),
    _Report(createdAt: d(3), status: 'Selesai', category: 'Cyber', anonymous: false, evidenceCount: 1, firstHandledAt: d(3, hour: 12), resolvedAt: d(5, hour: 9)),
    _Report(createdAt: d(4), status: 'Baru', category: 'Fisik', anonymous: false, evidenceCount: 0),
    _Report(createdAt: d(5), status: 'Selesai', category: 'Verbal', anonymous: true, evidenceCount: 3, firstHandledAt: d(5, hour: 14), resolvedAt: d(7, hour: 11)),
    _Report(createdAt: d(6), status: 'Diproses', category: 'Cyber', anonymous: false, evidenceCount: 1, firstHandledAt: d(6, hour: 16)),
    _Report(createdAt: d(8), status: 'Selesai', category: 'Sosial', anonymous: false, evidenceCount: 0, firstHandledAt: d(8, hour: 11), resolvedAt: d(10, hour: 10)),
    _Report(createdAt: d(11), status: 'Baru', category: 'Lainnya', anonymous: true, evidenceCount: 1),
    _Report(createdAt: d(13), status: 'Diproses', category: 'Fisik', anonymous: false, evidenceCount: 0, firstHandledAt: d(13, hour: 13)),
    _Report(createdAt: d(15), status: 'Selesai', category: 'Verbal', anonymous: false, evidenceCount: 2, firstHandledAt: d(15, hour: 12), resolvedAt: d(17, hour: 10)),
    _Report(createdAt: d(18), status: 'Selesai', category: 'Cyber', anonymous: true, evidenceCount: 1, firstHandledAt: d(18, hour: 16), resolvedAt: d(20, hour: 9)),
    _Report(createdAt: d(22), status: 'Baru', category: 'Sosial', anonymous: false, evidenceCount: 0),
    _Report(createdAt: d(24), status: 'Selesai', category: 'Fisik', anonymous: true, evidenceCount: 1, firstHandledAt: d(24, hour: 14), resolvedAt: d(28, hour: 10)),
  ];
}

