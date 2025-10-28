import 'package:flutter/material.dart';
import '../../../scenarios/data/scenario_repository.dart';
import '../../../scenarios/domain/models/scenario_models.dart';
import '../../../../core/theme/app_theme.dart';
import 'scenario_intro_item_page.dart';

class ScenarioCatalogPage extends StatefulWidget {
  const ScenarioCatalogPage({super.key});

  @override
  State<ScenarioCatalogPage> createState() => _ScenarioCatalogPageState();
}

class _ScenarioCatalogPageState extends State<ScenarioCatalogPage> {
  final ScenarioRepository _repo = ScenarioRepository();
  late Future<Map<String, List<ScenarioItem>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.loadByLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7CE),
      appBar: AppBar(
        title: const Text('Skenario Intervensi'),
        backgroundColor: const Color(0xFFFFE7CE),
        foregroundColor: const Color(0xFF7F55B1),
      ),
      body: Container(
        color: const Color(0xFFFFE7CE),
        child: SafeArea(
          child: FutureBuilder<Map<String, List<ScenarioItem>>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF7F55B1)));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Gagal memuat skenario', style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
                );
              }
              final data = snapshot.data ?? {};
              final levels = ['SD', 'SMP', 'SMA'];
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final level in levels)
                    if ((data[level] ?? []).isNotEmpty) ...[
                      Text(level, style: AppTheme.headingMedium.copyWith(color: const Color(0xFF7F55B1))),
                      const SizedBox(height: 12),
                      ...List.generate((data[level] ?? []).length, (index) {
                        final item = data[level]![index];
                        return _ScenarioTile(
                          title: item.title,
                          description: item.srlLesson,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ScenarioIntroItemPage(item: item)),
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScenarioTile extends StatelessWidget {
  const _ScenarioTile({required this.title, required this.description, required this.onTap});
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF7F55B1))),
        subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF3F3F3F))),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF7F55B1)),
        onTap: onTap,
      ),
    );
  }
}


