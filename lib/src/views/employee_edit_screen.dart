import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class EmployeeEditScreen extends StatelessWidget {
  static const routeName = '/employee-edit';
  const EmployeeEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return MainScaffold(
      title: 'Edit Employee',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: employeeData == null
            ? const Center(
                child: Text(
                  'No employee data provided.',
                  style: TextStyle(color: AppColors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primary.withAlpha(30),
                              child: Text(
                                (employeeData['name'] as String? ?? 'E')[0]
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employeeData['name']?.toString() ??
                                        'Unknown',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.xl,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    employeeData['role']?.toString() ?? '',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.md,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                        // Employee details
                        ...employeeData.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    _formatLabel(entry.key),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppFontSizes.md,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value?.toString() ?? '-',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.md,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _formatLabel(String key) {
    final words = key
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m[1]} ${m[2]}',
        )
        .replaceAll('_', ' ')
        .split(' ');
    return words
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}
