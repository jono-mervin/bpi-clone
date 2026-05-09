import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.openSans(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildSettingSection(
              title: 'Profile',
              headerColor: const Color(0xFFE3F2FD),
              icon: Icons.person_outline,
              iconColor: const Color(0xFF90CAF9),
              items: [
                _buildSettingItem(
                  title: 'Change password',
                  subtitle: 'Change your password regularly for your security.',
                  hasArrow: true,
                ),
                _buildSettingItem(
                  title: 'Update mobile number',
                  subtitle: 'Update the mobile number used to receive your OTP.',
                  hasArrow: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingSection(
              title: 'Security',
              headerColor: const Color(0xFFF3E5F5),
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFFCE93D8),
              items: [
                _buildSettingItem(
                  title: 'Mobile Key',
                  subtitle: 'Activate now for enhanced security.',
                  isToggle: true,
                  initialValue: false,
                ),
                _buildSettingItem(
                  title: 'Face ID login',
                  subtitle: 'Use biometrics to login to the app.',
                  isToggle: true,
                  initialValue: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingSection(
              title: 'Notifications',
              headerColor: const Color(0xFFFFF9C4),
              icon: Icons.chat_bubble_outline,
              iconColor: const Color(0xFFFFF176),
              items: [
                _buildSettingItem(
                  title: 'Push notifications',
                  subtitle: 'Keep yourself updated with important advisories and reminders.',
                  isToggle: true,
                  initialValue: true,
                ),
                _buildSettingItem(
                  title: 'Transaction alerts and offers',
                  subtitle: 'Stay updated with your spending and the latest promos.',
                  isToggle: true,
                  initialValue: false,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required Color headerColor,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Icon(icon, color: iconColor, size: 40),
              ],
            ),
          ),
          // Section Items
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    bool hasArrow = false,
    bool isToggle = false,
    bool initialValue = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.openSans(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasArrow)
                const Icon(Icons.chevron_right, color: Colors.grey),
              if (isToggle)
                Switch(
                  value: initialValue,
                  onChanged: (v) {},
                  activeTrackColor: const Color(0xFF66BB6A),
                  activeThumbColor: Colors.white,
                ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}
