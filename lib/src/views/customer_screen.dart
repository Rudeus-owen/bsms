import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:bsms/src/mixins/connectivity_refresh_mixin.dart';
import 'package:intl/intl.dart';

class CustomerScreen extends StatefulWidget {
  static const routeName = '/customers';
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>
    with ConnectivityRefreshMixin {
  DateTime? _selectedDate;
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  bool _isLoading = false;
  bool _isFirstLoad = true;
  List<Customer> _customers = [];
  int _totalPages = 1;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  void onConnectivityRegained() {
    _fetchCustomers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Back online - Refreshing data...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _fetchCustomers() async {
    print('DEBUG: _fetchCustomers called. Page: $_currentPage');
    setState(() => _isLoading = true);

    final result = await CustomerService.getCustomers(
      page: _currentPage,
      limit: _itemsPerPage,
      search: _searchQuery,
    );

    print(
      'DEBUG: Fetch customers result success: ${result['success']}, Total: ${result['total']}',
    );

    if (result['success'] == true) {
      if (mounted) {
        setState(() {
          _customers = result['data'];
          _totalCount = result['total'];
          _totalPages = result['totalPages'];
          _isLoading = false;
          _isFirstLoad = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFirstLoad = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  List<Map<String, dynamic>> get _paginatedCustomers {
    var filtered = _customers;

    // Locally filter if date is selected (since API doesn't seem to natively support this yet based on implementation)
    // Actually the dummy code wasn't filtering by date either. Let's keep it simple for now, but API has minca, maxca properties?
    // We will just return the list formatted.
    return filtered
        .map(
          (c) => {
            'name': c.fullName,
            'ph': c.phone,
            'email': c.email ?? '-',
            'loyalty_points': c.loyaltyPoints.toString(),
            'total_spent':
                '${NumberFormat('#,###.##').format(c.totalSpent)} MMK',
            'created_at': c.createdAt.toIso8601String().split('T')[0],
            'original': c,
          },
        )
        .toList();
  }

  // Example logic for high spenders / loyal customers if needed
  int get _highSpendersCount =>
      _customers.where((c) => c.totalSpent > 1000000).length;
  int get _newMembersCount => _customers.where((c) {
    return c.createdAt.year >= DateTime.now().year;
  }).length;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: context.getTranslated('customer_management'),
      selectedIndex: 5,
      body: RefreshIndicator(
        onRefresh: _fetchCustomers,
        color: AppColors.primary,
        child: _isFirstLoad
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: TableShimmer(),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Manage your customer base',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Add button (can be connected to a CustomerEditScreen later)
                        SizedBox(
                          height: 34,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                CustomerEditScreen.routeName,
                              ).then((_) => _fetchCustomers());
                            },
                            icon: const Icon(Icons.add, size: 15),
                            label: const Text('New Customer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 8),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          SummaryCard(
                            icon: Icons.people,
                            iconColor: Colors.blue.shade700,
                            iconBgColor: Colors.blue.shade50,
                            count: _totalCount,
                            label: 'Total Customers',
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            icon: Icons.star,
                            iconColor: Colors.amber.shade700,
                            iconBgColor: Colors.amber.shade50,
                            count: _highSpendersCount,
                            label: 'VIP Members',
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            icon: Icons.person_add,
                            iconColor: Colors.green.shade700,
                            iconBgColor: Colors.green.shade50,
                            count: _newMembersCount,
                            label: 'New (This Year)',
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
                        _fetchCustomers();
                      }),
                      statusOptions: const ['All Status'],
                      selectedStatus: _selectedStatus,
                      onStatusChanged: (s) => setState(() {
                        _selectedStatus = s;
                        _currentPage = 1;
                        _fetchCustomers();
                      }),
                      searchHint: 'Search name, phone, email...',
                      onSearchChanged: (q) => setState(() {
                        _searchQuery = q;
                        _currentPage = 1;
                        _fetchCustomers();
                      }),
                      dateLabel: context.getTranslated('date'),
                      statusLabel: context.getTranslated('status'),
                      searchLabel: context.getTranslated('search'),
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
                      onRowTap: (row) {
                        Navigator.pushNamed(
                          context,
                          CustomerEditScreen.routeName,
                          arguments: row['original'],
                        ).then((_) => _fetchCustomers());
                      },
                    ),

                    const SizedBox(height: 12),

                    if (_customers.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Page $_currentPage of $_totalPages',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _currentPage > 1
                                ? () {
                                    setState(() => _currentPage--);
                                    _fetchCustomers();
                                  }
                                : null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: _currentPage < _totalPages
                                ? () {
                                    setState(() => _currentPage++);
                                    _fetchCustomers();
                                  }
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
