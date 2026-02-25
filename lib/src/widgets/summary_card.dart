import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final int count;
  final String label;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for horizontal scrolling
      padding: const EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Label and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label.replaceAll(
                    '\n',
                    ' ',
                  ), // Remove newlines for horizontal layout
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p16),
          // Middle: Count
          Text(
            count.toString(),
            style: AppTextStyles.heading.copyWith(
              fontSize: 28,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          // Bottom: Subtext (optional placeholder)
          Text(
            'Updated just now',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
