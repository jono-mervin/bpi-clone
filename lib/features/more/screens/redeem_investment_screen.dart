import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../widgets/bpi_loader.dart';
import '../../transfers/screens/transaction_success_screen.dart';

class RedeemInvestmentScreen extends ConsumerStatefulWidget {
  const RedeemInvestmentScreen({super.key});

  @override
  ConsumerState<RedeemInvestmentScreen> createState() => _RedeemInvestmentScreenState();
}

class _RedeemInvestmentScreenState extends ConsumerState<RedeemInvestmentScreen> {
  String? _selectedInvestmentId;
  String? _selectedTargetId;
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    // Filter for investment accounts (mocked by name or number prefix)
    final investments = accounts.where((a) => a.name.contains('Fund') || a.name.contains('INV')).toList();
    final targetAccounts = accounts.where((a) => !a.name.contains('Fund') && !a.name.contains('INV')).toList();

    void handleRedeem() async {
      final amount = double.tryParse(_amountController.text) ?? 0;
      if (_selectedInvestmentId == null || _selectedTargetId == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
        return;
      }

      final investment = investments.firstWhere((a) => a.id == _selectedInvestmentId);
      if (investment.balance < amount) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient investment balance')));
        return;
      }

      // Show loading
      BPILoader.show(context);
      await Future.delayed(const Duration(seconds: 2));
      if (!context.mounted) return;
      BPILoader.hide(context);

      // Perform redemption
      ref.read(accountsProvider.notifier).transfer(_selectedInvestmentId!, amount);
      ref.read(accountsProvider.notifier).receive(_selectedTargetId!, amount);

      // Record transaction
      final referenceId = 'RED-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      ref.read(transactionsProvider.notifier).addTransaction(
        Transaction(
          id: referenceId,
          title: 'Investment Redemption',
          subtitle: investment.name,
          amount: amount,
          date: DateTime.now(),
          type: TransactionType.investment,
          isCredit: true,
          accountId: _selectedTargetId,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionSuccessScreen(
            title: 'Redemption Successful!',
            amount: amount,
            recipient: targetAccounts.firstWhere((a) => a.id == _selectedTargetId).name,
            referenceId: referenceId,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Redeem', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (investments.isEmpty) ...[
              const Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text('No investment accounts found.', style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Subscribe to a fund first to start investing.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ] else ...[
              const Text('Redeem from', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedInvestmentId,
                    hint: const Text('Select investment'),
                    isExpanded: true,
                    items: investments.map((a) => DropdownMenuItem(value: a.id, child: Text('${a.name} (PHP ${a.balance.fCurrency})'))).toList(),
                    onChanged: (val) => setState(() => _selectedInvestmentId = val),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text('Credit to', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTargetId,
                    hint: const Text('Select target account'),
                    isExpanded: true,
                    items: targetAccounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                    onChanged: (val) => setState(() => _selectedTargetId = val),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text('Redemption Amount', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navy),
                  decoration: const InputDecoration(border: InputBorder.none, prefixText: 'PHP ', hintText: '0.00'),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: handleRedeem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bpiRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Redeem Funds', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
