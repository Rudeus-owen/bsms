import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

/// Shared scaffold wrapper with common AppBar, Drawer, and ConnectivityIndicator.
/// Every screen should use this instead of building its own Scaffold + AppBar.
class MainScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // Menu labels matching drawer items
  static const List<String> _screenTitles = [
    'Overview',
    'Services Record',
    'Employees',
    'Beauty Products',
    'Suppliers',
    'Customer Management',
    'Clients',
    'Services',
    'Expense/Income',
  ];

  @override
  Widget build(BuildContext context) {
    final title = _screenTitles.contains(widget.title)
        ? widget.title
        : _screenTitles[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0.5,
        shadowColor: Colors.grey.withAlpha(80),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 17,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${AppConfig.shared.appVersion}',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          ...?widget.actions,
          const ConnectivityIndicator(),
          const SizedBox(width: 16),
        ],
      ),
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
