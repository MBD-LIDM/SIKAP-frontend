import 'package:flutter/material.dart';
import 'features/authentication/authentication.dart';
import 'core/theme/app_theme.dart';
import 'core/auth/ensure_guest_auth.dart';
import 'package:clarity_flutter/clarity_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final config = ClarityConfig(
    projectId: "twlp5nx6fo",
    logLevel: LogLevel.Verbose // Note: Use "LogLevel.Verbose" value while testing to debug initialization issues.
  );

  runApp(ClarityWidget(
    app: MainApp(),
    clarityConfig: config,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIKAP',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
