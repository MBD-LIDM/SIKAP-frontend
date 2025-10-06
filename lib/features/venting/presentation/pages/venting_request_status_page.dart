import 'package:flutter/material.dart';

class VentingRequestStatusPage extends StatefulWidget {
  final String requestId;

  const VentingRequestStatusPage({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<VentingRequestStatusPage> createState() => _VentingRequestStatusPageState();
}

class _VentingRequestStatusPageState extends State<VentingRequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Curhat'),
      ),
      body: const Center(
        child: Text('Venting Request Status Page'),
      ),
    );
  }
}









