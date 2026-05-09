import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/account_provider.dart';

class ManageRSPScreen extends ConsumerStatefulWidget {
  final String mode; // 'setup' or 'amend'
  const ManageRSPScreen({super.key, required this.mode});

  @override
  ConsumerState<ManageRSPScreen> createState() => _ManageRSPScreenState();
}

class _ManageRSPScreenState extends ConsumerState<ManageRSPScreen> {
  String? _selectedSourceId;
  String? _selectedFund = 'BPI Invest Short Term Fund';
  String _selectedFrequency = 'Monthly';
  final _amountController = TextEditingController();
  final _dayController = TextEditingController(text: '15');

  final List<String> _funds = [
    'BPI Invest Short Term Fund',
    'BPI Invest Money Market Fund',
    'BPI Invest Equity Index Fund',
  ];

  final List<String> _frequencies = ['Monthly', 'Quarterly'];

  void _handleRSP() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedSourceId == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.mode == 'setup' ? 'RSP set up successfully!' : 'RSP amended successfully!'),
        backgroundColor: AppColors.bpiTeal,
      ),
    );
    Navigator.pop(context);
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
        title: Text(widget.mode == 'setup' ? 'Set up RSP' : 'Amend RSP', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Investment Fund', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 25),
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
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Frequency', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFrequency,
                            isExpanded: true,
                            items: _frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                            onChanged: (val) => setState(() => _selectedFrequency = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Day of Month', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: InputBorder.none, hintText: '1-31'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text('Contribution Amount', style: TextStyle(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
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
                onPressed: _handleRSP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bpiRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(widget.mode == 'setup' ? 'Set up RSP' : 'Save Changes', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
