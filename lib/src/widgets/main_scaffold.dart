import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class MainScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  final int selectedIndex;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.selectedIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0.5,
        shadowColor: Colors.grey.withAlpha(80),
        leading: widget.showBackButton
            ? BackButton(color: AppColors.primary)
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.primary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
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
