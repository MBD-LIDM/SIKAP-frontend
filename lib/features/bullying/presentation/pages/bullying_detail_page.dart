import 'package:flutter/material.dart';

class BullyingDetailPage extends StatefulWidget {
  final String bullyingId;

  const BullyingDetailPage({
    super.key,
    required this.bullyingId,
  });

  @override
  State<BullyingDetailPage> createState() => _BullyingDetailPageState();
}

class _BullyingDetailPageState extends State<BullyingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan Bullying'),
      ),
      body: const Center(
        child: Text('Bullying Detail Page'),
      ),
    );
  }
}










