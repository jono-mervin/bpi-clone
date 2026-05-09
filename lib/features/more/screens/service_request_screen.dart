import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

enum ServiceRequestType {
  checkbook,
  stopPayment,
  partnerStore,
  newDebit,
  replaceDebit
}

class ServiceRequestScreen extends StatelessWidget {
  final ServiceRequestType type;
  final String title;

  const ServiceRequestScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: Text(title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildForm(context),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: ElevatedButton(
          onPressed: () => _handleSubmit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.bpiRed,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Submit Request', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    IconData icon;
    String description;
    Color color;

    switch (type) {
      case ServiceRequestType.checkbook:
        icon = Icons.edit_note;
        description = 'Need more checks? Request a new checkbook for your checking account here.';
        color = AppColors.bpiTeal;
        break;
      case ServiceRequestType.stopPayment:
        icon = Icons.block_outlined;
        description = 'Immediately stop payment for a check you have issued to prevent it from being cleared.';
        color = AppColors.bpiTeal;
        break;
      case ServiceRequestType.partnerStore:
        icon = Icons.storefront_outlined;
        description = 'Register or manage your account for seamless transactions with our partner stores.';
        color = AppColors.bpiTeal;
        break;
      case ServiceRequestType.newDebit:
        icon = Icons.credit_card_outlined;
        description = 'Apply for a new BPI Debit Mastercard and enjoy secure and convenient banking.';
        color = Colors.green;
        break;
      case ServiceRequestType.replaceDebit:
        icon = Icons.refresh_outlined;
        description = 'Request a replacement for your lost, damaged, or expired BPI Debit card.';
        color = Colors.green;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: color, size: 40),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        _buildDropdownField('Select Account', 'BPI JOE LOPEZ - 3379'),
        const SizedBox(height: 20),
        if (type == ServiceRequestType.checkbook) ...[
          _buildDropdownField('Number of Checkbooks', '1 (50 checks)'),
          const SizedBox(height: 20),
          _buildDropdownField('Delivery Option', 'Pick up at branch'),
        ],
        if (type == ServiceRequestType.stopPayment) ...[
          _buildTextField('Check Number'),
          const SizedBox(height: 20),
          _buildTextField('Reason for Stop Payment'),
        ],
        if (type == ServiceRequestType.newDebit || type == ServiceRequestType.replaceDebit) ...[
          _buildDropdownField('Card Type', 'BPI Debit Mastercard'),
          const SizedBox(height: 20),
          _buildDropdownField('Pick-up Branch', 'BPI Makati Main'),
        ],
        if (type == ServiceRequestType.partnerStore) ...[
          _buildDropdownField('Partner Store', 'Lazada'),
          const SizedBox(height: 20),
          _buildTextField('Store Account ID'),
        ],
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(color: AppColors.navy)),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.navy),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(10)),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your $title request has been submitted successfully!'),
        backgroundColor: AppColors.bpiTeal,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }
}
