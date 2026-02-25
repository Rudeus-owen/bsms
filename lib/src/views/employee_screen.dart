import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:bsms/src/mixins/connectivity_refresh_mixin.dart';
import 'package:intl/intl.dart';

class EmployeeScreen extends StatefulWidget {
  static const routeName = '/employees';
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen>
    with ConnectivityRefreshMixin {
  DateTime? _selectedDate;
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  bool _isLoading = false;
  bool _isFirstLoad = true;
  List<Employee> _employees = [];
  int _totalPages = 1;
  int _totalCount = 0;

  String? _branchId;

  @override
  void initState() {
    super.initState();
    _loadBranchAndEmployees();
  }

  @override
  void onConnectivityRegained() {
    // Auto-refresh when back online
    _fetchEmployees();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Back online - Refreshing data...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadBranchAndEmployees() async {
    _branchId = await ApiService.getBranchId();
    if (_branchId == null) {
      // Handle case where branch ID is missing (e.g. not logged in)
      // For now, maybe just log it or show empty
      print('DEBUG: Branch ID not found in storage');
    }
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    print('DEBUG: _fetchEmployees called. Page: $_currentPage');
    setState(() => _isLoading = true);

    if (_selectedStatus == 'Active') {}

    final result = await EmployeeService.getEmployees(
      page: _currentPage,
      limit: _itemsPerPage,
      branchId: _branchId,
      search: _searchQuery,
      role: null, // Add role filter if needed
    );

    print(
      'DEBUG: Fetch result success: ${result['success']}, Total: ${result['total']}',
    );

    if (result['success'] == true) {
      if (mounted) {
        setState(() {
          _employees = result['data'];
          _totalCount = result['total'];
          _totalPages = result['totalPages'];
          _employees = result['data'];
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

  List<Map<String, dynamic>> get _paginatedEmployees {
    var filtered = _employees;
    if (_selectedStatus != 'All Status') {
      final bool isActive = _selectedStatus == 'Active';
      filtered = filtered.where((e) => e.isActive == isActive).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (e) =>
                e.fullName.toLowerCase().contains(q) ||
                e.roleName.toLowerCase().contains(q),
          )
          .toList();
    }

    return filtered
        .map(
          (e) => {
            'name': e.fullName,
            'phone': e.phone,
            'role': e.roleName,
            'salary': '${NumberFormat('#,###').format(e.salary)} MMK',
            'commission': '${e.commissionRate}%',
            'experience': e.salary > 200000 ? 'Experienced' : 'Non-experienced',
            'status': e.isActive ? 'Active' : 'Inactive',
            'joinDate': e.createdAt.toIso8601String().split('T')[0],
            'original': e,
          },
        )
        .toList();
  }

  int get _expCount => _employees.where((e) => e.salary > 200000).length;
  int get _nonExpCount => _employees.where((e) => e.salary <= 200000).length;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: context.getTranslated('employees'),
      selectedIndex: 2,
      body: RefreshIndicator(
        onRefresh: _fetchEmployees,
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
                    // ── Header: subtitle + add button ────────────────────
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Manage your salon team members',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 34,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                EmployeeEditScreen.routeName,
                              ).then((_) => _fetchEmployees());
                            },
                            icon: const Icon(Icons.add, size: 15),
                            label: const Text('New Employee'),
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

                    // ── Summary Cards (3‑across, fits any width) ─────────
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
                              label: 'Total',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.person,
                              iconColor: Colors.green.shade700,
                              iconBgColor: Colors.green.shade50,
                              count: _expCount,
                              label: 'Experienced',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.person_outline,
                              iconColor: Colors.orange.shade700,
                              iconBgColor: Colors.orange.shade50,
                              count: _nonExpCount,
                              label: 'Non-Experience',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Filters ──────────────────────────────────────────
                    DataFilterBar(
                      selectedDate: _selectedDate,
                      onDateChanged: (d) => setState(() {
                        _selectedDate = d;
                        _currentPage = 1;
                      }),
                      statusOptions: const ['All Status', 'Active', 'Inactive'],
                      selectedStatus: _selectedStatus,
                      onStatusChanged: (s) => setState(() {
                        _selectedStatus = s;
                        _currentPage = 1;
                      }),
                      searchHint: 'Search employee...',
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
                      data: _paginatedEmployees,
                      columnKeys: const [
                        'name',
                        'phone',
                        'role',
                        'salary',
                        'commission',
                        'experience',
                        'status',
                        'joinDate',
                      ],
                      onRowTap: (row) {
                        Navigator.pushNamed(
                          context,
                          EmployeeEditScreen.routeName,
                          arguments: row['original'],
                        ).then((_) => _fetchEmployees());
                      },
                    ),

                    const SizedBox(height: 12),

                    // ── Pagination Controls ──────────────────────────────
                    if (_employees.isNotEmpty)
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
                                    _fetchEmployees();
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
                                    _fetchEmployees();
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
