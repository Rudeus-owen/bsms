class Customer {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final DateTime? dateOfBirth;
  final String? address;
  final String? notes;
  final int loyaltyPoints;
  final double totalSpent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.address,
    this.notes,
    required this.loyaltyPoints,
    required this.totalSpent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      address: json['address'],
      notes: json['notes'],
      loyaltyPoints: json['loyalty_points'] is int
          ? json['loyalty_points']
          : int.tryParse(json['loyalty_points'].toString()) ?? 0,
      totalSpent: json['total_spent'] is num
          ? (json['total_spent'] as num).toDouble()
          : double.tryParse(json['total_spent'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'notes': notes,
      'loyalty_points': loyaltyPoints,
      'total_spent': totalSpent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
