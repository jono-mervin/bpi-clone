import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../widgets/bpi_nav_bar.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import 'package:neobank_ph/features/notifications/screens/notifications_screen.dart';
import 'retrieve_username_screen.dart';
import 'forgot_password_screen.dart';
import 'more_services_screen.dart';
import 'lock_access_screen.dart';
import '../../qr/screens/qr_scanner_screen.dart';
import '../../../core/utils/responsive.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen())),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(Icons.notifications_none_outlined, color: AppColors.navy, size: 32),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.bpiRed, shape: BoxShape.circle),
                    child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Bank Name Title (BPI) - Matches User Request
                Text(
                  'BPI',
                  style: GoogleFonts.inter(
                    color: AppColors.bpiRed,
                    fontSize: 80.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -3,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextField(label: 'Username', controller: _usernameController),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Password',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  onToggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (val) => setState(() => _rememberMe = val ?? false),
                        activeColor: AppColors.bpiRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Remember me', style: TextStyle(color: AppColors.navy, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 55.s,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bpiRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.s)),
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text('Forgot ', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RetrieveUsernameScreen())),
                        child: const Text('username', style: TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold)),
                      ),
                      Text(' or ', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                        child: const Text('password', style: TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Lost/hacked account? Secure it now',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LockAccessScreen()),
                        ),
                        child: const Text(
                          'Lock my access',
                          style: TextStyle(
                            color: AppColors.bpiTeal,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: BPIFAB(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScannerScreen()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _handleLogin() {
    if (_usernameController.text == 'admin' && _passwordController.text == 'admin123') {
      ref.read(userProvider.notifier).updateName('Joe Lopez');
      
      // Initialize default account if none exists
      final accounts = ref.read(accountsProvider);
      if (accounts.isEmpty) {
        ref.read(accountsProvider.notifier).addAccount(
          Account(id: '1', name: 'BPI JOE LOPEZ', number: '3379306674', balance: 50000.00)
        );
      }
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } else if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter credentials')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials. Use admin / admin123')));
    }
  }

  Widget _buildBottomNav() {
    return BPINavBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MoreServicesScreen()),
          );
        }
      },
      customItems: [
        const BPINavItem(icon: Icons.login, label: 'Login'),
        const BPINavItem(icon: null, label: ''), // Space for FAB
        const BPINavItem(icon: Icons.settings_suggest_outlined, label: 'More services'),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, bool isPassword = false, bool obscureText = false, VoidCallback? onToggleVisibility}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
