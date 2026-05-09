import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Contact & Support', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you today?',
              style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            const Text(
              'Our customer support team is available 24/7 to assist you with your banking needs.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildContactCard(
              context,
              Icons.phone_outlined,
              'Call Us',
              'Talk to a representative for immediate assistance.',
              '889-10000',
              Colors.blue,
            ),
            _buildContactCard(
              context,
              Icons.email_outlined,
              'Email Us',
              'Send us an email and we\'ll get back to you within 24 hours.',
              'help@bpi.com.ph',
              Colors.orange,
            ),
            _buildContactCard(
              context,
              Icons.location_on_outlined,
              'Find a Branch',
              'Locate the nearest BPI branch or ATM in your area.',
              'Open Map',
              AppColors.bpiTeal,
            ),
            _buildContactCard(
              context,
              Icons.help_outline,
              'FAQs',
              'Find answers to common questions about our services.',
              'Visit Help Center',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, IconData icon, String title, String description, String actionText, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
                const SizedBox(height: 12),
                Text(
                  actionText,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
