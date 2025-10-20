import 'package:flutter/material.dart';

class BullyingFormPage extends StatefulWidget {
  final String? bullyingId; // null for create, not null for edit

  const BullyingFormPage({
    Key? key,
    this.bullyingId,
  }) : super(key: key);

  @override
  State<BullyingFormPage> createState() => _BullyingFormPageState();
}

class _BullyingFormPageState extends State<BullyingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'verbal';
  String _selectedSeverity = 'medium';

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
        title: Text(widget.bullyingId == null ? 'Laporkan Bullying' : 'Edit Laporan'),
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
                  labelText: 'Judul Laporan',
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
                maxLines: 4,
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
                  labelText: 'Jenis Bullying',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'verbal', child: Text('Verbal')),
                  DropdownMenuItem(value: 'physical', child: Text('Fisik')),
                  DropdownMenuItem(value: 'cyber', child: Text('Cyber')),
                  DropdownMenuItem(value: 'social', child: Text('Sosial')),
                  DropdownMenuItem(value: 'sexual', child: Text('Seksual')),
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
                value: _selectedSeverity,
                decoration: const InputDecoration(
                  labelText: 'Tingkat Keparahan',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Rendah')),
                  DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                  DropdownMenuItem(value: 'high', child: Text('Tinggi')),
                  DropdownMenuItem(value: 'critical', child: Text('Kritis')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSeverity = value!;
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
                child: Text(widget.bullyingId == null ? 'Kirim Laporan' : 'Update Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}










