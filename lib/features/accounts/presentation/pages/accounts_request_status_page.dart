import 'package:flutter/material.dart';

class AccountsRequestStatusPage extends StatefulWidget {
  final String requestId;

  const AccountsRequestStatusPage({
    super.key,
    required this.requestId,
  });

  @override
  State<AccountsRequestStatusPage> createState() => _AccountsRequestStatusPageState();
}

class _AccountsRequestStatusPageState extends State<AccountsRequestStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Permintaan Akun'),
      ),
      body: const Center(
        child: Text('Accounts Request Status Page'),
      ),
    );
  }
}










