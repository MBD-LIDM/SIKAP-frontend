import 'package:flutter/material.dart';
import '../../../scenarios/domain/models/scenario_models.dart';
import '../../../../core/theme/app_theme.dart';

class ScenarioRunnerPage extends StatefulWidget {
  const ScenarioRunnerPage({super.key, required this.item});
  final ScenarioItem item;

  @override
  State<ScenarioRunnerPage> createState() => _ScenarioRunnerPageState();
}

class _ScenarioRunnerPageState extends State<ScenarioRunnerPage> {
  late int _currentIndex; // index stages (0-based)
  ScenarioOption? _lastSelection;
  bool _showFeedback = false;
  final TextEditingController _reflectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.item.stages[_currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7CE),
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: const Color(0xFFFFE7CE),
        foregroundColor: const Color(0xFF7F55B1),
      ),
      body: Container(
        color: const Color(0xFFFFE7CE),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: stage.isReflection ? _buildReflection(stage) : (_showFeedback ? _buildFeedback(stage) : _buildQuestion(stage)),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(ScenarioStage stage) {
    final String imagePath = 'assets/images/scenario_illustration/${stage.illustrationFile}';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(stage.narration, style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(stage.question, style: AppTheme.headingMedium.copyWith(color: const Color(0xFF7F55B1))),
          const SizedBox(height: 12),
          ListView.separated(
            itemCount: stage.options.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final opt = stage.options[index];
              return _OptionTile(
                text: opt.answer,
                onTap: () {
                  setState(() {
                    _lastSelection = opt;
                    _showFeedback = true;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFeedback(ScenarioStage stage) {
    final String imagePath = 'assets/images/scenario_illustration/${stage.illustrationFile}';
    final bool hasNext = _lastSelection != null && _lastSelection!.nextStage != stage.stageNumber;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Pilihan jawabanmu adalah', style: AppTheme.headingMedium.copyWith(color: const Color(0xFF7F55B1))),
          const SizedBox(height: 12),
          if (_lastSelection != null) _ChoiceBubble(text: _lastSelection!.answer),
          const SizedBox(height: 16),
          Text(_lastSelection?.feedback ?? '', style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          if (hasNext)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7F55B1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      setState(() {
                        _showFeedback = false; // kembali ke pertanyaan yang sama
                      });
                    },
                    child: Text('Coba Lagi', style: AppTheme.buttonTextPurple),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F55B1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_lastSelection == null) return;
                      final nextIdx = widget.item.stages.indexWhere((s) => s.stageNumber == _lastSelection!.nextStage);
                      setState(() {
                        _currentIndex = nextIdx >= 0 ? nextIdx : _currentIndex;
                        _showFeedback = false;
                      });
                    },
                    child: Text('Skenario Berikutnya  →', style: AppTheme.buttonText.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7F55B1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    _showFeedback = false; // tetap di tahap yang sama untuk pilih ulang
                  });
                },
                child: Text('Coba Lagi', style: AppTheme.buttonTextPurple),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildReflection(ScenarioStage stage) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastSelection != null) ...[
            Text('Pilihanmu sebelumnya:', style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
            const SizedBox(height: 8),
            _ChoiceBubble(text: _lastSelection!.answer),
            const SizedBox(height: 8),
            Text(_lastSelection!.feedback, style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
            const SizedBox(height: 16),
          ],
          // Tidak ada ilustrasi pada langkah refleksi (tahap ke-4)
          Text(stage.narration, style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
          const SizedBox(height: 12),
          Text(stage.question, style: AppTheme.headingMedium.copyWith(color: const Color(0xFF7F55B1))),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _reflectionController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration.collapsed(hintText: 'Ketik jawaban di sini...'),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF7F55B1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Submit dan Kembali ke Homepage', style: AppTheme.buttonTextPurple),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4))),
            const Icon(Icons.chevron_right, color: Color(0xFF7F55B1)),
          ],
        ),
      ),
    );
  }
}

class _ChoiceBubble extends StatelessWidget {
  const _ChoiceBubble({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6E7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDC7FF)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF7F55B1), fontWeight: FontWeight.w600)),
    );
  }
}


