import 'package:flutter/material.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/theme/app_theme.dart';
import 'package:sikap/features/authentication/presentation/pages/login_page.dart';
import 'package:sikap/features/cases/presentation/pages/case_list_page.dart';
import 'package:sikap/features/dashboard/data/dashboard_repository.dart';
import 'package:sikap/features/home/presentation/widgets/feature_button_placeholder.dart';
import 'package:sikap/features/reflections/presentation/reflection_scenario.dart';

class DashboardGlobalPage extends StatefulWidget {
  const DashboardGlobalPage({super.key});

  @override
  State<DashboardGlobalPage> createState() => _DashboardGlobalPageState();
}

class _DashboardGlobalPageState extends State<DashboardGlobalPage> {
  late final SessionService _session;
  late final DashboardRepository _repository;

  DashboardAnalytics? _analytics;
  bool _isLoading = true;
  String? _errorMessage;
  String _granularity = 'Harian'; // 'Harian' | 'Mingguan'

  @override
  void initState() {
    super.initState();
    _session = SessionService();
    _repository = DashboardRepository(
      apiClient: ApiClient(),
      session: _session,
      auth: AuthHeaderProvider(
        loadUserToken: () async => await _session.loadUserToken(),
        loadCsrfToken: () async => await _session.loadCsrfToken(),
        loadGuestToken: () async => null,
        loadGuestId: () async => null,
      ),
    );
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final analytics = await _repository.fetchAnalytics();
      if (!mounted) return;
      setState(() {
        _analytics = analytics;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  DashboardAnalytics? get _data => _analytics;

  DashboardSummary get _summary => _data?.summary ??
      DashboardSummary(
        totalIncidents: 0,
        backlog: 0,
        resolved: 0,
        resolutionRate: 0,
        withEvidence: 0,
        anonymousReports: 0,
        averageResolutionHours: null,
      );

  Map<String, int> get _statusBreakdown => _data?.statusBreakdown ?? const {};

  EvidenceStats get _evidenceStats => _data?.evidenceStats ??
      EvidenceStats(withEvidence: 0, withoutEvidence: 0, withEvidencePct: 0);

  AnonymityStats get _anonymityStats => _data?.anonymityStats ??
      AnonymityStats(anonymous: 0, identified: 0, anonymousPct: 0);

  List<FrequencyEntry> get _locationFrequency => _data?.locationFrequency ?? const [];

  List<TypeDistributionEntry> get _typeDistribution => _data?.incidentTypeDistribution ?? const [];

  List<TimeBucket> get _createdSeries => _granularity == 'Harian'
      ? (_data?.dailyCreated ?? const [])
      : (_data?.weeklyCreated ?? const []);

  List<TimeBucket> get _resolvedSeries => _granularity == 'Harian'
      ? (_data?.dailyResolved ?? const [])
      : (_data?.weeklyResolved ?? const []);

  Map<String, List<_Point>> get _trendPoints {
    List<_Point> toPoints(List<TimeBucket> buckets) {
      final points = <_Point>[];
      for (int i = 0; i < buckets.length; i++) {
        points.add(_Point(x: i.toDouble(), y: buckets[i].count.toDouble()));
      }
      return points;
    }

    return {
      'Masuk': toPoints(_createdSeries),
      'Selesai': toPoints(_resolvedSeries),
    };
  }

  double get _growthVsPrevious {
    final series = _createdSeries;
    if (series.length < 2) return 0;
    final current = series.last.count;
    final previous = series[series.length - 2].count;
    if (previous == 0) return current == 0 ? 0 : 1.0;
    return (current - previous) / previous;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? _ErrorState(message: _errorMessage!, onRetry: _loadAnalytics)
                  : RefreshIndicator(
                      onRefresh: _loadAnalytics,
                      color: theme.primaryColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _headerSection(),
                              const SizedBox(height: 16),
                              _kpiGrid(),
                              const SizedBox(height: 16),
                              _trendCard(_trendPoints),
                              const SizedBox(height: 16),
                              _distributionRow(),
                              const SizedBox(height: 16),
                              _effectivenessCard(),
                              const SizedBox(height: 8),
                              _locationBreakdown(),
                              const SizedBox(height: 24),
                              _actionsSection(context),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    final period = _data?.period ?? 'week';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang\ndi Dasbor Guru',
          style: AppTheme.headingLarge,
        ),
        const SizedBox(height: 12),
        Text(
          'Memantau laporan bullying untuk sekolah Anda. (Periode: $period)',
          style: AppTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _kpiGrid() {
    final items = [
      _KpiItem(title: 'Total', value: '${_summary.totalIncidents}'),
      _KpiItem(title: 'Baru', value: '${_statusBreakdown['Baru'] ?? 0}'),
      _KpiItem(title: 'Diproses', value: '${_statusBreakdown['Diproses'] ?? 0}'),
      _KpiItem(title: 'Selesai', value: '${_statusBreakdown['Selesai'] ?? 0}'),
      _KpiItem(title: 'Backlog', value: '${_summary.backlog}'),
      _KpiItem(title: 'Anonim', value: '${_anonymityStats.anonymous}'),
      _KpiItem(title: 'Rasio Selesai', value: '${(_summary.resolutionRate * 100).toStringAsFixed(0)}%'),
      _KpiItem(title: '% dgn Bukti', value: '${_evidenceStats.withEvidencePct.toStringAsFixed(0)}%'),
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
    final growth = _growthVsPrevious;
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
              Text(growthText, style: TextStyle(color: growthColor)),
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
      'Baru': _statusBreakdown['Baru'] ?? 0,
      'Diproses': _statusBreakdown['Diproses'] ?? 0,
      'Selesai': _statusBreakdown['Selesai'] ?? 0,
    };
    final categoryMap = {
      for (final entry in _typeDistribution)
        entry.incidentType.isEmpty ? 'Lainnya' : entry.incidentType: entry.count,
    };
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
                SizedBox(
                  height: 180,
                  child: _DonutChart(
                    data: statusMap,
                    colors: const {
                      'Baru': Color(0xFF2196F3),
                      'Diproses': Color(0xFFFF9800),
                      'Selesai': Color(0xFF2E7D32),
                    },
                  ),
                ),
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
                ...categoryMap.entries.map(
                  (e) => _barRow(
                    label: e.key,
                    value: e.value,
                    maxValue: categoryMap.values.isEmpty
                        ? 1
                        : categoryMap.values.reduce((a, b) => a > b ? a : b),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _effectivenessCard() {
    String fmt(double? hours) {
      if (hours == null) return '-';
      if (hours < 48) return '${hours.toStringAsFixed(1)} jam';
      return '${(hours / 24).toStringAsFixed(1)} hari';
    }

    return _card(
      child: Row(
        children: [
          Expanded(
            child: _metricTile(
              title: 'Rasio bukti',
              value: '${_evidenceStats.withEvidencePct.toStringAsFixed(0)}% laporan disertai bukti',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _metricTile(
              title: 'Rata-rata penyelesaian',
              value: fmt(_summary.averageResolutionHours),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationBreakdown() {
    if (_locationFrequency.isEmpty) {
      return const SizedBox.shrink();
    }
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lokasi Paling Sering', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._locationFrequency.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(entry.label.isEmpty ? 'Tidak diketahui' : entry.label)),
                  Text('${entry.count}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aksi Cepat', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 12),
        Column(
          children: [
            FeatureButtonPlaceholder(
              title: 'Segarkan Data',
              subtitle: 'Ambil ulang analytics terbaru',
              icon: Icons.refresh,
              onTap: _loadAnalytics,
            ),
            const SizedBox(height: 16),
            FeatureButtonPlaceholder(
              title: 'Lihat Kasus',
              subtitle: 'Tinjau dan kelola laporan siswa',
              icon: Icons.folder_open,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CasesListPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            FeatureButtonPlaceholder(
              title: 'Lihat Refleksi Siswa',
              subtitle: 'Pantau refleksi dan kemajuan emosi',
              icon: Icons.insights,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReflectionScenarioPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            FeatureButtonPlaceholder(
              title: 'Log Out',
              subtitle: '',
              icon: Icons.logout,
              isSettings: true,
              backgroundColor: const Color(0xFFB678FF),
              textColor: Colors.white,
              iconColor: Colors.white,
              filled: true,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ],
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
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
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
              child: Text(
                o,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF7F55B1),
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: ratio.clamp(0, 1),
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB39DDB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
    canvas.drawLine(Offset(chartRect.left, chartRect.bottom), Offset(chartRect.right, chartRect.bottom), axisPaint);
    canvas.drawLine(Offset(chartRect.left, chartRect.top), Offset(chartRect.left, chartRect.bottom), axisPaint);

    int colorIdx = 0;
    for (final entry in series.entries) {
      final points = entry.value;
      if (points.isEmpty) continue;
      final path = Path();
      final maxIndex = points.length > 1 ? points.length - 1 : 1;
      for (int i = 0; i < points.length; i++) {
        final p = points[i];
        final dx = chartRect.left + (p.x / maxIndex) * chartRect.width;
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
    const startAngleBase = -3.14159 / 2;
    double start = startAngleBase;
    if (total == 0) {
      final paint = Paint()
        ..color = const Color(0xFFE0E0E0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14;
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

