import 'package:flutter/material.dart';
import 'package:bsms/src/models/appointment_model.dart';
import 'package:bsms/exports.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
          child: Row(
            children: [
              // Fake avatar to match image layout
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                child: Text(
                  appointment.clientName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p16),
              Expanded(
                flex: 2,
                child: Text(
                  appointment.clientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        appointment.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appointment.date
                      .split(',')
                      .last
                      .trim(), // Just show time or a short date
                  style: const TextStyle(color: AppColors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '\$${appointment.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.border, height: 1, thickness: 1),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }
}
