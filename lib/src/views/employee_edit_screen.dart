import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:intl/intl.dart';

class EmployeeEditScreen extends StatefulWidget {
  static const routeName = '/employee-edit';

  const EmployeeEditScreen({super.key});

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _salaryController = TextEditingController();
  final _commissionController = TextEditingController();
  final _joinDateController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  String? _experience;
  String? _status;
  int _role = 2; // Default to Employee (2)
  bool _isInit = true;
  bool _isEditMode = false;
  String? _employeeId;
  bool _isLoading = false;

  bool _hasChanges = false;

  // Hardcoded branch ID
  String? _branchId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadBranchId();
      final args = ModalRoute.of(context)?.settings.arguments;
      // Args can be Employee object now
      if (args is Employee) {
        _isEditMode = true;
        _employeeId = args.id;
        _nameController.text = args.fullName;
        _phoneController.text = args.phone;
        _emailController.text = args.email;
        _role = args.role;
        _salaryController.text = args.salary.toString();
        _commissionController.text = args.commissionRate.toString();
        _joinDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(args.createdAt);

        // Map API data to UI-only fields if possible, or sets defaults
        _experience = args.salary > 200000 ? 'Experienced' : 'Non-experienced';
        _status = args.isActive ? 'Active' : 'Inactive';
      } else if (args is Map<String, dynamic>) {
        // Fallback for Map arguments if any
        _isEditMode = true;
        _employeeId = args['id'];
        _nameController.text = args['name'] ?? '';
        _phoneController.text = args['phone'] ?? '';
        // ... other fields
      } else {
        // Defaults for create mode
        _status = 'Active';
        _experience = 'Non-experienced';
        _joinDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now());
      }
      _isInit = false;

      // Listen for changes
      void onChange() {
        if (!_hasChanges) setState(() => _hasChanges = true);
      }

      _nameController.addListener(onChange);
      _phoneController.addListener(onChange);
      _emailController.addListener(onChange);
      _salaryController.addListener(onChange);
      _commissionController.addListener(onChange);
      _joinDateController.addListener(onChange);
      _passwordController.addListener(onChange);
    }
  }

  Future<void> _loadBranchId() async {
    final branchId = await ApiService.getBranchId();
    setState(() {
      _branchId = branchId;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _commissionController.dispose();
    _joinDateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _joinDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _hasChanges = true;
      });
    }
  }

  Future<bool> _handlePopScope() async {
    if (!_hasChanges) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 28,
                        color: AppColors.warningIcon,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),
                    const Text(
                      'Unsaved Changes',
                      style: TextStyle(
                        fontSize: AppFontSizes.xl,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    const Text(
                      'You have unsaved changes. Are you sure you want to leave without saving?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey, height: 1.5),
                    ),
                    const SizedBox(height: AppSizes.p24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop('save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isEditMode ? 'Save & Edit' : 'Save & Create',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop('discard'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: AppColors.errorLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.small,
                          ),
                          foregroundColor: AppColors.error,
                        ),
                        child: const Text('Discard Changes'),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () => Navigator.of(context).pop('cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result == 'discard') return true;
    if (result == 'save') {
      _saveForm();
      return false;
    }
    return false;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final Map<String, dynamic> data = {
      if (_branchId != null) 'branch_id': _branchId,
      'full_name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      if (!_isEditMode) 'password': _passwordController.text,
      'role': _role, // 1: admin, 2: employee, 3: receptionist
      'salary': (double.tryParse(_salaryController.text) ?? 0).toInt(),
      'commission_rate': double.tryParse(_commissionController.text) ?? 0.0,
      'is_active': _status == 'Active',
      'photo_url': null,
    };

    if (_isEditMode) {
      data['id'] = _employeeId;
    }

    Map<String, dynamic> result;
    if (_isEditMode) {
      result = await EmployeeService.updateEmployee(data);
    } else {
      result = await EmployeeService.createEmployee(data);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode ? 'Employee updated!' : 'Employee created!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Operation failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _handlePopScope();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: MainScaffold(
        showBackButton: true,
        title: _isEditMode ? 'Edit Employee' : 'New Employee',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadius.large,
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isEditMode ? 'Update Details' : 'Employee Details',
                      style: const TextStyle(
                        fontSize: AppFontSizes.xl,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p24),

                    // Name
                    _buildLabel('Full Name'),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        'Enter full name',
                        Icons.person_outline,
                      ),
                      validator: (v) =>
                          v?.isNotEmpty == true ? null : 'Name is required',
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Email
                    _buildLabel('Email'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        'Enter email',
                        Icons.email_outlined,
                      ),
                      validator: (v) =>
                          v?.isNotEmpty == true ? null : 'Email is required',
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Phone
                    _buildLabel('Phone Number'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        '09-XXX-XXXX',
                        Icons.phone_outlined,
                      ),
                      validator: (v) =>
                          v?.isNotEmpty == true ? null : 'Phone is required',
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Password (Create Mode Only)
                    if (!_isEditMode) ...[
                      _buildLabel('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration(
                          'Enter password',
                          Icons.lock_outline,
                        ),
                        validator: (v) => v?.isNotEmpty == true
                            ? null
                            : 'Password is required',
                      ),
                      const SizedBox(height: AppSizes.p20),
                    ],

                    // Job Role (Dropdown for API role int)
                    _buildLabel('Job Role'),
                    DropdownButtonFormField<int>(
                      value: _role,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Admin')),
                        DropdownMenuItem(value: 2, child: Text('Employee')),
                        DropdownMenuItem(value: 3, child: Text('Receptionist')),
                      ],
                      onChanged: (v) => setState(() {
                        _role = v ?? 2;
                        _hasChanges = true;
                      }),
                      decoration: _inputDecoration('', Icons.work_outline),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Salary & Commission
                    _buildResponsivePair(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Salary'),
                          TextFormField(
                            controller: _salaryController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              '0',
                              Icons.money,
                            ).copyWith(suffixText: 'MMK'),
                            validator: (v) =>
                                v?.isNotEmpty == true ? null : 'Required',
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Commission (%)'),
                          TextFormField(
                            controller: _commissionController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('0.0', Icons.percent),
                            validator: (v) =>
                                v?.isNotEmpty == true ? null : 'Required',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Experience & Status
                    _buildResponsivePair(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Experience'),
                          DropdownButtonFormField<String>(
                            value: _experience,
                            isExpanded: true,
                            items: ['Experienced', 'Non-experienced']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() {
                              _experience = v;
                              _hasChanges = true;
                            }),
                            decoration: _inputDecoration('', Icons.star_border),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Status'),
                          DropdownButtonFormField<String>(
                            value: _status,
                            isExpanded: true,
                            items: ['Active', 'Inactive']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() {
                              _status = v;
                              _hasChanges = true;
                            }),
                            decoration: _inputDecoration(
                              '',
                              Icons.toggle_on_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Join Date (Read-only for now as API uses created_at)
                    _buildLabel('Join Date'),
                    TextFormField(
                      controller: _joinDateController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        'Select date',
                        Icons.calendar_today_outlined,
                      ),
                      // onTap: _selectDate, // Disable editing join date if mapped to created_at
                    ),

                    const SizedBox(height: AppSizes.p32),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    Navigator.maybePop(context);
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.p16,
                              ),
                              side: const BorderSide(color: AppColors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.small,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.p16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.p16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.small,
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : Text(
                                    _isEditMode
                                        ? 'Update Employee'
                                        : 'Create Employee',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsivePair(Widget first, Widget second) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Column(
            children: [
              first,
              const SizedBox(height: AppSizes.p16),
              second,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: AppSizes.p16),
            Expanded(child: second),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppFontSizes.sm,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.grey, size: AppSizes.iconSmall),
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: AppRadius.small,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.small,
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.small,
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSizes.p16,
        horizontal: AppSizes.p16,
      ),
    );
  }
}
