import 'package:flutter/material.dart';

class WellbeingResourcesDetailPage extends StatefulWidget {
  final String resourceId;

  const WellbeingResourcesDetailPage({
    super.key,
    required this.resourceId,
  });

  @override
  State<WellbeingResourcesDetailPage> createState() => _WellbeingResourcesDetailPageState();
}

class _WellbeingResourcesDetailPageState extends State<WellbeingResourcesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sumber Daya'),
      ),
      body: const Center(
        child: Text('Wellbeing Resources Detail Page'),
      ),
    );
  }
}










