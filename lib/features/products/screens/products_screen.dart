import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'product_application_screen.dart';
import '../../../core/utils/responsive.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
          'Products',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.s),
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
          SizedBox(height: 30.s),
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
        margin: EdgeInsets.only(bottom: 14.s),
        padding: EdgeInsets.all(16.s),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8.s,
              offset: Offset(0, 4.s),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.s),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12.s)),
              child: Icon(icon, color: iconColor, size: 28.s),
            ),
            SizedBox(width: 14.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: AppColors.navy, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.s),
                    Text(subtitle, style: TextStyle(color: AppColors.grey, fontSize: 12.sp)),
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
