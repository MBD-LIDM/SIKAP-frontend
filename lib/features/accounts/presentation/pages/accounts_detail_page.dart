import 'package:flutter/material.dart';

class AccountsDetailPage extends StatefulWidget {
  final String accountId;

  const AccountsDetailPage({
    Key? key,
    required this.accountId,
  }) : super(key: key);

  @override
  State<AccountsDetailPage> createState() => _AccountsDetailPageState();
}

class _AccountsDetailPageState extends State<AccountsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Akun'),
      ),
      body: const Center(
        child: Text('Accounts Detail Page'),
      ),
    );
  }
}










