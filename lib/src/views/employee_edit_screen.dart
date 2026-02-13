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
  final _roleController = TextEditingController();
  final _joinDateController = TextEditingController();

  // State variables
  String? _experience;
  String? _status;
  bool _isInit = true;
  bool _isEditMode = false;

  bool _hasChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _isEditMode = true;
        _nameController.text = args['name'] ?? '';
        _phoneController.text = args['phone'] ?? '';
        _roleController.text = args['role'] ?? '';
        _joinDateController.text = args['joinDate'] ?? '';
        _experience = args['experience'];
        _status = args['status'];
      } else {
        // Defaults for create mode
        _status = 'Active';
        _experience = 'Non-experienced';
        _joinDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
      _isInit = false;
      
      // Listen for changes
      void onChange() {
        if (!_hasChanges) setState(() => _hasChanges = true);
      }
      _nameController.addListener(onChange);
      _phoneController.addListener(onChange);
      _roleController.addListener(onChange);
      _joinDateController.addListener(onChange);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _joinDateController.dispose();
    super.dispose();
  }

  // ... (date picker logic skipped for brevity, assumed unchanged) ...
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

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: Text(
            'Do you want to save changes and ${_isEditMode ? 'edit' : 'create'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () {
               Navigator.of(context).pop(true); // Pop dialog, then...
               // We handle the "Save & Exit" manually below, so return true means discard.
               // Wait, user wants "Save and ...". 
               // Standard pattern: 
               // "Discard" -> pops true. 
               // "Save" -> calls save, then pops true.
               // "Cancel" -> pops false.
            }, 
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
               _saveForm(); // This will pop if valid
               // We need to return false to the WillPopScope because _saveForm handles navigation
            }, 
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    
    // Simplification for the "Discard" case only:
    // If we clicked Discard, we return true.
    return shouldPop ?? false;
  }
  
  // Refined _onWillPop to match User Request accurately
  Future<bool> _handlePopScope() async {
    if (!_hasChanges) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
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
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.warning_amber_rounded,
                          size: 28, color: Colors.orange.shade700),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unsaved Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have unsaved changes. Are you sure you want to leave without saving?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop('save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text(
                          _isEditMode ? 'Save & Edit' : 'Save & Create',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop('discard'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          foregroundColor: Colors.red,
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
      return false; // _saveForm handles the pop
    }
    return false; // Cancel
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement API call
      final formData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'role': _roleController.text,
        'experience': _experience,
        'status': _status,
        'joinDate': _joinDateController.text,
      };
      
      print('Form Data: $formData');
      Navigator.of(context).pop(); // Exit screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Employee updated!' : 'Employee created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // PopScope replaces WillPopScope
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
        // Reduced padding for mobile responsiveness
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            // Reduced internal padding
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8E8E8)),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Name
                  _buildLabel('Full Name'),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Enter full name', Icons.person_outline),
                    validator: (v) => v?.isNotEmpty == true ? null : 'Name is required',
                  ),
                  const SizedBox(height: 20),

                  // Phone
                  _buildLabel('Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('09-XXX-XXXX', Icons.phone_outlined),
                    validator: (v) => v?.isNotEmpty == true ? null : 'Phone is required',
                  ),
                   const SizedBox(height: 20),

                  // Role
                  _buildLabel('Job Role'),
                  TextFormField(
                    controller: _roleController,
                    decoration: _inputDecoration('e.g. Senior Stylist', Icons.work_outline),
                    validator: (v) => v?.isNotEmpty == true ? null : 'Role is required',
                  ),
                  const SizedBox(height: 20),

                  // Row for Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Experience'),
                            DropdownButtonFormField<String>(
                              value: _experience,
                              isExpanded: true, // Fix for overflow
                              items: ['Experienced', 'Non-experienced']
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _experience = v;
                                _hasChanges = true;
                              }),
                              decoration: _inputDecoration('', Icons.star_border),
                              validator: (v) => v != null ? null : 'Required',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Status'),
                            DropdownButtonFormField<String>(
                              value: _status,
                              isExpanded: true, // Fix for overflow
                              items: ['Active', 'Inactive']
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _status = v;
                                _hasChanges = true;
                              }),
                              decoration: _inputDecoration('', Icons.toggle_on_outlined),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Join Date
                  _buildLabel('Join Date'),
                  TextFormField(
                    controller: _joinDateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: _inputDecoration('Select date', Icons.calendar_today_outlined),
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                             // Treat explicit Cancel button as a "Go Back" action
                             // This will trigger the PopScope
                             Navigator.maybePop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: Text(
                            _isEditMode ? 'Update Employee' : 'Create Employee',
                            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
