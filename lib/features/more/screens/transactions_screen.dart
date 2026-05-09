import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/transaction_provider.dart' as model;
import '../../../core/providers/transaction_provider.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _searchQuery = '';
  model.TransactionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);
    
    final filteredTransactions = transactions.where((t) {
      final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           t.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == null || t.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search transactions',
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(null, 'All'),
                      const SizedBox(width: 8),
                      _buildFilterChip(model.TransactionType.transfer, 'Transfers'),
                      const SizedBox(width: 8),
                      _buildFilterChip(model.TransactionType.payBills, 'Bills'),
                      const SizedBox(width: 8),
                      _buildFilterChip(model.TransactionType.load, 'Load'),
                      const SizedBox(width: 8),
                      _buildFilterChip(model.TransactionType.investment, 'Invest'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: filteredTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      final isFirstInDate = index == 0 || 
                          DateFormat('yyyy-MM-dd').format(transaction.date) != 
                          DateFormat('yyyy-MM-dd').format(filteredTransactions[index - 1].date);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isFirstInDate) _buildDateHeader(transaction.date),
                          _buildTransactionItem(transaction),
                          if (index != filteredTransactions.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(left: 75),
                              child: Divider(height: 1, color: AppColors.divider),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(model.TransactionType? type, String label) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bpiRed : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.bpiRed : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    String label;
    if (checkDate == today) {
      label = 'TODAY';
    } else if (checkDate == yesterday) {
      label = 'YESTERDAY';
    } else {
      label = DateFormat('MMM dd, yyyy').format(date).toUpperCase();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(model.Transaction transaction) {
    IconData iconData;
    Color iconColor;
    Color iconBg;

    switch (transaction.type) {
      case model.TransactionType.transfer:
        iconData = Icons.swap_horiz;
        iconColor = Colors.blue;
        iconBg = AppColors.iconBgBlue;
        break;
      case model.TransactionType.payBills:
        iconData = Icons.receipt_long;
        iconColor = Colors.deepPurple;
        iconBg = AppColors.iconBgPurple;
        break;
      case model.TransactionType.load:
        iconData = Icons.phone_android;
        iconColor = Colors.teal;
        iconBg = AppColors.iconBgTeal;
        break;
      case model.TransactionType.investment:
        iconData = Icons.trending_up;
        iconColor = Colors.orange;
        iconBg = AppColors.iconBgOrange;
        break;
      default:
        iconData = Icons.receipt;
        iconColor = Colors.grey;
        iconBg = Colors.grey.shade100;
    }

    final currencyFormat = NumberFormat.currency(symbol: 'PHP ', decimalDigits: 2);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBg,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: iconColor, size: 24),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            transaction.subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('hh:mm a').format(transaction.date),
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.isCredit ? '+' : '-'}${currencyFormat.format(transaction.amount)}',
            style: TextStyle(
              color: transaction.isCredit ? Colors.green : AppColors.navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'SUCCESS',
              style: TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 20),
          Text(
            'No transactions found',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
