import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class EmployeeScreen extends StatefulWidget {
  static const routeName = '/employees';
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  DateTime? _selectedDate;
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Map<String, dynamic>> get _paginatedEmployees {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredEmployees.length) return [];
    return _filteredEmployees.sublist(
        startIndex, endIndex.clamp(0, _filteredEmployees.length));
  }

  // ── Dummy data (swap with API later) ──────────────────────────────────
  final List<Map<String, dynamic>> _allEmployees = [
    {
      'name': 'Sarah Johnson',
      'phone': '09-123-4567',
      'role': 'Senior Stylist',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2022-03-15',
    },
    {
      'name': 'Maria Garcia',
      'phone': '09-234-5678',
      'role': 'Nail Technician',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2021-07-20',
    },
    {
      'name': 'Lina Chen',
      'phone': '09-345-6789',
      'role': 'Hair Colorist',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2023-01-10',
    },
    {
      'name': 'Aye Aye',
      'phone': '09-456-7890',
      'role': 'Junior Stylist',
      'experience': 'Non-experienced',
      'status': 'Active',
      'joinDate': '2024-06-01',
    },
    {
      'name': 'Zaw Win',
      'phone': '09-567-8901',
      'role': 'Receptionist',
      'experience': 'Experienced',
      'status': 'Inactive',
      'joinDate': '2020-11-05',
    },
    {
      'name': 'Hla Hla',
      'phone': '09-678-9012',
      'role': 'Trainee',
      'experience': 'Non-experienced',
      'status': 'Active',
      'joinDate': '2024-12-01',
    },
    // Added more dummy data
    {
      'name': 'Kyaw Kyaw',
      'phone': '09-789-0123',
      'role': 'Barber',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2023-05-20',
    },
    {
      'name': 'Su Su',
      'phone': '09-890-1234',
      'role': 'Makeup Artist',
      'experience': 'Non-experienced',
      'status': 'Active',
      'joinDate': '2024-02-14',
    },
    {
      'name': 'Aung Aung',
      'phone': '09-901-2345',
      'role': 'Senior Stylist',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2021-11-11',
    },
    {
      'name': 'Mya Mya',
      'phone': '09-012-3456',
      'role': 'Nail Technician',
      'experience': 'Experienced',
      'status': 'Inactive',
      'joinDate': '2022-08-08',
    },
    {
      'name': 'Thida',
      'phone': '09-123-4567',
      'role': 'Receptionist',
      'experience': 'Non-experienced',
      'status': 'Active',
      'joinDate': '2025-01-01',
    },
    {
      'name': 'Bo Bo',
      'phone': '09-234-5678',
      'role': 'Security',
      'experience': 'Experienced',
      'status': 'Active',
      'joinDate': '2020-01-01',
    },
  ];

  List<Map<String, dynamic>> get _filteredEmployees {
    return _allEmployees.where((emp) {
      if (_selectedStatus != 'All Status' &&
          emp['status'] != _selectedStatus) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (emp['name'] as String).toLowerCase();
        final role = (emp['role'] as String).toLowerCase();
        if (!name.contains(q) && !role.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  int get _totalCount => _allEmployees.length;
  int get _expCount =>
      _allEmployees.where((e) => e['experience'] == 'Experienced').length;
  int get _nonExpCount =>
      _allEmployees.where((e) => e['experience'] == 'Non-experienced').length;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Employees',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: subtitle + add button ────────────────────
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Manage your salon team members',
                    style: TextStyle(fontSize: 13, color: AppColors.grey),
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
                      );
                    },
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text('New Employee'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
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

            // ── Data ─────────────────────────────────────────────
            // ── Data ─────────────────────────────────────────────
            DynamicDataTable(
              data: _paginatedEmployees,
              onRowTap: (row) {
                Navigator.pushNamed(
                  context,
                  EmployeeEditScreen.routeName,
                  arguments: row,
                );
              },
            ),

            const SizedBox(height: 12),

            // ── Pagination Controls ──────────────────────────────
            if (_filteredEmployees.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Page $_currentPage of ${(_filteredEmployees.length / _itemsPerPage).ceil()}',
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
                    onPressed: _currentPage <
                            (_filteredEmployees.length / _itemsPerPage).ceil()
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
