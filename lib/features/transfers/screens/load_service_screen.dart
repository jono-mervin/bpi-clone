import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../widgets/transaction_confirmation_bottom_sheet.dart';
import '../../../widgets/bpi_loader.dart';
import '../../../core/providers/transaction_provider.dart';
import 'transaction_success_screen.dart';

enum LoadServiceType { eWallet, prepaidPhone, other }

class LoadServiceScreen extends ConsumerStatefulWidget {
  final LoadServiceType type;
  const LoadServiceScreen({super.key, required this.type});

  @override
  ConsumerState<LoadServiceScreen> createState() => _LoadServiceScreenState();
}

class _LoadServiceScreenState extends ConsumerState<LoadServiceScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  String? _selectedAccountId;
  String? _selectedProvider;

  final Map<LoadServiceType, List<String>> _providers = {
    LoadServiceType.eWallet: ['VYBE', 'GCash', 'Maya', 'GrabPay', 'ShopeePay'],
    LoadServiceType.prepaidPhone: ['Globe', 'Smart', 'TM', 'DITO', 'Sun'],
    LoadServiceType.other: ['Cignal Prepaid', 'Meralco Kuryente Load', 'EasyTrip', 'AutoSweep RFID'],
  };

  String get _title {
    switch (widget.type) {
      case LoadServiceType.eWallet:
        return 'Load e-wallet';
      case LoadServiceType.prepaidPhone:
        return 'Load prepaid phone';
      case LoadServiceType.other:
        return 'Load other services';
    }
  }

  String get _recipientLabel {
    switch (widget.type) {
      case LoadServiceType.eWallet:
        return 'Mobile or Account number';
      case LoadServiceType.prepaidPhone:
        return 'Mobile number';
      case LoadServiceType.other:
        return 'Account or Reference number';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  void _handleLoad() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedAccountId == null || _selectedProvider == null || amount <= 0 || _recipientController.text.isEmpty) {
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
      title: 'Confirm Load',
      amount: amount,
      fromAccount: '${sourceAccount.name} (${sourceAccount.number})',
      toRecipient: '$_selectedProvider - ${_recipientController.text}',
      onConfirm: () async {
        // Show loading
        BPILoader.show(context);
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        BPILoader.hide(context);

        // Perform load
        ref.read(accountsProvider.notifier).transfer(_selectedAccountId!, amount);

        // Record transaction
        final referenceId = 'LOAD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        ref.read(transactionsProvider.notifier).addTransaction(
          Transaction(
            id: referenceId,
            title: '$_selectedProvider Load',
            subtitle: 'Recipient: ${_recipientController.text}',
            amount: amount,
            date: DateTime.now(),
            type: TransactionType.load,
            accountId: _selectedAccountId,
          ),
        );

        // Navigate to success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionSuccessScreen(
              title: 'Load successful!',
              amount: amount,
              recipient: '$_selectedProvider - ${_recipientController.text}',
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
        title: Text(
          _title,
          style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
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
            Text(
              widget.type == LoadServiceType.prepaidPhone ? 'Network' : 'Provider',
              style: const TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
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
                  value: _selectedProvider,
                  hint: Text('Select ${widget.type == LoadServiceType.prepaidPhone ? 'network' : 'provider'}'),
                  isExpanded: true,
                  items: _providers[widget.type]!.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedProvider = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _recipientLabel,
              style: const TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _recipientController,
              label: _recipientLabel,
              hint: 'Enter details',
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
                onPressed: _handleLoad,
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
