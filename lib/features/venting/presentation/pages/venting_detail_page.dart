import 'package:flutter/material.dart';

class VentingDetailPage extends StatefulWidget {
  final String ventingId;

  const VentingDetailPage({
    Key? key,
    required this.ventingId,
  }) : super(key: key);

  @override
  State<VentingDetailPage> createState() => _VentingDetailPageState();
}

class _VentingDetailPageState extends State<VentingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Curhat'),
      ),
      body: const Center(
        child: Text('Venting Detail Page'),
      ),
    );
  }
}










