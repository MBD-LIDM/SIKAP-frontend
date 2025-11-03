// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../controllers/student_survey_controller.dart';

class StudentSurveyTeacherListPage extends StatefulWidget {
  const StudentSurveyTeacherListPage({super.key});

  @override
  State<StudentSurveyTeacherListPage> createState() => _StudentSurveyTeacherListPageState();
}

class _StudentSurveyTeacherListPageState extends State<StudentSurveyTeacherListPage> {
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
    final data = await _controller.loadTeacherSurveys();
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Survei Siswa')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final it = _items[index];
                  return ListTile(
                    title: Text('${it['student_name'] ?? it['title'] ?? 'Survey'}'),
                    subtitle: Text('${it['created_at'] ?? ''}'),
                  );
                },
              ),
            ),
    );
  }
}
