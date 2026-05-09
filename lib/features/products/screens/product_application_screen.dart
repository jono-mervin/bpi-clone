import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';
import '../../transfers/screens/transaction_success_screen.dart';

enum ProductType { savings, timeDeposit, investment, creditCard, housingLoan, autoLoan }

class ProductApplicationScreen extends ConsumerStatefulWidget {
  final ProductType type;
  final String title;

  const ProductApplicationScreen({super.key, required this.type, required this.title});

  @override
  ConsumerState<ProductApplicationScreen> createState() => _ProductApplicationScreenState();
}

class _ProductApplicationScreenState extends ConsumerState<ProductApplicationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _incomeController = TextEditingController();
  String? _selectedSubtype;

  final Map<ProductType, List<String>> _subtypes = {
    ProductType.savings: ['BPI Kaya Savings', 'Regular Savings', 'Pamana Savings'],
    ProductType.timeDeposit: ['Short-term (35 days)', 'Long-term (1-5 years)'],
    ProductType.investment: ['BPI Invest US Dollar Short Term Fund', 'BPI Invest Money Market Fund'],
    ProductType.creditCard: ['BPI Rewards Card', 'BPI Gold Rewards Card', 'BPI Platinum Rewards Card'],
    ProductType.housingLoan: ['Standard Housing Loan', 'BPI MyHome Loan'],
    ProductType.autoLoan: ['Standard Auto Loan', 'BPI MyAuto Loan'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedSubtype == null || _nameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    if (widget.type == ProductType.savings || widget.type == ProductType.timeDeposit || widget.type == ProductType.investment) {
      final depositAmount = double.tryParse(_incomeController.text) ?? 0.0;
      if (depositAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid deposit amount')));
        return;
      }

      // Simulate account opening
      final newAccount = Account(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _selectedSubtype!,
        number: '00${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        balance: depositAmount,
      );

      ref.read(accountsProvider.notifier).addAccount(newAccount);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionSuccessScreen(
            title: 'Account opened successfully!',
            amount: newAccount.balance,
            recipient: newAccount.name,
            referenceId: 'OPEN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          ),
        ),
      );
    } else {
      // Simulate loan/card application
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionSuccessScreen(
            title: 'Application submitted!',
            amount: 0,
            recipient: _selectedSubtype!,
            referenceId: 'APP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Product Type',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubtype,
                  hint: const Text('Choose one'),
                  isExpanded: true,
                  items: _subtypes[widget.type]!.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) => setState(() => _selectedSubtype = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Personal Information',
              style: TextStyle(color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(controller: _nameController, label: 'Full Name'),
            const SizedBox(height: 15),
            _buildTextField(controller: _emailController, label: 'Email Address'),
            const SizedBox(height: 15),
            _buildTextField(controller: _phoneController, label: 'Mobile Number'),
            if (widget.type == ProductType.savings || widget.type == ProductType.timeDeposit || widget.type == ProductType.investment) ...[
              const SizedBox(height: 30),
              const Text(
                'Account Details',
                style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _incomeController,
                label: 'Initial Deposit (PHP)',
                hint: 'Minimum amount applies',
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              const SizedBox(height: 30),
              const Text(
                'Financial Information',
                style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _incomeController,
                label: 'Monthly Income',
                hint: 'Enter your monthly income',
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  widget.type == ProductType.savings || widget.type == ProductType.timeDeposit || widget.type == ProductType.investment
                      ? 'Open Account'
                      : 'Submit Application',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'By proceeding, you agree to the Terms and Conditions.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, String? hint, bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: TextStyle(color: readOnly ? Colors.grey : AppColors.navy),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
          hintText: hint,
        ),
      ),
    );
  }
}
