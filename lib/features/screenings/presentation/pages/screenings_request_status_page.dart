import 'package:flutter/material.dart';

class ScreeningsRequestStatusPage extends StatefulWidget {
  final String requestId;

  const ScreeningsRequestStatusPage({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  State<ScreeningsRequestStatusPage> createState() => _ScreeningsRequestStatusPageState();
}

class _ScreeningsRequestStatusPageState extends State<ScreeningsRequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Skrining'),
      ),
      body: const Center(
        child: Text('Screenings Request Status Page'),
      ),
    );
  }
}









