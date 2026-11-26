import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_user.dart';
import '../../services/firebase_service.dart';
import '../main_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _generalError;
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _emailError = "Invalid Email");
      return;
    }
    if (password.length < 6) {
      setState(() => _passwordError = "Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await FirebaseService().loginWithFirestore(
        email: email,
        password: password,
      );
      await MockUser().setLoggedInUser(user);

      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      } else if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      final msg = _cleanErrorMessage(e);
      setState(() {
        final lower = msg.toLowerCase();
        if (lower.contains('email') || lower.contains('account') || lower.contains('user')) {
          _emailError = msg;
        } else if (lower.contains('password')) {
          _passwordError = msg;
        } else {
          _generalError = msg;
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _cleanErrorMessage(dynamic error) {
    if (error == null) return "An unexpected error occurred. Please try again.";
    final str = error.toString().toLowerCase();

    if (str.contains('no user found') || str.contains('user-not-found') || str.contains('invalid-credential')) {
      return 'No account found with this email. Please check or register.';
    }
    if (str.contains('incorrect password') || str.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    }
    if (str.contains('invalid-email') || str.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (str.contains('network') || str.contains('unavailable') || str.contains('timeout') || str.contains('socket')) {
      return 'Network connection issue. Please check your internet connection.';
    }
    if (str.contains('firebase') || str.contains('firestore') || str.contains('[core/no-app]') || str.contains('permission')) {
      return 'Unable to sign in at the moment. Please try again.';
    }

    String cleaned = error.toString().replaceAll(RegExp(r'^(Exception:|Error:)\s*', caseSensitive: false), '').trim();
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]\s*'), '').trim();
    if (cleaned.isEmpty || cleaned.toLowerCase().contains('firebase') || cleaned.toLowerCase().contains('firestore')) {
      return 'Unable to sign in. Please verify your credentials.';
    }
    return cleaned;
  }

  void _handleGuestLogin() {
    MockUser().loginAsGuest();
    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    } else if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 140,
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                  height: 1.1,
                ),
              ),
              if (_generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _generalError!,
                      style: const TextStyle(
                        color: AppColors.errorRed,
                        fontFamily: 'Lato',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Email Input
              Container(
                height: 59,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _emailError != null
                        ? AppColors.errorRed
                        : const Color(0xFFDADADA),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF222222),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email address',
                    hintStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 6),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(
                      color: AppColors.errorRed,
                      fontFamily: 'Lato',
                      fontSize: 13,
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // Password Input
              Container(
                height: 59,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _passwordError != null
                        ? AppColors.errorRed
                        : const Color(0xFFDADADA),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF222222),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9E9E9E),
                    ),
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
              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 6),
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(
                      color: AppColors.errorRed,
                      fontFamily: 'Lato',
                      fontSize: 13,
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final resultEmail = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForgotPasswordScreen(
                          initialEmail: _emailController.text.trim(),
                        ),
                      ),
                    );
                    if (resultEmail != null && resultEmail.isNotEmpty && mounted) {
                      _emailController.text = resultEmail;
                      _passwordController.clear();
                    }
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Log In Button
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
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Divider "or create account"
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFD7D7D7)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or create account',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Color(0xFF5D5D5D),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFD7D7D7)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black, width: 1.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          onRegisterSuccess: widget.onLoginSuccess ??
                              () {
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MainNavigationScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Continue as Guest
              Center(
                child: TextButton(
                  onPressed: _handleGuestLogin,
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.primary,
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
}
