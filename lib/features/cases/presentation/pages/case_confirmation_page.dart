import 'package:flutter/material.dart';

class CaseConfirmationPage extends StatefulWidget {
  const CaseConfirmationPage({super.key, required this.caseTitle, required this.action});

  final String caseTitle;
  final String action; // 'proses' or 'tolak'

  @override
  State<CaseConfirmationPage> createState() => _CaseConfirmationPageState();
}

class _CaseConfirmationPageState extends State<CaseConfirmationPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _confirm(String action) async {
    final verb = action == 'tolak' ? 'menolak' : 'memproses';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Apakah anda yakin ingin $verb kasus ini?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
          ],
        );
      },
    );
    if (result == true) {
      // Di sini nantinya bisa dipanggil API. Untuk sekarang, hanya kembali.
      Navigator.of(context).pop({
        'action': action,
        'message': _messageController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isReject = widget.action == 'tolak';
    final String labelText = isReject ? 'Pesan penolakan' : 'Pesan pemrosesan';
    final String hintText = isReject
        ? 'Tulis alasan penolakan atau instruksi lanjutan...'
        : 'Tulis pesan pemrosesan atau langkah tindak lanjut...';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Kasus'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.caseTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(labelText),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _messageController,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isReject)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                        onPressed: () => _confirm('tolak'),
                        child: const Text('Tolak'),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        onPressed: () => _confirm('proses'),
                        child: const Text('Proses'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


