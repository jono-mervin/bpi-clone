import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';
import '../../transfers/screens/transfer_money_screen.dart';
import '../../transfers/screens/pay_bills_screen.dart';
import '../../more/screens/my_statements_screen.dart';
import '../../../core/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:neobank_ph/features/auth/screens/deposit_screen.dart';
import '../../../core/utils/responsive.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  final Account account;
  const AccountDetailsScreen({super.key, required this.account});

  @override
  ConsumerState<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  bool _showDetails = true;

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    final transactions = ref.watch(transactionsProvider);
    final accountTransactions = transactions.where((tx) => tx.accountId == widget.account.id).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Deposit accounts',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.s),
            // Main Account Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.s),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8.s,
                    offset: Offset(0, 4.s),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.s),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.account.name,
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.navy, size: 20.s),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(16.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available balance',
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        ),
                        SizedBox(height: 4.s),
                        Text(
                          'PHP ${NumberFormat('#,##0.00', 'en_US').format(widget.account.balance)}',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.s),
                        Text(
                          'Total balance',
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        ),
                        SizedBox(height: 4.s),
                        Text(
                          'PHP ${NumberFormat('#,##0.00', 'en_US').format(widget.account.balance)}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => setState(() => _showDetails = !_showDetails),
                          child: Row(
                            children: [
                              Icon(
                                _showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: AppColors.bpiTeal,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _showDetails ? 'Hide details' : 'Show details',
                                style: const TextStyle(
                                  color: AppColors.bpiTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_showDetails) ...[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildInfoItem('Account number', widget.account.number),
                              const SizedBox(width: 40),
                              _buildInfoItem('Account type', widget.account.type),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoItem('Branch', widget.account.branch),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  _buildActionItem(
                    icon: Icons.swap_horiz,
                    label: 'Transfer money',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferMoneyScreen())),
                  ),
                  const Divider(height: 1),
                  _buildActionItem(
                    icon: Icons.receipt_long,
                    label: 'Pay bills',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PayBillsScreen())),
                  ),
                  const Divider(height: 1),
                  _buildActionItem(
                    icon: Icons.add_circle_outline,
                    label: 'Deposit money',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DepositScreen())),
                  ),
                  const Divider(height: 1),
                  _buildActionItem(
                    icon: Icons.description_outlined,
                    label: 'My Statements',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyStatementsScreen())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Transaction History Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction history',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (accountTransactions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              'You have no transactions to display.',
                              style: TextStyle(color: AppColors.navy, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...accountTransactions.map((tx) => _buildTransactionItem(tx)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
        SizedBox(height: 2.s),
        Text(
          value,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: AppColors.bpiTeal),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.bpiTeal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx) {
    final dateStr = DateFormat('MMM dd, yyyy').format(tx.date);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.title,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '${tx.isCredit ? '+' : '-'}${NumberFormat('#,##0.00', 'en_US').format(tx.amount)}',
                style: TextStyle(
                  color: tx.isCredit ? Colors.green : AppColors.navy,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
