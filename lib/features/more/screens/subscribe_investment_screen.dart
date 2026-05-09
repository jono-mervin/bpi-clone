import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../widgets/bpi_loader.dart';
import '../../transfers/screens/transaction_success_screen.dart';

class SubscribeInvestmentScreen extends ConsumerStatefulWidget {
  const SubscribeInvestmentScreen({super.key});

  @override
  ConsumerState<SubscribeInvestmentScreen> createState() => _SubscribeInvestmentScreenState();
}

class _SubscribeInvestmentScreenState extends ConsumerState<SubscribeInvestmentScreen> {
  String? _selectedSourceId;
  String? _selectedFund = 'BPI Invest Short Term Fund';
  final _amountController = TextEditingController();

  final List<String> _funds = [
    'BPI Invest Short Term Fund',
    'BPI Invest Money Market Fund',
    'BPI Invest US Dollar Income Fund',
    'BPI Invest Equity Index Fund',
  ];

  void _handleSubscribe() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedSourceId == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a source account and enter an amount')));
      return;
    }

    final accounts = ref.read(accountsProvider);
    final account = accounts.firstWhere((a) => a.id == _selectedSourceId);

    if (account.balance < amount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
      return;
    }

    // Show loading
    BPILoader.show(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    BPILoader.hide(context);

    // Perform subscription
    ref.read(accountsProvider.notifier).transfer(_selectedSourceId!, amount);
    
    // Record transaction
    final referenceId = 'SUB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    ref.read(transactionsProvider.notifier).addTransaction(
      Transaction(
        id: referenceId,
        title: 'Investment Subscription',
        subtitle: _selectedFund!,
        amount: amount,
        date: DateTime.now(),
        type: TransactionType.investment,
        accountId: _selectedSourceId,
      ),
    );

    // Add investment account simulation
    ref.read(accountsProvider.notifier).addAccount(Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _selectedFund!,
      number: 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      balance: amount,
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          title: 'Subscription Successful!',
          amount: amount,
          recipient: _selectedFund!,
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
        title: const Text('Subscribe', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Fund', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFund,
                  isExpanded: true,
                  items: _funds.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  onChanged: (val) => setState(() => _selectedFund = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Source Account', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSourceId,
                  hint: const Text('Select source'),
                  isExpanded: true,
                  items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text('${a.name} (PHP ${a.balance.fCurrency})'))).toList(),
                  onChanged: (val) => setState(() => _selectedSourceId = val),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Investment Amount', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.navy),
                decoration: const InputDecoration(border: InputBorder.none, prefixText: 'PHP ', hintText: '0.00'),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Subscribe Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
