import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import 'package:intl/intl.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String title;
  final double amount;
  final String recipient;
  final String referenceId;

  const TransactionSuccessScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.recipient,
    required this.referenceId,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 80,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'PHP ${amount.fCurrency}',
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _buildDetailRow('To', recipient),
              const Divider(height: 30),
              _buildDetailRow('Date & Time', date),
              const Divider(height: 30),
              _buildDetailRow('Reference Number', referenceId),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.bpiRed),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Share Receipt',
                    style: TextStyle(color: AppColors.bpiRed, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bpiRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(color: AppColors.navy, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
