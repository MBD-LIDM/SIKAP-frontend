import 'package:flutter/material.dart';

class WellbeingResourcesFormPage extends StatefulWidget {
  final String? resourceId; // null for create, not null for edit

  const WellbeingResourcesFormPage({
    super.key,
    this.resourceId,
  });

  @override
  State<WellbeingResourcesFormPage> createState() => _WellbeingResourcesFormPageState();
}

class _WellbeingResourcesFormPageState extends State<WellbeingResourcesFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedType = 'article';
  String _selectedCategory = 'mental_health';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resourceId == null ? 'Tambah Sumber Daya' : 'Edit Sumber Daya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
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
                    labelText: 'Jenis Sumber Daya',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'article', child: Text('Artikel')),
                    DropdownMenuItem(value: 'video', child: Text('Video')),
                    DropdownMenuItem(value: 'audio', child: Text('Audio')),
                    DropdownMenuItem(value: 'document', child: Text('Dokumen')),
                    DropdownMenuItem(value: 'infographic', child: Text('Infografis')),
                    DropdownMenuItem(value: 'exercise', child: Text('Latihan')),
                    DropdownMenuItem(value: 'meditation', child: Text('Meditasi')),
                    DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'mental_health', child: Text('Kesehatan Mental')),
                    DropdownMenuItem(value: 'stress_management', child: Text('Manajemen Stres')),
                    DropdownMenuItem(value: 'mindfulness', child: Text('Mindfulness')),
                    DropdownMenuItem(value: 'self_care', child: Text('Perawatan Diri')),
                    DropdownMenuItem(value: 'relationships', child: Text('Hubungan')),
                    DropdownMenuItem(value: 'productivity', child: Text('Produktivitas')),
                    DropdownMenuItem(value: 'sleep', child: Text('Tidur')),
                    DropdownMenuItem(value: 'nutrition', child: Text('Nutrisi')),
                    DropdownMenuItem(value: 'exercise', child: Text('Olahraga')),
                    DropdownMenuItem(value: 'therapy', child: Text('Terapi')),
                    DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Konten',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konten tidak boleh kosong';
                    }
                    return null;
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
                  child: Text(widget.resourceId == null ? 'Simpan' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}










