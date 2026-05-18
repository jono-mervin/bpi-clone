import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _transactionAlerts = true;
  bool _promosOffers = false;
  bool _securityAdvisories = true;

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.navy, size: 24.s),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Notification Settings',
          style: GoogleFonts.openSans(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.s),
            _buildSection(
              title: 'App Notifications',
              items: [
                _buildToggleItem(
                  title: 'Push Notifications',
                  subtitle: 'Get real-time updates on your account activity and app news.',
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  icon: Icons.notifications_active_outlined,
                ),
              ],
            ),
            SizedBox(height: 20.s),
            _buildSection(
              title: 'Transaction & Marketing',
              items: [
                _buildToggleItem(
                  title: 'Transaction Alerts',
                  subtitle: 'Receive notifications for every successful transaction made.',
                  value: _transactionAlerts,
                  onChanged: (v) => setState(() => _transactionAlerts = v),
                  icon: Icons.receipt_long_outlined,
                ),
                _buildToggleItem(
                  title: 'Promos & Offers',
                  subtitle: 'Be the first to know about exclusive BPI deals and rewards.',
                  value: _promosOffers,
                  onChanged: (v) => setState(() => _promosOffers = v),
                  icon: Icons.local_offer_outlined,
                ),
              ],
            ),
            SizedBox(height: 20.s),
            _buildSection(
              title: 'Security & Info',
              items: [
                _buildToggleItem(
                  title: 'Security Advisories',
                  subtitle: 'Stay informed about important security updates and scam alerts.',
                  value: _securityAdvisories,
                  onChanged: (v) => setState(() => _securityAdvisories = v),
                  icon: Icons.security_outlined,
                ),
              ],
            ),
            SizedBox(height: 40.s),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 10.s),
          child: Text(
            title,
            style: GoogleFonts.openSans(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.s),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10.s,
                offset: Offset(0, 4.s),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.s),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.s),
                decoration: BoxDecoration(
                  color: AppColors.iconBgOrange.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10.s),
                ),
                child: Icon(icon, color: Colors.deepOrange, size: 24.s),
              ),
              SizedBox(width: 15.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.s),
                    Text(
                      subtitle,
                      style: GoogleFonts.openSans(
                        color: Colors.grey.shade600,
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: const Color(0xFF66BB6A),
                activeThumbColor: Colors.white,
              ),
            ],
          ),
        ),
        if (title != 'Push Notifications' && title != 'Promos & Offers' && title != 'Security Advisories')
          Divider(height: 1, indent: 60.s, endIndent: 20.s),
      ],
    );
  }
}
