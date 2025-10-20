import 'package:flutter/material.dart';

class BullyingDetailPage extends StatefulWidget {
  final String bullyingId;

  const BullyingDetailPage({
    Key? key,
    required this.bullyingId,
  }) : super(key: key);

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










