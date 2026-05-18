import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransactionType {
  transfer,
  payBills,
  load,
  investment,
  withdrawal,
  exchange,
  deposit,
  other
}

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final bool isCredit;
  final String status;

  final String? accountId; // null means all/general

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    this.isCredit = false,
    this.status = 'Success',
    this.accountId,
  });
}

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    // Initial dummy transactions for auditing/demo
    return [
      Transaction(
        id: '1',
        title: 'Transfer to JOE LOPEZ',
        subtitle: 'BPI - 1234567890',
        amount: 1500.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.transfer,
        accountId: '1',
      ),
      Transaction(
        id: '2',
        title: 'Meralco Bill Payment',
        subtitle: 'Reference: 987654321',
        amount: 3240.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.payBills,
        accountId: '1',
      ),
      Transaction(
        id: '3',
        title: 'GCash Cash-in',
        subtitle: '09171234567',
        amount: 500.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.load,
        accountId: '1',
      ),
      Transaction(
        id: '4',
        title: 'Investment Subscription',
        subtitle: 'BPI Invest ALFM Money Market Fund',
        amount: 10000.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.investment,
        accountId: '1',
      ),
    ];
  }

  void addTransaction(Transaction transaction) {
    state = [transaction, ...state];
  }
}

final transactionsProvider = NotifierProvider<TransactionNotifier, List<Transaction>>(TransactionNotifier.new);
