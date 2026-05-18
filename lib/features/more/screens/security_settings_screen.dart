import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/responsive.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _mobileKeyEnabled = true;
  bool _faceIdEnabled = true;
  bool _browserLoginEnabled = false;

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
          'Security Settings',
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
              title: 'Login & Authentication',
              items: [
                _buildToggleItem(
                  title: 'Mobile Key',
                  subtitle: 'Authorize transactions securely with a 6-digit PIN or biometrics.',
                  value: _mobileKeyEnabled,
                  onChanged: (v) => setState(() => _mobileKeyEnabled = v),
                  icon: Icons.phonelink_lock_outlined,
                ),
                _buildToggleItem(
                  title: 'Face ID / Touch ID',
                  subtitle: 'Use your device biometrics for faster and safer logins.',
                  value: _faceIdEnabled,
                  onChanged: (v) => setState(() => _faceIdEnabled = v),
                  icon: Icons.fingerprint,
                ),
              ],
            ),
            SizedBox(height: 20.s),
            _buildSection(
              title: 'Account Access',
              items: [
                _buildNavigationItem(
                  title: 'Change Password',
                  subtitle: 'Last changed 3 months ago.',
                  icon: Icons.lock_outline,
                  onTap: () {},
                ),
                _buildToggleItem(
                  title: 'Browser Login Alerts',
                  subtitle: 'Get notified whenever your account is accessed via a web browser.',
                  value: _browserLoginEnabled,
                  onChanged: (v) => setState(() => _browserLoginEnabled = v),
                  icon: Icons.language_outlined,
                ),
              ],
            ),
            SizedBox(height: 20.s),
            _buildSection(
              title: 'Devices',
              items: [
                _buildNavigationItem(
                  title: 'Manage Registered Devices',
                  subtitle: 'View and manage devices authorized to use Mobile Key.',
                  icon: Icons.devices_outlined,
                  onTap: () {},
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
        if (title != 'Face ID / Touch ID' && title != 'Browser Login Alerts')
          Divider(height: 1, indent: 60.s, endIndent: 20.s),
      ],
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15.s),
          child: Padding(
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
                Icon(Icons.chevron_right, color: Colors.grey, size: 20.s),
              ],
            ),
          ),
        ),
        if (title == 'Change Password')
          Divider(height: 1, indent: 60.s, endIndent: 20.s),
      ],
    );
  }
}
