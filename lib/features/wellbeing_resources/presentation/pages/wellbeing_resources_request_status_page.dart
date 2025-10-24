import 'package:flutter/material.dart';

class WellbeingResourcesRequestStatusPage extends StatefulWidget {
  final String requestId;

  const WellbeingResourcesRequestStatusPage({
    super.key,
    required this.requestId,
  });

  @override
  State<WellbeingResourcesRequestStatusPage> createState() => _WellbeingResourcesRequestStatusPageState();
}

class _WellbeingResourcesRequestStatusPageState extends State<WellbeingResourcesRequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Sumber Daya'),
      ),
      body: const Center(
        child: Text('Wellbeing Resources Request Status Page'),
      ),
    );
  }
}










