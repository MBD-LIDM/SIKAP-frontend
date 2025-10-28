import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../scenarios/domain/models/scenario_models.dart';
import '../../../../core/theme/app_theme.dart';
import 'scenario_runner_page.dart';

class ScenarioIntroItemPage extends StatelessWidget {
  const ScenarioIntroItemPage({super.key, required this.item});
  final ScenarioItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7CE),
      body: Container(
        color: const Color(0xFFFFE7CE),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF7F55B1)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 8),
                Text(item.title, style: AppTheme.headingLarge.copyWith(color: const Color(0xFF7F55B1))),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 220,
                    child: SvgPicture.asset(
                      'assets/images/scenario_intro.svg',
                      fit: BoxFit.contain,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(item.srlLesson, style: AppTheme.bodyLarge.copyWith(color: const Color(0xFF3F3F3F))),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F55B1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScenarioRunnerPage(item: item),
                        ),
                      );
                    },
                    child: Text('Mulai Skenario  →', style: AppTheme.buttonText.copyWith(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


