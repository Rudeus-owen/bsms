import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:bsms/src/mixins/connectivity_refresh_mixin.dart';

class CustomerScreen extends StatefulWidget {
  static const routeName = '/customers';
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>
    with ConnectivityRefreshMixin {
  DateTime? _selectedDate;
  String _selectedStatus =
      'All Status'; // Placeholder for future status filter if needed
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoading = false;

  @override
  void onConnectivityRegained() {
    _refreshData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Back online - Refreshing data...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> get _paginatedCustomers {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredCustomers.length) return [];
    return _filteredCustomers.sublist(
      startIndex,
      endIndex.clamp(0, _filteredCustomers.length),
    );
  }

  // ── Dummy data ────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _allCustomers = [
    {
      'name': 'Alice Smith',
      'ph': '09-111-2222',
      'email': 'alice@example.com',
      'dob': '1990-05-15',
      'address': '123 Maple St',
      'loyalty_points': 150,
      'total_spent': 500000,
      'created_at': '2023-01-10',
      'updated_at': '2023-11-20',
    },
    {
      'name': 'Bob Jones',
      'ph': '09-333-4444',
      'email': 'bob@example.com',
      'dob': '1985-08-20',
      'address': '456 Oak Ave',
      'loyalty_points': 320,
      'total_spent': 1200000,
      'created_at': '2022-05-15',
      'updated_at': '2023-12-01',
    },
    {
      'name': 'Charlie Brown',
      'ph': '09-555-6666',
      'email': 'charlie@example.com',
      'dob': '1992-12-10',
      'address': '789 Pine Rd',
      'loyalty_points': 50,
      'total_spent': 100000,
      'created_at': '2024-01-05',
      'updated_at': '2024-01-05',
    },
    {
      'name': 'Diana Prince',
      'ph': '09-777-8888',
      'email': 'diana@example.com',
      'dob': '1988-03-25',
      'address': '101 Cedar Ln',
      'loyalty_points': 450,
      'total_spent': 1800000,
      'created_at': '2021-11-10',
      'updated_at': '2023-10-30',
    },
    {
      'name': 'Ethan Hunt',
      'ph': '09-999-0000',
      'email': 'ethan@example.com',
      'dob': '1995-07-07',
      'address': '202 Birch Blvd',
      'loyalty_points': 200,
      'total_spent': 750000,
      'created_at': '2023-06-15',
      'updated_at': '2023-12-12',
    },
    // Add more dummy data as needed to test pagination
    {
      'name': 'Fiona Gallagher',
      'ph': '09-121-2121',
      'email': 'fiona@example.com',
      'dob': '1998-09-09',
      'address': '303 Elm St',
      'loyalty_points': 80,
      'total_spent': 300000,
      'created_at': '2024-02-01',
      'updated_at': '2024-02-10',
    },
    {
      'name': 'George Martin',
      'ph': '09-232-3232',
      'email': 'george@example.com',
      'dob': '1975-11-30',
      'address': '404 Willow Way',
      'loyalty_points': 600,
      'total_spent': 2500000,
      'created_at': '2020-03-20',
      'updated_at': '2023-09-15',
    },
    {
      'name': 'Hannah Baker',
      'ph': '09-343-4343',
      'email': 'hannah@example.com',
      'dob': '2000-01-01',
      'address': '505 Spruce Dr',
      'loyalty_points': 120,
      'total_spent': 450000,
      'created_at': '2023-08-08',
      'updated_at': '2024-01-20',
    },
    {
      'name': 'Ian Somerhalder',
      'ph': '09-454-5454',
      'email': 'ian@example.com',
      'dob': '1982-12-08',
      'address': '606 Ash Ct',
      'loyalty_points': 280,
      'total_spent': 900000,
      'created_at': '2022-10-10',
      'updated_at': '2023-11-05',
    },
    {
      'name': 'Julia Roberts',
      'ph': '09-565-6565',
      'email': 'julia@example.com',
      'dob': '1970-10-28',
      'address': '707 Fir Pl',
      'loyalty_points': 800,
      'total_spent': 5000000,
      'created_at': '2019-05-05',
      'updated_at': '2024-02-15',
    },
    {
      'name': 'Kevin Hart',
      'ph': '09-676-7676',
      'email': 'kevin@example.com',
      'dob': '1979-07-06',
      'address': '808 Redwood Rd',
      'loyalty_points': 350,
      'total_spent': 1100000,
      'created_at': '2021-04-01',
      'updated_at': '2023-12-25',
    },
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    return _allCustomers.where((cust) {
      // Add status logic here if 'status' field is added to customer data
      // if (_selectedStatus != 'All Status' && cust['status'] != _selectedStatus) {
      //   return false;
      // }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (cust['name'] as String).toLowerCase();
        final ph = (cust['ph'] as String).toLowerCase();
        final email = (cust['email'] as String).toLowerCase();
        if (!name.contains(q) && !ph.contains(q) && !email.contains(q))
          return false;
      }
      return true;
    }).toList();
  }

  int get _totalCount => _allCustomers.length;
  // Example logic for high spenders / loyal customers if needed
  int get _highSpendersCount =>
      _allCustomers.where((c) => (c['total_spent'] as int) > 1000000).length;
  int get _newMembersCount => _allCustomers.where((c) {
    final year = DateTime.parse(c['created_at']).year;
    return year >= DateTime.now().year;
  }).length;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Customers',
      selectedIndex: 5,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.people,
                        iconColor: Colors.blue.shade700,
                        iconBgColor: Colors.blue.shade50,
                        count: _totalCount,
                        label: 'Total Customers',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.star,
                        iconColor: Colors.amber.shade700,
                        iconBgColor: Colors.amber.shade50,
                        count: _highSpendersCount,
                        label: 'VIP Members',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.person_add,
                        iconColor: Colors.green.shade700,
                        iconBgColor: Colors.green.shade50,
                        count: _newMembersCount,
                        label: 'New (This Year)',
                      ),
                    ),
                  ],
                ),
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
                searchHint: 'Search name, phone, email...',
                onSearchChanged: (q) => setState(() {
                  _searchQuery = q;
                  _currentPage = 1;
                }),
              ),
              const SizedBox(height: 12),

              if (_isLoading)
                const LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.inputFill,
                ),
              const SizedBox(height: 8),

              DynamicDataTable(
                data: _paginatedCustomers,
                columnKeys: const [
                  'name',
                  'ph',
                  'email',
                  'loyalty_points',
                  'total_spent',
                  'created_at',
                ],
                columnLabels: const {
                  'name': 'Name',
                  'ph': 'Phone',
                  'email': 'Email',
                  'loyalty_points': 'Points',
                  'total_spent': 'Total Spent',
                  'created_at': 'Joined',
                },
                onRowTap: (row) {},
              ),

              const SizedBox(height: 12),

              if (_filteredCustomers.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Page $_currentPage of ${(_filteredCustomers.length / _itemsPerPage).ceil()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
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
                              (_filteredCustomers.length / _itemsPerPage).ceil()
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
      ),
    );
  }
}
