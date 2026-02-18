import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class ServiceListScreen extends StatefulWidget {
  static const routeName = '/servicelist';
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  DateTime? _selectedDate;
  String _selectedStatus =
      'All Status'; // Placeholder for future status filter if needed
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Map<String, dynamic>> get _paginatedCustomers {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredServices.length) return [];
    return _filteredServices.sublist(
      startIndex,
      endIndex.clamp(0, _filteredServices.length),
    );
  }

  // ── Dummy data ────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _allServices = [
    {
      'service': 'Haircut',
      'duration': '30 mins',
      'price': 50.00,
      'created_at': '2026-01-15',
      'updated_at': '2026-01-15',
    },
    {
      'service': 'Hair Coloring',
      'duration': '2h',
      'price': 140.00,
      'created_at': '2026-01-15',
      'updated_at': '2026-01-15',
    },
    {
      'service': 'Manicure & Predicure',
      'duration': '1h 30mins',
      'price': 120.00,
      'created_at': '2026-01-15',
      'updated_at': '2026-01-15',
    },
    {
      'service': 'Facial Treatment',
      'duration': '1h',
      'price': 130.00,
      'created_at': '2026-01-15',
      'updated_at': '2026-01-15',
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    return _allServices.where((cust) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final service = (cust['service'] as String).toLowerCase();
        final price = (cust['price'] as String).toLowerCase();
        if (!service.contains(q) && !price.contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Customers',
      selectedIndex: 7,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Manage your customer base',
                    style: TextStyle(fontSize: 13, color: AppColors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            DataFilterBar(
              selectedDate: _selectedDate,
              onDateChanged: (d) => setState(() {
                _selectedDate = d;
                _currentPage = 1;
              }),
              statusOptions: const ['All Status'],
              selectedStatus: _selectedStatus,
              onStatusChanged: (s) => setState(() {
                _selectedStatus = s;
                _currentPage = 1;
              }),
              searchHint: 'Search service, duration, price...',
              onSearchChanged: (q) => setState(() {
                _searchQuery = q;
                _currentPage = 1;
              }),
            ),
            const SizedBox(height: 12),

            DynamicDataTable(
              data: _paginatedCustomers,
              columnKeys: const [
                'service',
                'duration',
                'price',
              ],
              columnLabels: const {
                'service': 'Service',
                'duration': 'Duration',
                'price': 'Price',
              },
              onRowTap: (row) {
              },
            ),

            const SizedBox(height: 12),

            if (_filteredServices.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Page $_currentPage of ${(_filteredServices.length / _itemsPerPage).ceil()}',
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
                            (_filteredServices.length / _itemsPerPage).ceil()
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
