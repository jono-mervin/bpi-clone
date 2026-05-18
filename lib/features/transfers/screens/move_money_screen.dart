import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'transfer_money_screen.dart';
import 'pay_bills_screen.dart';
import 'load_service_screen.dart';
import '../../../core/utils/responsive.dart';

class MoveMoneyScreen extends StatelessWidget {
  const MoveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Move money',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline, color: AppColors.navy),
            onPressed: () => _showSnackBar(context, 'Favorites'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.s),
        children: [
          _buildActionCard(
            context,
            icon: Icons.swap_horiz,
            iconColor: AppColors.iconBgRed,
            iconForegroundColor: AppColors.bpiRed,
            title: 'Transfer money',
            subtitle: 'Within BPI or to other banks',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferMoneyScreen()),
            ),
          ),
          _buildActionCard(
            context,
            icon: Icons.receipt_long,
            iconColor: AppColors.iconBgGreen,
            iconForegroundColor: AppColors.bpiTeal,
            title: 'Pay bills',
            subtitle: 'Utilities, credit cards, and more',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PayBillsScreen()),
            ),
          ),
          _buildActionCard(
            context,
            icon: Icons.account_balance_wallet,
            iconColor: AppColors.iconBgPurple,
            iconForegroundColor: Colors.deepPurple,
            title: 'Load e-wallet',
            subtitle: 'VYBE, Easytrip, AutoSweep RFID, and more',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadServiceScreen(type: LoadServiceType.eWallet)),
            ),
          ),
          _buildActionCard(
            context,
            icon: Icons.phone_android,
            iconColor: AppColors.iconBgOrange,
            iconForegroundColor: Colors.orange,
            title: 'Load prepaid phone',
            subtitle: 'Globe, Smart, DITO, and other networks',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadServiceScreen(type: LoadServiceType.prepaidPhone)),
            ),
          ),
          _buildActionCard(
            context,
            icon: Icons.more_horiz,
            iconColor: AppColors.iconBgTeal,
            iconForegroundColor: AppColors.bpiTeal,
            title: 'Load other services',
            subtitle: 'Cignal Prepaid and Meralco Kuryente Load',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadServiceScreen(type: LoadServiceType.other)),
            ),
          ),
          SizedBox(height: 30.s),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconForegroundColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => _showSnackBar(context, title),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.s),
        padding: EdgeInsets.all(16.s),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.s),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12.s),
              ),
              child: Icon(icon, color: iconForegroundColor, size: 28.s),
            ),
            SizedBox(width: 14.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.s),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.bpiRed,
      ),
    );
  }
}
