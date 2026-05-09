import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'product_application_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProductCard(context, Icons.person_add_alt_1_outlined, 'Open a savings account', AppColors.iconBgRed, AppColors.bpiRed, ProductType.savings),
          _buildProductCard(context, Icons.access_time_outlined, 'Open a time deposit', AppColors.iconBgGreen, AppColors.bpiTeal, ProductType.timeDeposit),
          _buildProductCard(context, Icons.bar_chart_outlined, 'Open an investment account', AppColors.iconBgBlue, Colors.blue, ProductType.investment),
          _buildProductCard(context, Icons.credit_card_outlined, 'Apply for a credit card', AppColors.iconBgPurple, Colors.deepPurple, ProductType.creditCard),
          _buildProductCard(context, Icons.home_outlined, 'Apply for a housing loan', AppColors.iconBgRed, AppColors.bpiRed, ProductType.housingLoan),
          _buildProductCard(context, Icons.directions_car_outlined, 'Apply for an auto loan', AppColors.iconBgGreen, Colors.teal, ProductType.autoLoan),
          _buildProductCard(context, Icons.shield_outlined, 'Apply for health & life insurance', AppColors.iconBgBlue, Colors.blue, ProductType.savings),
          _buildProductCard(context, Icons.show_chart_outlined, 'Open a BPI Trade account', AppColors.iconBgPurple, Colors.indigo, ProductType.investment, subtitle: 'Start your stock trading journey with us'),
          _buildProductCard(context, Icons.toll_outlined, 'Open a BPI Wealth Builder account', AppColors.iconBgOrange, Colors.orange, ProductType.investment, subtitle: 'Invest as low as PHP 1,000 and unlock more benefits at each milestone'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, IconData icon, String title, Color bgColor, Color iconColor, ProductType type, {String? subtitle}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductApplicationScreen(type: type, title: title),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
