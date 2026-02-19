import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:intl/intl.dart';

class DataFilterBar extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final List<String> statusOptions;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;

  const DataFilterBar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.statusOptions,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.searchHint = 'Search...',
    required this.onSearchChanged,
  });

  static const double _inputHeight = 44.0;
  static const _border = Color(0xFFD0D0D0);
  static const double _radius = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Mobile: search on top, date + status side by side below
          if (constraints.maxWidth < 500) {
            return Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDateField(context)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildStatusField()),
                  ],
                ),
              ],
            );
          }
          // Desktop / tablet: horizontal row
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _buildDateField(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatusField()),
              const SizedBox(width: 16),
              Expanded(child: _buildSearchField()),
            ],
          );
        },
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: AppFontSizes.sm,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      );

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Date'),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(_radius),
          child: Container(
            height: _inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: AppFontSizes.md,
                      color: selectedDate != null
                          ? AppColors.black
                          : AppColors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Status'),
        Container(
          height: _inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
              style: const TextStyle(
                  fontSize: AppFontSizes.md, color: AppColors.black),
              items: statusOptions
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onStatusChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Search'),
        SizedBox(
          height: _inputHeight,
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle:
                  const TextStyle(color: AppColors.grey, fontSize: AppFontSizes.md),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.grey, size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_radius),
                borderSide: const BorderSide(color: _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_radius),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_radius),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    onDateChanged(picked);
  }
}
