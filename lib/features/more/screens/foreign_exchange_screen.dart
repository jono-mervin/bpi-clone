import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../widgets/bpi_loader.dart';
import '../../transfers/screens/transaction_success_screen.dart';

class ForeignExchangeScreen extends ConsumerStatefulWidget {
  final String type; // 'USD_TO_PHP' or 'PHP_TO_USD'
  const ForeignExchangeScreen({super.key, required this.type});

  @override
  ConsumerState<ForeignExchangeScreen> createState() => _ForeignExchangeScreenState();
}

class _ForeignExchangeScreenState extends ConsumerState<ForeignExchangeScreen> {
  String? _selectedSourceId;
  String? _selectedTargetId;
  final _amountController = TextEditingController();
  final double _rate = 56.24; // Mock exchange rate

  void _handleExchange() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedSourceId == null || _selectedTargetId == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    final accounts = ref.read(accountsProvider);
    final source = accounts.firstWhere((a) => a.id == _selectedSourceId);
    
    if (source.balance < amount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance')));
      return;
    }

    // Show loading
    BPILoader.show(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    BPILoader.hide(context);

    final convertedAmount = widget.type == 'USD_TO_PHP' ? amount * _rate : amount / _rate;

    // Perform exchange
    ref.read(accountsProvider.notifier).transfer(_selectedSourceId!, amount);
    ref.read(accountsProvider.notifier).receive(_selectedTargetId!, convertedAmount);

    // Record transaction
    final referenceId = 'FX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    ref.read(transactionsProvider.notifier).addTransaction(
      Transaction(
        id: referenceId,
        title: 'Foreign Exchange',
        subtitle: widget.type == 'USD_TO_PHP' ? 'USD to PHP' : 'PHP to USD',
        amount: convertedAmount,
        date: DateTime.now(),
        type: TransactionType.exchange,
        isCredit: true,
        accountId: _selectedTargetId,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionSuccessScreen(
          title: 'Exchange Successful!',
          amount: amount,
          recipient: 'Target Account',
          referenceId: referenceId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final isUsdToPhp = widget.type == 'USD_TO_PHP';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: Text(isUsdToPhp ? 'USD to PHP' : 'PHP to USD', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Rate', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('1 USD = $_rate PHP', style: const TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
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
                  items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text('${a.name} (${isUsdToPhp ? 'USD' : 'PHP'} ${a.balance.fCurrency})'))).toList(),
                  onChanged: (val) => setState(() => _selectedSourceId = val),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Target Account', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTargetId,
                  hint: const Text('Select target'),
                  isExpanded: true,
                  items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (val) => setState(() => _selectedTargetId = val),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text('Amount to Exchange (${isUsdToPhp ? 'USD' : 'PHP'})', style: const TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.navy),
                decoration: InputDecoration(border: InputBorder.none, prefixText: isUsdToPhp ? '\$ ' : 'PHP ', hintText: '0.00'),
                onChanged: (val) => setState(() {}),
              ),
            ),
            if (_amountController.text.isNotEmpty) ...[
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('You will receive: ', style: TextStyle(color: Colors.grey)),
                  Text(
                    '${isUsdToPhp ? 'PHP' : '\$'} ${((double.tryParse(_amountController.text) ?? 0) * (isUsdToPhp ? _rate : 1 / _rate)).fCurrency}',
                    style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleExchange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Confirm Exchange', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
