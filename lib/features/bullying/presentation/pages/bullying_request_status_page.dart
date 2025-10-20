import 'package:flutter/material.dart';

class BullyingRequestStatusPage extends StatefulWidget {
  final String requestId;

  const BullyingRequestStatusPage({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<BullyingRequestStatusPage> createState() => _BullyingRequestStatusPageState();
}

class _BullyingRequestStatusPageState extends State<BullyingRequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Laporan Bullying'),
      ),
      body: const Center(
        child: Text('Bullying Request Status Page'),
      ),
    );
  }
}










