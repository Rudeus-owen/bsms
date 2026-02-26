import 'package:bsms/exports.dart';
import 'package:bsms/src/views/service_record_detail_screen.dart';
import 'package:flutter/material.dart';
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
  DateTime? _selectedDate;
  String _selectedStatus = 'All Status';
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
      title: context.getTranslated('services_record'),
      selectedIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataFilterBar(
              selectedDate: _selectedDate,
              onDateChanged: (d) => setState(() {
                _selectedDate = d;
                _currentPage = 1;
              }),
              statusOptions: const [
                'All Status',
                'Completed',
                'Pending',
                'Cancelled',
              ],
              selectedStatus: _selectedStatus,
              onStatusChanged: (s) => setState(() {
                _selectedStatus = s;
                _currentPage = 1;
              }),
              searchHint: 'Search client or service...',
              onSearchChanged: (q) => setState(() {
                _searchQuery = q;
                _currentPage = 1;
              }),
              dateLabel: context.getTranslated('date'),
              statusLabel: context.getTranslated('status'),
              searchLabel: context.getTranslated('search'),
            ),
            const SizedBox(height: 24),

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

            if (_filteredServiceRecords.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Page $_currentPage of ${(_filteredServiceRecords.length / _itemsPerPage).ceil() == 0 ? 1 : (_filteredServiceRecords.length / _itemsPerPage).ceil()}',
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () => setState(() => _currentPage--)
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        _currentPage <
                            (_filteredServiceRecords.length / _itemsPerPage)
                                .ceil()
                        ? () => setState(() => _currentPage++)
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
