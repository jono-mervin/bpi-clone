import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../auth/screens/login_screen.dart';
import './cardless_withdrawal_screen.dart';
import './generate_qr_screen.dart';
import './my_statements_screen.dart';
import './subscribe_investment_screen.dart';
import './manage_rsp_screen.dart';
import './redeem_investment_screen.dart';
import './card_control_screen.dart';
import './foreign_exchange_screen.dart';
import './manage_accounts_screen.dart';
import './track_plan_screen.dart';
import './service_request_screen.dart';
import './notification_settings_screen.dart';
import './security_settings_screen.dart';
import './contact_support_screen.dart';
import './transactions_screen.dart';
import '../../../core/utils/responsive.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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
          'More',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 24.sp),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            ),
            icon: Icon(Icons.logout, color: AppColors.bpiTeal, size: 22.s),
            label: Text('Log out', style: TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold, fontSize: 14.sp)),
          ),
          SizedBox(width: 12.s),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Invest'),
                          SizedBox(height: 12.s),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.add, 'Subscribe', AppColors.iconBgBlue, Colors.blue, screen: const SubscribeInvestmentScreen()),
                              _buildGridItem(context, Icons.sync, 'Set up RSP', AppColors.iconBgBlue, Colors.blue, screen: const ManageRSPScreen(mode: 'setup')),
                              _buildGridItem(context, Icons.edit_outlined, 'Amend RSP', AppColors.iconBgBlue, Colors.blue, screen: const ManageRSPScreen(mode: 'amend')),
                              _buildGridItem(context, Icons.toll_outlined, 'Redeem', AppColors.iconBgBlue, Colors.blue, screen: const RedeemInvestmentScreen()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Services'),
                          SizedBox(height: 12.s),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.description_outlined, 'My Statements', AppColors.iconBgPurple, Colors.deepPurple, screen: const MyStatementsScreen()),
                              _buildGridItem(context, Icons.qr_code_2, 'Generate QR', AppColors.iconBgPurple, Colors.deepPurple, screen: const GenerateQRScreen()),
                              _buildGridItem(context, Icons.analytics_outlined, 'Track & Plan', AppColors.iconBgPurple, Colors.deepPurple, screen: const TrackPlanScreen()),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Transactions'),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.atm, 'Cardless withdrawal', AppColors.iconBgTeal, AppColors.bpiTeal, screen: const CardlessWithdrawalScreen()),
                              _buildGridItem(context, Icons.edit_note, 'Reorder checkbook', AppColors.iconBgTeal, AppColors.bpiTeal, screen: const ServiceRequestScreen(type: ServiceRequestType.checkbook, title: 'Reorder Checkbook')),
                              _buildGridItem(context, Icons.block_outlined, 'Stop payment order', AppColors.iconBgTeal, AppColors.bpiTeal, screen: const ServiceRequestScreen(type: ServiceRequestType.stopPayment, title: 'Stop Payment Order')),
                              _buildGridItem(context, Icons.storefront_outlined, 'Partner store transactions', AppColors.iconBgTeal, AppColors.bpiTeal, screen: const ServiceRequestScreen(type: ServiceRequestType.partnerStore, title: 'Partner Store')),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Card management'),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.settings_suggest_outlined, 'Card Control', AppColors.iconBgGreen, Colors.green, screen: const CardControlScreen()),
                              _buildGridItem(context, Icons.credit_card_outlined, 'New debit card', AppColors.iconBgGreen, Colors.green, screen: const ServiceRequestScreen(type: ServiceRequestType.newDebit, title: 'New Debit Card')),
                              _buildGridItem(context, Icons.refresh_outlined, 'Debit card replacement', AppColors.iconBgGreen, Colors.green, screen: const ServiceRequestScreen(type: ServiceRequestType.replaceDebit, title: 'Card Replacement')),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Foreign exchange'),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.monetization_on_outlined, 'USD to PHP', AppColors.iconBgOrange, Colors.orange, screen: const ForeignExchangeScreen(type: 'USD_TO_PHP')),
                              _buildGridItem(context, Icons.currency_exchange_outlined, 'PHP to USD', AppColors.iconBgOrange, Colors.orange, screen: const ForeignExchangeScreen(type: 'PHP_TO_USD')),
                              const Expanded(child: SizedBox()),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Settings'),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.fingerprint, 'Security', AppColors.iconBgOrange, Colors.deepOrange, screen: const SecuritySettingsScreen()),
                              _buildGridItem(context, Icons.notifications_none, 'Notifications', AppColors.iconBgOrange, Colors.deepOrange, screen: const NotificationSettingsScreen()),
                              _buildGridItem(context, Icons.receipt_outlined, 'Transactions', AppColors.iconBgOrange, Colors.deepOrange, screen: const TransactionsScreen()),
                              _buildGridItem(context, Icons.layers_outlined, 'Manage My Accounts', AppColors.iconBgOrange, Colors.deepOrange, screen: const ManageAccountsScreen()),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Contact & support'),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem(context, Icons.chat_bubble_outline, 'Contact us', AppColors.iconBgBlue, Colors.blue, screen: const ContactSupportScreen()),
                              const Expanded(child: SizedBox()),
                              const Expanded(child: SizedBox()),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            'BPI is regulated by the Bangko Sentral ng Pilipinas.',
                            style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                          ),
                          Text(
                            'https://www.bsp.gov.ph',
                            style: TextStyle(color: AppColors.bpiTeal, fontSize: 10.sp, decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 16.s),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('PDIC', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: Text(
                                  'Deposits are insured by PDIC up to PHP 500,000 per depositor.',
                                  style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.s),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(color: AppColors.navy, fontSize: 18.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String label, Color bgColor, Color iconColor, {Widget? screen}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FeatureDetailsScreen(title: label)));
          }
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15.s),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15.s)),
              child: Icon(icon, color: iconColor, size: 30.s),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: AppColors.navy)),
          ],
        ),
      ),
    );
  }
}

class FeatureDetailsScreen extends StatelessWidget {
  final String title;
  const FeatureDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: Text(title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              '$title feature is being prepared',
              style: const TextStyle(color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We\u0027re working hard to bring this to you soon.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
