import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bsms/exports.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit App?'),
              content: const Text(
                'Are you sure you want to exit the application?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
        if (shouldPop == true) {
          SystemNavigator.pop();
        }
      },
      child: const MainScaffold(
        title: 'Overview',
        selectedIndex: 0,
        body: Center(
          child: Text(
            'Hello World!',
            style: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
        ),
      ),
    );
  }
}
