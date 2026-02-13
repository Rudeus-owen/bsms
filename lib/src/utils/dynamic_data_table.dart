import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class DynamicDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final void Function(Map<String, dynamic> rowData)? onRowTap;
  final List<String>? columnKeys;
  final Map<String, String>? columnLabels;

  const DynamicDataTable({
    super.key,
    required this.data,
    this.onRowTap,
    this.columnKeys,
    this.columnLabels,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: _containerDecoration,
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: AppColors.grey),
              SizedBox(height: 8),
              Text('No data available',
                  style: TextStyle(color: AppColors.grey, fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: show as a card list
        if (constraints.maxWidth < 600) {
          return _buildCardList();
        }
        // Wider: show as a DataTable
        return _buildDataTable(constraints);
      },
    );
  }

  // ── Mobile: Card List ──────────────────────────────────────────────────

  Widget _buildCardList() {
    final keys = columnKeys ?? data.first.keys.toList();

    return Column(
      children: data.asMap().entries.map((entry) {
        final row = entry.value;
        final isLast = entry.key == data.length - 1;

        return GestureDetector(
          onTap: onRowTap != null ? () => onRowTap!(row) : null,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row (first key as the main heading)
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _getInitial(row[keys.first]),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row[keys.first]?.toString() ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                          ),
                          if (keys.length > 2)
                            Text(
                              row[keys[2]]?.toString() ?? '',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.grey),
                            ),
                        ],
                      ),
                    ),
                    // Arrow indicator
                    if (onRowTap != null)
                      const Icon(Icons.chevron_right,
                          color: AppColors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                // Detail rows (skip first key, already shown above)
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: keys.skip(1).map((key) {
                    final label = columnLabels?[key] ?? _formatHeader(key);
                    final value = row[key];
                    return _buildDetailChip(label, value);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailChip(String label, dynamic value) {
    final str = value?.toString() ?? '-';
    final statusColor = _getStatusColor(str);

    if (statusColor != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: statusColor.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          str,
          style: TextStyle(
              color: statusColor, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
              fontSize: 11, color: AppColors.grey, fontWeight: FontWeight.w500),
        ),
        Text(
          str,
          style: const TextStyle(fontSize: 11, color: AppColors.black),
        ),
      ],
    );
  }

  // ── Desktop: DataTable ─────────────────────────────────────────────────

  Widget _buildDataTable(BoxConstraints constraints) {
    final keys = columnKeys ?? data.first.keys.toList();

    return Container(
      width: double.infinity,
      decoration: _containerDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FA)),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.black,
              ),
              dataTextStyle:
                  const TextStyle(fontSize: 13, color: AppColors.black),
              columnSpacing: 28,
              horizontalMargin: 16,
              columns: keys.map((key) {
                final label = columnLabels?[key] ?? _formatHeader(key);
                return DataColumn(label: Text(label.toUpperCase()));
              }).toList(),
              rows: data.map((row) {
                return DataRow(
                  onSelectChanged:
                      onRowTap != null ? (_) => onRowTap!(row) : null,
                  cells: keys.map((key) {
                    return DataCell(_buildCellContent(row[key]));
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(dynamic value) {
    if (value == null) {
      return const Text('-', style: TextStyle(color: AppColors.grey));
    }
    if (value is bool) {
      return Icon(value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red, size: 18);
    }
    if (value is num) {
      return Text(
        value is double ? value.toStringAsFixed(2) : value.toString(),
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      );
    }

    final str = value.toString();
    final statusColor = _getStatusColor(str);
    if (statusColor != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: statusColor.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(str,
            style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      );
    }
    return Text(str);
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static final _containerDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFEEEEEE)),
  );

  String _getInitial(dynamic value) {
    final str = value?.toString() ?? '?';
    return str.isNotEmpty ? str[0].toUpperCase() : '?';
  }

  Color? _getStatusColor(String str) {
    const map = {
      'active': Colors.green,
      'paid': Colors.green,
      'experienced': Colors.blue,
      'inactive': Colors.red,
      'unpaid': Colors.red,
      'pending': Colors.orange,
      'non-experienced': Colors.orange,
    };
    return map[str.toLowerCase()];
  }

  String _formatHeader(String key) {
    return key
        .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}
