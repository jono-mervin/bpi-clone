import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/user_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  final bool isPublic;
  const NotificationsScreen({super.key, this.isPublic = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final firstName = user.name.split(' ')[0];

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
        title: Text(
          isPublic ? 'News & Updates' : 'Inbox',
          style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          if (!isPublic)
            TextButton(
              onPressed: () {},
              child: const Text('Clear all', style: TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: isPublic ? _buildPublicNotifications() : _buildPrivateNotifications(firstName),
      ),
    );
  }

  List<Widget> _buildPublicNotifications() {
    return [
      _buildNotificationSection('Latest News'),
      _buildPublicItem(
        icon: Icons.campaign_outlined,
        iconColor: Colors.blue,
        title: 'New Feature: Custom Account Nicknames',
        subtitle: 'You can now give your accounts nicknames for easier tracking. Try it in the account settings!',
        time: '1h ago',
        isUnread: true,
      ),
      _buildPublicItem(
        icon: Icons.star_outline,
        iconColor: Colors.amber,
        title: 'BPI App Version 3.4.0 is here',
        subtitle: 'We\u0027ve improved performance and added new security features to keep your banking safe.',
        time: '5h ago',
        isUnread: true,
      ),
      const SizedBox(height: 30),
      _buildNotificationSection('Promos & Offers'),
      _buildPublicItem(
        icon: Icons.local_offer_outlined,
        iconColor: Colors.orange,
        title: 'Enjoy up to 20% OFF at partner stores!',
        subtitle: 'Use your BPI Credit Card at partner stores to avail of exclusive deals this weekend.',
        time: '1d ago',
        isUnread: false,
      ),
      _buildPublicItem(
        icon: Icons.card_giftcard,
        iconColor: Colors.purple,
        title: 'Free Vybe points for new users',
        subtitle: 'Sign up for Vybe and get 1000 points instantly. Download the app now!',
        time: '2d ago',
        isUnread: false,
      ),
    ];
  }

  List<Widget> _buildPrivateNotifications(String firstName) {
    return [
      _buildNotificationSection('Account Activity'),
      _buildInboxItem(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Colors.green,
        title: 'Money Received',
        subtitle: 'You received PHP 5,000.00 from Maria Clara via InstaPay.',
        time: '30m ago',
        isUnread: true,
      ),
      _buildInboxItem(
        icon: Icons.security_outlined,
        iconColor: AppColors.bpiRed,
        title: 'Security Alert: New device login',
        subtitle: 'Hi $firstName, a new login was detected on a Chrome browser from Quezon City.',
        time: '5h ago',
        isUnread: true,
      ),
      const SizedBox(height: 30),
      _buildNotificationSection('Statements & Advisories'),
      _buildInboxItem(
        icon: Icons.description_outlined,
        iconColor: Colors.blue,
        title: 'Statement Ready: BPI ${firstName.toUpperCase()} LOPEZ',
        subtitle: 'Your statement for the period ending May 05 is now available for viewing.',
        time: '1d ago',
        isUnread: false,
      ),
      _buildInboxItem(
        icon: Icons.info_outline,
        iconColor: Colors.orange,
        title: 'Transaction Limit Updated',
        subtitle: 'Hi $firstName, your daily transfer limit has been updated as per your recent request.',
        time: '2d ago',
        isUnread: false,
      ),
    ];
  }

  Widget _buildNotificationSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPublicItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 15,
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.lightGrey.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isUnread ? AppColors.bpiTeal.withValues(alpha: 0.2) : AppColors.lightGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 15,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
