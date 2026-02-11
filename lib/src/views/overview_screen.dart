import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScaffold(
      title: 'Overview',
      body: Center(
        child: Text(
          'Hello World!',
          style: TextStyle(fontSize: 16, color: AppColors.grey),
        ),
      ),
    );
  }
}
