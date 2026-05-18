import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../widgets/bpi_loader.dart';
import '../../../widgets/transaction_confirmation_bottom_sheet.dart';
import '../../transfers/screens/transaction_success_screen.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    // Default to the first account if available
    Future.microtask(() {
      final accounts = ref.read(accountsProvider);
      if (accounts.isNotEmpty) {
        setState(() => _selectedAccountId = accounts.first.id);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void _handleDeposit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final accounts = ref.read(accountsProvider);
    Account? targetAccount;
    
    if (_selectedAccountId != null) {
      targetAccount = accounts.firstWhere((a) => a.id == _selectedAccountId);
    } else if (_accountNumberController.text.isNotEmpty) {
      // Find account by number if not logged in/no accounts in state
      try {
        targetAccount = accounts.firstWhere((a) => a.number == _accountNumberController.text);
      } catch (_) {
        // Create a dummy target if not found for simulation purposes? 
        // Or just show error.
      }
    }

    if (targetAccount == null && accounts.isNotEmpty) {
      targetAccount = accounts.first;
    }

    // For simulation, if no account exists yet (pre-login), we create one or use a default
    final String targetName = targetAccount?.name ?? 'BPI JOE LOPEZ';
    final String targetNumber = targetAccount?.number ?? '3379306674';
    final String targetId = targetAccount?.id ?? '1';

    showTransactionConfirmation(
      context: context,
      title: 'Confirm Deposit',
      amount: amount,
      fromAccount: 'External Source (Cash/Check)',
      toRecipient: '$targetName ($targetNumber)',
      onConfirm: () async {
        BPILoader.show(context);
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        BPILoader.hide(context);

        // If account doesn't exist in provider yet, add it
        if (ref.read(accountsProvider).isEmpty) {
          ref.read(accountsProvider.notifier).addAccount(
            Account(id: '1', name: 'BPI JOE LOPEZ', number: '3379306674', balance: 50000.00)
          );
        }

        // Perform deposit
        ref.read(accountsProvider.notifier).receive(targetId, amount);

        // Record transaction
        final referenceId = 'DEP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        ref.read(transactionsProvider.notifier).addTransaction(
          Transaction(
            id: referenceId,
            title: 'Cash Deposit',
            subtitle: 'Direct Deposit',
            amount: amount,
            date: DateTime.now(),
            type: TransactionType.deposit,
            accountId: targetId,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionSuccessScreen(
              title: 'Deposit successful!',
              amount: amount,
              recipient: targetName,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Deposit money',
          style: GoogleFonts.inter(color: AppColors.navy, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Account',
              style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            if (accounts.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAccountId,
                    isExpanded: true,
                    items: accounts.map((account) {
                      return DropdownMenuItem(
                        value: account.id,
                        child: Text('${account.name} (${account.number})'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedAccountId = val),
                  ),
                ),
              )
            else
              _buildTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                hint: '3379306674',
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
                onPressed: _handleDeposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Deposit',
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
