import 'package:bsms/src/utils/build_context.dart';
import 'package:bsms/src/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signin';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Native animated background
          const Positioned.fill(child: FinisherBackground()),

            // Login Card On Top
            Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                decoration: AppDecorations.card,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back to BSMS",
                        style: AppTextStyles.heading,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Enter sign in data to continue",
                        style: AppTextStyles.subheading,
                      ),
                      const SizedBox(height: 28),

                      // Email or Phone Field
                      TextFormField(
                        controller: _emailPhoneController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email or Phone",
                          hintText: "Enter your email or phone",
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                          ),
                          border: AppDecorations.inputBorder,
                          focusedBorder: AppDecorations.inputFocusedBorder,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email or phone is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: AppDecorations.inputBorder,
                          focusedBorder: AppDecorations.inputFocusedBorder,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to forgot password page
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: AppTextStyles.link,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pushReplacementNamed(
                                OverviewScreen.routeName,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "Sign In",
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
