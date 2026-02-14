import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import 'appointment_card.dart';

class AppointmentTable extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const AppointmentTable({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('DATE')),
          DataColumn(label: Text('CLIENT')),
          DataColumn(label: Text('SERVICE')),
          DataColumn(label: Text('EMPLOYEE')),
          DataColumn(label: Text('DURATION')),
          DataColumn(label: Text('PRICE')),
          DataColumn(label: Text('PAYMENT')),
          DataColumn(label: Text('ACTIONS')),
        ],
        rows: appointments.map((appointment) {
          return DataRow(
            cells: [
              DataCell(Text(appointment.date)),
              DataCell(Text(appointment.clientName)),
              DataCell(
                Row(
                  children: [
                    // Placeholder for Service Img
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.spa,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(appointment.serviceName),
                  ],
                ),
              ),
              DataCell(Text(appointment.employeeName)),
              DataCell(Text(appointment.duration)),
              DataCell(Text('\$${appointment.price.toStringAsFixed(2)}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Colors.green,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
