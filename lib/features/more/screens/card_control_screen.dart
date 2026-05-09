import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';

class CardControlScreen extends StatefulWidget {
  const CardControlScreen({super.key});

  @override
  State<CardControlScreen> createState() => _CardControlScreenState();
}

class _CardControlScreenState extends State<CardControlScreen> {
  bool _isLocked = false;
  bool _eCommerceEnabled = true;
  bool _internationalEnabled = false;
  double _withdrawalLimit = 20000;
  double _purchaseLimit = 50000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Card Control', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.bpiRed, Color(0xFFE53935)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: AppColors.bpiRed.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('BPI DEBIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Icon(Icons.contactless, color: Colors.white.withValues(alpha: 0.8)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text('**** **** **** 8294', style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CARD HOLDER', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('JUAN DELA CRUZ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png', height: 30),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildToggleTile(
              Icons.lock_outline,
              'Lock Card',
              'Temporarily disable all transactions',
              _isLocked,
              (val) => setState(() => _isLocked = val),
              color: AppColors.bpiRed,
            ),
            const Divider(height: 40),
            const Text('Security Settings', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildToggleTile(
              Icons.shopping_cart_outlined,
              'E-commerce Transactions',
              'Allow online purchases',
              _eCommerceEnabled,
              (val) => setState(() => _eCommerceEnabled = val),
            ),
            _buildToggleTile(
              Icons.public,
              'International Access',
              'Allow use outside the Philippines',
              _internationalEnabled,
              (val) => setState(() => _internationalEnabled = val),
            ),
            const Divider(height: 40),
            const Text('Transaction Limits', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildLimitSlider('Daily Withdrawal Limit', _withdrawalLimit, 50000, (val) => setState(() => _withdrawalLimit = val)),
            _buildLimitSlider('Daily Purchase Limit', _purchaseLimit, 100000, (val) => setState(() => _purchaseLimit = val)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged, {Color? color}) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (color ?? AppColors.navy).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color ?? AppColors.navy),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.bpiTeal,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLimitSlider(String label, double value, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text('PHP ${value.fNumber}', style: const TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: 10,
          activeColor: AppColors.bpiTeal,
          inactiveColor: Colors.grey.shade200,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
