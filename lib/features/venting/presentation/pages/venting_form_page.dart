import 'package:flutter/material.dart';

class VentingFormPage extends StatefulWidget {
  final String? ventingId; // null for create, not null for edit

  const VentingFormPage({
    Key? key,
    this.ventingId,
  }) : super(key: key);

  @override
  State<VentingFormPage> createState() => _VentingFormPageState();
}

class _VentingFormPageState extends State<VentingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedMood = 'happy';
  String _selectedPrivacy = 'private';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ventingId == null ? 'Tulis Curhat' : 'Edit Curhat'),
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
                  labelText: 'Judul',
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
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Curhat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi curhat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMood,
                decoration: const InputDecoration(
                  labelText: 'Mood',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'happy', child: Text('Senang')),
                  DropdownMenuItem(value: 'sad', child: Text('Sedih')),
                  DropdownMenuItem(value: 'angry', child: Text('Marah')),
                  DropdownMenuItem(value: 'anxious', child: Text('Cemas')),
                  DropdownMenuItem(value: 'stressed', child: Text('Stres')),
                  DropdownMenuItem(value: 'confused', child: Text('Bingung')),
                  DropdownMenuItem(value: 'excited', child: Text('Bersemangat')),
                  DropdownMenuItem(value: 'frustrated', child: Text('Frustrasi')),
                  DropdownMenuItem(value: 'grateful', child: Text('Bersyukur')),
                  DropdownMenuItem(value: 'lonely', child: Text('Kesepian')),
                  DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPrivacy,
                decoration: const InputDecoration(
                  labelText: 'Privasi',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'private', child: Text('Pribadi')),
                  DropdownMenuItem(value: 'friends', child: Text('Teman')),
                  DropdownMenuItem(value: 'public', child: Text('Publik')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPrivacy = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tag (pisahkan dengan koma)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement save logic
                  }
                },
                child: Text(widget.ventingId == null ? 'Publikasikan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}










