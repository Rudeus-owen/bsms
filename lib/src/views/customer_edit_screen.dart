import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';
import 'package:intl/intl.dart';

class CustomerEditScreen extends StatefulWidget {
  static const routeName = '/customer-edit';

  const CustomerEditScreen({super.key});

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _loyaltyPointsController = TextEditingController();
  final _totalSpentController = TextEditingController();

  // State variables
  bool _isInit = true;
  bool _isEditMode = false;
  String? _customerId;
  bool _isLoading = false;

  bool _hasChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Customer) {
        _isEditMode = true;
        _customerId = args.id;
        _nameController.text = args.fullName;
        _phoneController.text = args.phone;
        _emailController.text = args.email ?? '';
        _addressController.text = args.address ?? '';
        _notesController.text = args.notes ?? '';
        _loyaltyPointsController.text = args.loyaltyPoints.toString();
        _totalSpentController.text = args.totalSpent.toString();

        if (args.dateOfBirth != null) {
          _dobController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(args.dateOfBirth!);
        }
      } else if (args is Map<String, dynamic>) {
        _isEditMode = true;
        _customerId = args['id'];
        _nameController.text = args['name'] ?? '';
        _phoneController.text = args['ph'] ?? '';
        _emailController.text = args['email'] ?? '';
        _loyaltyPointsController.text = (args['loyalty_points'] ?? 0)
            .toString();
        _totalSpentController.text = (args['total_spent'] ?? 0).toString();
      } else {
        _loyaltyPointsController.text = '0';
        _totalSpentController.text = '0';
      }
      _isInit = false;

      // Listen for changes
      void onChange() {
        if (!_hasChanges) setState(() => _hasChanges = true);
      }

      _nameController.addListener(onChange);
      _phoneController.addListener(onChange);
      _emailController.addListener(onChange);
      _dobController.addListener(onChange);
      _addressController.addListener(onChange);
      _notesController.addListener(onChange);
      _loyaltyPointsController.addListener(onChange);
      _totalSpentController.addListener(onChange);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _loyaltyPointsController.dispose();
    _totalSpentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
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
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
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
      'full_name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text.isNotEmpty ? _emailController.text : null,
      'dob': _dobController.text.isNotEmpty ? _dobController.text : null,
      'address': _addressController.text.isNotEmpty
          ? _addressController.text
          : null,
      'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
      'loyalty_points': int.tryParse(_loyaltyPointsController.text) ?? 0,
      'total_spent': double.tryParse(_totalSpentController.text) ?? 0,
    };

    if (_isEditMode) {
      data['id'] = _customerId;
    }

    Map<String, dynamic> result;
    if (_isEditMode) {
      result = await CustomerService.updateCustomer(data);
    } else {
      result = await CustomerService.createCustomer(data);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode ? 'Customer updated!' : 'Customer created!',
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
        title: _isEditMode ? 'Edit Customer' : 'New Customer',
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
                      _isEditMode ? 'Update Details' : 'Customer Details',
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

                    // Email
                    _buildLabel('Email (Optional)'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        'Enter email',
                        Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // DOB & Address
                    _buildResponsivePair(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Date of Birth (Optional)'),
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            decoration: _inputDecoration(
                              'Select date',
                              Icons.calendar_today_outlined,
                            ),
                            onTap: _selectDate,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Address (Optional)'),
                          TextFormField(
                            controller: _addressController,
                            decoration: _inputDecoration(
                              'Enter address',
                              Icons.home_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Loyalty Points & Total Spent
                    _buildResponsivePair(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Loyalty Points'),
                          TextFormField(
                            controller: _loyaltyPointsController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              '0',
                              Icons.star_border,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Total Spent'),
                          TextFormField(
                            controller: _totalSpentController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              '0.0',
                              Icons.money,
                            ).copyWith(suffixText: 'MMK'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Notes
                    _buildLabel('Notes (Optional)'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        'Enter any notes (e.g. allergies)',
                        Icons.note_alt_outlined,
                      ),
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
                                        ? 'Update Customer'
                                        : 'Create Customer',
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
