// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sikap/core/network/api_exception.dart';
import '../controllers/student_survey_controller.dart';

class StudentSurveySubmitPage extends StatefulWidget {
  const StudentSurveySubmitPage({super.key});

  @override
  State<StudentSurveySubmitPage> createState() => _StudentSurveySubmitPageState();
}

class _StudentSurveySubmitPageState extends State<StudentSurveySubmitPage> {
  late final StudentSurveyController _controller;
  final _formKey = GlobalKey<FormState>();
  final _jsonCtrl = TextEditingController(text: '{"answers": []}');
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller = StudentSurveyController.withDefaults(context);
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final text = _jsonCtrl.text.trim();
      final parsed = jsonDecode(text);
      if (parsed is! Map<String, dynamic>) {
        throw ApiException(message: 'Harap masukkan JSON berbentuk object');
      }
      await _controller.submit(parsed, asGuest: true);
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format JSON tidak valid')),
      );
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Survei Siswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Masukkan payload JSON (tanpa data dummy, gunakan data asli UI)'),
              const SizedBox(height: 8),
              Expanded(
                child: TextFormField(
                  controller: _jsonCtrl,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '{"answers": [{"question_id": 1, "value": 3}]}'
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
