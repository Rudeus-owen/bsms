class AppointmentModel {
  final String date;
  final String clientName;
  final String serviceName;
  final String employeeName;
  final String duration;
  final double price;
  final String status;
  final String clientAvatar;
  final String serviceIcon;

  AppointmentModel({
    required this.date,
    required this.clientName,
    required this.serviceName,
    required this.employeeName,
    required this.duration,
    required this.price,
    required this.status,
    this.clientAvatar = '',
    this.serviceIcon = '',
  });

  static List<AppointmentModel> demoData = [
    AppointmentModel(
      date: '2024-01-15',
      clientName: 'Emma Wilson',
      serviceName: 'Hair Coloring',
      employeeName: 'Sarah Johnson',
      duration: '2h 140',
      price: 140.00,
      status: 'paid',
    ),
    AppointmentModel(
      date: '2024-01-15',
      clientName: 'Olivia Brown',
      serviceName: 'Manicure & Pedicure',
      employeeName: 'Maria Garcia',
      duration: '1.5h 120',
      price: 120.00,
      status: 'paid',
    ),
    AppointmentModel(
      date: '2024-01-14',
      clientName: 'Sophia Davis',
      serviceName: 'Facial Treatment',
      employeeName: 'Lisa Chen',
      duration: '1h 130',
      price: 130.00,
      status: 'paid',
    ),
  ];
}
