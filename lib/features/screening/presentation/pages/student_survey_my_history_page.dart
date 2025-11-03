// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../controllers/student_survey_controller.dart';

class StudentSurveyMyHistoryPage extends StatefulWidget {
  const StudentSurveyMyHistoryPage({super.key});

  @override
  State<StudentSurveyMyHistoryPage> createState() => _StudentSurveyMyHistoryPageState();
}

class _StudentSurveyMyHistoryPageState extends State<StudentSurveyMyHistoryPage> {
  late final StudentSurveyController _controller;
  bool _loading = true;
  List<dynamic> _items = const [];

  @override
  void initState() {
    super.initState();
    _controller = StudentSurveyController.withDefaults(context);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _controller.loadMySurveys();
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Survei Saya')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final it = _items[index];
                  return ListTile(
                    title: Text('${it['title'] ?? 'Survey'}'),
                    subtitle: Text('${it['created_at'] ?? ''}'),
                  );
                },
              ),
            ),
    );
  }
}
