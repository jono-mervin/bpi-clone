import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/bpi_loader.dart';

class LockAccessScreen extends StatefulWidget {
  const LockAccessScreen({super.key});

  @override
  State<LockAccessScreen> createState() => _LockAccessScreenState();
}

class _LockAccessScreenState extends State<LockAccessScreen> {
  final _usernameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _birthdayController = TextEditingController();

  Future<void> _handleLock() async {
    if (_usernameController.text.isEmpty || _accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Show loading
    BPILoader.show(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    BPILoader.hide(context);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.lock_outline, color: AppColors.bpiRed, size: 60),
            SizedBox(height: 20),
            Text('Access Locked', textAlign: TextAlign.center, style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Your account access has been locked to protect your funds. Please contact BPI Phone Banking for assistance in unlocking your account.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bpiRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Back to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lock my access',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To protect your account, we will lock your BPI Online and Mobile access.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              hint: 'Enter your username',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _accountNumberController,
              label: 'Account Number / Card Number',
              hint: 'Enter any account or card number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _birthdayController,
              label: 'Birthday',
              hint: 'MM / DD / YYYY',
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 40),
            const Text(
              'By tapping "Lock My Access", you acknowledge that this action cannot be undone through the app. You must call BPI Phone Banking to regain access.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleLock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiTeal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Lock My Access',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 16, color: AppColors.navy),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
