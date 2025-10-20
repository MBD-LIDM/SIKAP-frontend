import 'package:flutter/material.dart';

class ScreeningsDetailPage extends StatefulWidget {
  final String screeningId;

  const ScreeningsDetailPage({
    Key? key,
    required this.screeningId,
  }) : super(key: key);

  @override
  State<ScreeningsDetailPage> createState() => _ScreeningsDetailPageState();
}

class _ScreeningsDetailPageState extends State<ScreeningsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Skrining'),
      ),
      body: const Center(
        child: Text('Screenings Detail Page'),
      ),
    );
  }
}










