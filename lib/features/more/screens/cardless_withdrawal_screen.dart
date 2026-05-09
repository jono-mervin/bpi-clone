import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../widgets/bpi_loader.dart';
import '../../transfers/screens/transaction_success_screen.dart';

class CardlessWithdrawalScreen extends ConsumerStatefulWidget {
  const CardlessWithdrawalScreen({super.key});

  @override
  ConsumerState<CardlessWithdrawalScreen> createState() => _CardlessWithdrawalScreenState();
}

class _CardlessWithdrawalScreenState extends ConsumerState<CardlessWithdrawalScreen> {
  final _amountController = TextEditingController();
  String? _selectedAccountId;

  void _handleWithdrawal() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedAccountId == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an account and enter an amount')));
      return;
    }

    final accounts = ref.read(accountsProvider);
    final account = accounts.firstWhere((a) => a.id == _selectedAccountId);

    if (account.balance < amount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
      return;
    }

    // Show loading
    BPILoader.show(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    BPILoader.hide(context);

    // Perform withdrawal
    ref.read(accountsProvider.notifier).transfer(_selectedAccountId!, amount);

    // Record transaction
    final referenceId = 'WDL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    ref.read(transactionsProvider.notifier).addTransaction(
      Transaction(
        id: referenceId,
        title: 'Cardless Withdrawal',
        subtitle: 'ATM Withdrawal Code: 839 204',
        amount: amount,
        date: DateTime.now(),
        type: TransactionType.withdrawal,
        accountId: _selectedAccountId,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          title: 'Withdrawal ready!',
          amount: amount,
          recipient: 'ATM Withdrawal Code: 839 204',
          referenceId: referenceId,
        ),
      ),
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Cardless withdrawal', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Withdraw from', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAccountId,
                  hint: const Text('Select account'),
                  isExpanded: true,
                  items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text('${a.name} (PHP ${a.balance.fCurrency})'))).toList(),
                  onChanged: (val) => setState(() => _selectedAccountId = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Amount', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.navy),
                decoration: const InputDecoration(border: InputBorder.none, prefixText: 'PHP ', labelText: '0.00'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Minimum withdrawal: PHP 500.00\nMaximum withdrawal: PHP 20,000.00',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Generate Withdrawal Code', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
