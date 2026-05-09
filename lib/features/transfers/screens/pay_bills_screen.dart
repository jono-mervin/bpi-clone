import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../widgets/transaction_confirmation_bottom_sheet.dart';
import '../../../widgets/bpi_loader.dart';
import '../../../core/providers/transaction_provider.dart';
import 'transaction_success_screen.dart';

class PayBillsScreen extends ConsumerStatefulWidget {
  const PayBillsScreen({super.key});

  @override
  ConsumerState<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends ConsumerState<PayBillsScreen> {
  final _amountController = TextEditingController();
  final _refNumberController = TextEditingController();
  String? _selectedAccountId;
  String? _selectedBiller;

  final List<String> _billers = [
    'MERALCO',
    'MAYNILAD',
    'GLOBE POSTPAID',
    'SMART POSTPAID',
    'BPI CREDIT CARD',
    'PLDT',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _refNumberController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedAccountId == null || _selectedBiller == null || amount <= 0 || _refNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final accounts = ref.read(accountsProvider);
    final sourceAccount = accounts.firstWhere((a) => a.id == _selectedAccountId);

    if (sourceAccount.balance < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance')),
      );
      return;
    }

    // Show confirmation
    showTransactionConfirmation(
      context: context,
      title: 'Confirm Payment',
      amount: amount,
      fromAccount: '${sourceAccount.name} (${sourceAccount.number})',
      toRecipient: _selectedBiller!,
      onConfirm: () async {
        // Show loading
        BPILoader.show(context);
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        BPILoader.hide(context);

        // Perform payment
        ref.read(accountsProvider.notifier).transfer(_selectedAccountId!, amount);

        // Record transaction
        final referenceId = 'PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        ref.read(transactionsProvider.notifier).addTransaction(
          Transaction(
            id: referenceId,
            title: _selectedBiller!,
            subtitle: 'Reference: ${_refNumberController.text}',
            amount: amount,
            date: DateTime.now(),
            type: TransactionType.payBills,
            accountId: _selectedAccountId,
          ),
        );

        // Navigate to success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionSuccessScreen(
              title: 'Payment successful!',
              amount: amount,
              recipient: _selectedBiller!,
              referenceId: referenceId,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pay bills',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay from',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAccountId,
                  hint: const Text('Select account'),
                  isExpanded: true,
                  items: accounts.map((account) {
                    return DropdownMenuItem(
                      value: account.id,
                      child: Text('${account.name} (PHP ${account.balance.fCurrency})'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedAccountId = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Biller',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBiller,
                  hint: const Text('Search or select biller'),
                  isExpanded: true,
                  items: _billers.map((biller) {
                    return DropdownMenuItem(
                      value: biller,
                      child: Text(biller),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedBiller = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Reference number',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _refNumberController,
              label: 'Account/Reference Number',
              hint: 'Enter reference number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            const Text(
              'Amount',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _amountController,
              label: 'PHP',
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: AppColors.navy),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grey, fontSize: 12),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontSize),
        ),
      ),
    );
  }
}
