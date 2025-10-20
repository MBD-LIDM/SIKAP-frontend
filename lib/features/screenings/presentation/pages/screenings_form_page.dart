import 'package:flutter/material.dart';

class ScreeningsFormPage extends StatefulWidget {
  final String? screeningId; // null for create, not null for edit

  const ScreeningsFormPage({
    Key? key,
    this.screeningId,
  }) : super(key: key);

  @override
  State<ScreeningsFormPage> createState() => _ScreeningsFormPageState();
}

class _ScreeningsFormPageState extends State<ScreeningsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'depression';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screeningId == null ? 'Buat Skrining' : 'Edit Skrining'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Skrining',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Jenis Skrining',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'depression', child: Text('Depresi')),
                  DropdownMenuItem(value: 'anxiety', child: Text('Kecemasan')),
                  DropdownMenuItem(value: 'stress', child: Text('Stres')),
                  DropdownMenuItem(value: 'wellbeing', child: Text('Kesejahteraan')),
                  DropdownMenuItem(value: 'mental_health', child: Text('Kesehatan Mental')),
                  DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement save logic
                  }
                },
                child: Text(widget.screeningId == null ? 'Buat Skrining' : 'Update Skrining'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}










