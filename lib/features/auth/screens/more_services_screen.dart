import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/bpi_nav_bar.dart';

class MoreServicesScreen extends StatelessWidget {
  const MoreServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'More services',
          style: GoogleFonts.inter(
            color: AppColors.navy,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSection(
              title: 'Savings, investments, & loans',
              headerColor: const Color(0xFFFDE8E8),
              items: [
                _buildItem(context, Icons.savings_outlined, 'Open a deposit account'),
                _buildItem(context, Icons.trending_up, 'Open an investment account'),
                _buildItem(context, Icons.account_balance_wallet_outlined, 'Open a BPI Wealth Builder account'),
                _buildItem(context, Icons.request_quote_outlined, 'Apply for a personal loan'),
                _buildItem(context, Icons.home_outlined, 'Apply for a housing loan'),
                _buildItem(context, Icons.directions_car_outlined, 'Apply for an auto loan'),
                _buildItem(context, Icons.home_work_outlined, 'Buena Mano', subtitle: 'Browse foreclosed properties and repossessed vehicles for sale'),
                _buildItem(context, Icons.house_outlined, 'Housing loan after sales services', subtitle: 'Get loan certifications, statements and other request forms'),
                _buildItem(context, Icons.car_rental_outlined, 'Auto loan after sales services'),
              ],
            ),
            _buildSection(
              title: 'Cards',
              headerColor: const Color(0xFFE8F5E9),
              items: [
                _buildItem(context, Icons.credit_card_outlined, 'Apply for a credit card'),
                _buildItem(context, Icons.check_circle_outline, 'Activate credit card'),
                _buildItem(context, Icons.confirmation_number_outlined, 'Credit card promos'),
                _buildItem(context, Icons.card_membership_outlined, 'Debit card promos'),
              ],
            ),
            _buildSection(
              title: 'Insurance',
              headerColor: const Color(0xFFFFF3E0),
              items: [
                _buildItem(context, Icons.health_and_safety_outlined, 'My AIA'),
                _buildItem(context, Icons.security_outlined, 'Get comprehensive coverage'),
                _buildItem(context, Icons.bolt_outlined, 'Get instant coverage'),
                _buildItem(context, Icons.home_outlined, 'Get home insurance'),
                _buildItem(context, Icons.accessible_forward_outlined, 'Get accident insurance'),
                _buildItem(context, Icons.motorcycle_outlined, 'Get motor insurance'),
              ],
            ),
            _buildSection(
              title: 'Payments & wallets',
              headerColor: const Color(0xFFF3E5F5),
              items: [
                _buildItem(context, Icons.account_balance_wallet_outlined, 'VYBE'),
                _buildItem(context, Icons.bolt, 'QuickPay', subtitle: 'Pay bills without enrolling'),
                _buildItem(context, Icons.account_balance_outlined, 'eGov', subtitle: 'Pay government fees'),
                _buildItem(context, Icons.volunteer_activism_outlined, 'eDonate', subtitle: 'Send donations to support charities'),
                _buildItem(context, Icons.autorenew_outlined, 'Auto Debit Arrangement', subtitle: 'Set up recurring payments'),
              ],
            ),
            _buildSection(
              title: 'Remittance & foreign exchange',
              headerColor: const Color(0xFFFFFDE7),
              items: [
                _buildItem(context, Icons.money_outlined, 'BPI to Cash', subtitle: 'Send money from your bank account to money partners like Cebuana Lhuillier, LBC, and more'),
                _buildItem(context, Icons.send_outlined, 'Outward Remittance', subtitle: 'Send money to international bank accounts'),
                _buildItem(context, Icons.account_balance_outlined, 'BPI Remit', subtitle: 'Send money from your US bank account to any BPI account (Powered by Meridian)'),
                _buildItem(context, Icons.attach_money, 'Buy US Dollar'),
                _buildItem(context, Icons.money_off_outlined, 'Sell US Dollar'),
                _buildItem(context, Icons.currency_exchange_outlined, 'Forex rates'),
              ],
            ),
            _buildSection(
              title: 'Information & support',
              headerColor: const Color(0xFFE3F2FD),
              items: [
                _buildItem(context, Icons.contact_mail_outlined, 'Contact us'),
                _buildItem(context, Icons.chat_bubble_outline, 'Let\'s chat'),
                _buildItem(context, Icons.info_outline, 'About the app'),
              ],
            ),
            
            const SizedBox(height: 30),
            // Footer
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/pdic_logo.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                      child: const Center(child: Text('PDIC', style: TextStyle(color: Colors.white, fontSize: 10))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text.rich(
                      TextSpan(
                        text: 'Deposits are insured by PDIC up to P1 Million per depositor.\nBPI is a proud member of BancNet.\nBPI is regulated by the Bangko Central ng Pilipinas.\n',
                        style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                        children: [
                          TextSpan(
                            text: 'https://www.bsp.gov.ph',
                            style: TextStyle(
                              color: AppColors.bpiTeal,
                              decoration: TextDecoration.none,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text.rich(
                      TextSpan(
                        text: 'By using this service, you confirm that you have read, understood and that you accept our ',
                        style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(color: AppColors.bpiTeal),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: BPINavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
        customItems: [
          const BPINavItem(icon: Icons.login, label: 'Login'),
          const BPINavItem(icon: null, label: ''), // Space for FAB
          const BPINavItem(icon: Icons.settings_suggest_outlined, label: 'More services'),
        ],
      ),
      floatingActionButton: BPIFAB(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSection({required String title, required Color headerColor, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.grey.shade600, size: 22),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: AppColors.navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, indent: 70, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}
