import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;

  const RegisterScreen({super.key, this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = "Male";
  String _selectedState = "Nagaland";
  bool _obscurePassword = true;
  String? _error;
  bool _isLoading = false;

  final List<String> _states = [
    "Nagaland",
    "Assam",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Arunachal Pradesh",
    "Tripura",
    "Other State / Country"
  ];

  void _handleRegister() async {
    setState(() => _error = null);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => _error = "Please fill in all fields");
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = "Please enter a valid email");
      return;
    }
    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await FirebaseService().registerWithFirestore(
        fullName: name,
        email: email,
        password: password,
        phone: phone,
        gender: _gender,
        state: _selectedState,
      );

      await MockUser().setLoggedInUser(user);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created for ${user.fullName}!'),
            backgroundColor: const Color(0xFF20B08D),
          ),
        );
      }

      if (widget.onRegisterSuccess != null) {
        widget.onRegisterSuccess!();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception:', '').trim();
      setState(() => _error = msg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Join the Hornbill Festival experience',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Lato',
                  color: Color(0xFF5D5D5D),
                ),
              ),
              const SizedBox(height: 24),

              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.errorRed),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.errorRed, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: AppColors.errorRed,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Full Name
              _buildInputContainer(
                child: TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: _inputTextStyle,
                  decoration: _inputDecoration('Full Name'),
                ),
              ),
              const SizedBox(height: 14),

              // Email
              _buildInputContainer(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: _inputTextStyle,
                  decoration: _inputDecoration('Email address'),
                ),
              ),
              const SizedBox(height: 14),

              // Phone
              _buildInputContainer(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: _inputTextStyle,
                  decoration: _inputDecoration('Phone number'),
                ),
              ),
              const SizedBox(height: 14),

              // Password
              _buildInputContainer(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: _inputTextStyle,
                  decoration: _inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9E9E9E),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Gender Selector
              Container(
                height: 59,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFDADADA)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: ['Male', 'Female'].map((g) {
                        final isSel = _gender == g;
                        return GestureDetector(
                          onTap: () => setState(() => _gender = g),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primaryLight : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSel ? AppColors.primary : const Color(0xFFD7D7D7),
                              ),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isSel ? AppColors.primary : const Color(0xFF5D5D5D),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // State Dropdown
              Container(
                height: 59,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFDADADA)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedState,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF5D5D5D)),
                    style: _inputTextStyle,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedState = val);
                    },
                    items: _states.map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Color(0xFF5D5D5D),
                      ),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDADADA)),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  TextStyle get _inputTextStyle => const TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Color(0xFF222222),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        ),
      );
}
