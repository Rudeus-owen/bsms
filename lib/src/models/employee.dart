class Employee {
  final String id;
  final String branchId;
  final String fullName;
  final String email;
  final String phone;
  final int role;
  final double salary;
  final double commissionRate;
  final bool isActive;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    required this.id,
    required this.branchId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.salary,
    required this.commissionRate,
    required this.isActive,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      branchId: json['branch_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] is int
          ? json['role']
          : int.tryParse(json['role'].toString()) ?? 2,
      salary: json['salary'] is num
          ? (json['salary'] as num).toDouble()
          : double.tryParse(json['salary'].toString()) ?? 0.0,
      commissionRate: json['commission_rate'] is num
          ? (json['commission_rate'] as num).toDouble()
          : double.tryParse(json['commission_rate'].toString()) ?? 0.0,
      isActive: json['is_active'] ?? true,
      photoUrl: json['photo_url'],
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
      'branch_id': branchId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'salary': salary,
      'commission_rate': commissionRate,
      'is_active': isActive,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper to get role name
  String get roleName {
    switch (role) {
      case 1:
        return 'Admin';
      case 2:
        return 'Employee';
      case 3:
        return 'Receptionist';
      default:
        return 'Unknown';
    }
  }
}
