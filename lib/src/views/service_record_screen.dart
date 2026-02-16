import 'package:bsms/exports.dart';
import 'package:bsms/src/views/service_record_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bsms/src/widgets/appointment_card.dart';
import 'package:bsms/src/widgets/appointment_table.dart';
import 'package:bsms/src/models/appointment_model.dart';

class ServiceRecordScreen extends StatefulWidget {
  static const routeName = '/servicerecord';
  const ServiceRecordScreen({super.key});

  @override
  State<ServiceRecordScreen> createState() => _ServiceRecordScreenState();
}

class _ServiceRecordScreenState extends State<ServiceRecordScreen> {
  // Using demo data from AppointmentModel
  final List<AppointmentModel> _records = AppointmentModel.demoData;
  bool _showFilters = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _searchQuery = '';

  List<Map<String, dynamic>> get _paginatedServiceRecords {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredServiceRecords.length) return [];
    return _filteredServiceRecords.sublist(
      startIndex,
      endIndex.clamp(0, _filteredServiceRecords.length),
    );
  }

  final List<Map<String, dynamic>> _allServiceRecords = [
    {
      'date': '15-01-2026',
      'client': 'Emma Wilson',
      'service': 'Hair Coloring',
      'employee': 'Sarah Johnson',
      'duration': '2h',
      'price': 140.00,
      'payment': 'paid',
    },
    {
      'date': '15-01-2026',
      'client': 'Olivia Brown',
      'service': 'Manicure & Predicure',
      'employee': 'Maria Garcia',
      'duration': '1h 30mins',
      'price': 120.00,
      'payment': 'paid',
    },
    {
      'date': '14-01-2026',
      'client': 'Sophia Davis',
      'service': 'Facial Treatment',
      'employee': 'Lisa Chen',
      'duration': '1h',
      'price': 130.00,
      'payment': 'paid',
    },
  ];

  List<Map<String, dynamic>> get _filteredServiceRecords {
    return _allServiceRecords.where((sr) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (sr['service'] as String).toLowerCase();
        final role = (sr['client'] as String).toLowerCase();
        if (!name.contains(q) && !role.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Services Record',
      selectedIndex: 1,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
          icon: Icon(
            Icons.filter_list,
            color: _showFilters ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_showFilters) ...[
                  _buildFilters(isWide),
                  const SizedBox(height: 24),
                ],

                DynamicDataTable(
                  data: _paginatedServiceRecords,
                  onRowTap: (row) {
                    Navigator.pushNamed(
                      context,
                      ServiceRecordDetailScreen.routeName,
                      arguments: row,
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(bool isWide) {
    if (isWide) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Date of Birth (Full width in design logic, or just first item)
            const Text(
              'Date of Birth',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            SizedBox(width: 300, child: _buildDatePickerField('20/01/2026')),
            const SizedBox(height: 24),

            // Row 2: Date, Status, Search
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDatePickerField('29/01/2026'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatusDropdown(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Mobile Layout
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date of Birth',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildDatePickerField('20/01/2026'),
            const SizedBox(height: 16),

            const Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildDatePickerField('29/01/2026'),
            const SizedBox(height: 16),

            const Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildStatusDropdown(),
            const SizedBox(height: 16),

            const Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildSearchBar(),
          ],
        ),
      );
    }
  }

  Widget _buildDatePickerField(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('All Status'),
          const Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search client or service...',
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
    );
  }
}
