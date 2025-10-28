import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';

class FeatureButtonPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSettings;
  final String? svgAsset;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final bool filled;

  const FeatureButtonPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isSettings = false,
    this.svgAsset,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.creamBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon/SVG container
            filled
                ? SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: svgAsset != null
                          ? SvgPicture.asset(
                              svgAsset!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                              colorFilter: iconColor != null
                                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                                  : null,
                            )
                          : Icon(
                              icon,
                              size: 24,
                              color: iconColor ?? (isSettings ? AppTheme.primaryPurple : Colors.grey[600]),
                            ),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: svgAsset != null
                          ? SvgPicture.asset(
                              svgAsset!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              icon,
                              size: 24,
                              color: isSettings ? AppTheme.primaryPurple : Colors.grey[600],
                            ),
                    ),
                  ),
            const SizedBox(width: 16),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: (isSettings ? AppTheme.buttonTextPurple : AppTheme.buttonText).copyWith(
                      color: textColor ?? (isSettings ? AppTheme.primaryPurple : AppTheme.orangeAccent),
                    ),
                  ),
                  if (!isSettings) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTheme.subtitle,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
