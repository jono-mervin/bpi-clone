import 'package:flutter_riverpod/flutter_riverpod.dart';

class Account {
  final String id;
  final String name;
  final String number;
  final String type;
  final String branch;
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.number,
    this.type = 'Savings Account',
    this.branch = 'BPI - OPEN BANKING DIGI BRANCH 12',
    required this.balance,
  });

  Account copyWith({String? name, double? balance}) {
    return Account(
      id: id,
      name: name ?? this.name,
      number: number,
      type: type,
      branch: branch,
      balance: balance ?? this.balance,
    );
  }
}

class AccountNotifier extends Notifier<List<Account>> {
  @override
  List<Account> build() {
    return [];
  }

  void updateAccountNames(String userName) {
    state = [
      for (final account in state)
        account.copyWith(
          name: account.name.replaceAll('Account', userName.toUpperCase()),
        ),
    ];
  }

  void transfer(String fromId, double amount) {
    state = [
      for (final account in state)
        if (account.id == fromId)
          account.copyWith(balance: account.balance - amount)
        else
          account,
    ];
  }

  void receive(String toId, double amount) {
    state = [
      for (final account in state)
        if (account.id == toId)
          account.copyWith(balance: account.balance + amount)
        else
          account,
    ];
  }

  void addAccount(Account account) {
    state = [...state, account];
  }

  void renameAccount(String id, String newName) {
    state = [
      for (final account in state)
        if (account.id == id)
          account.copyWith(name: newName)
        else
          account,
    ];
  }
}

final accountsProvider = NotifierProvider<AccountNotifier, List<Account>>(AccountNotifier.new);

class BalanceVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  
  void toggle() => state = !state;
}

final balanceVisibilityProvider = NotifierProvider<BalanceVisibilityNotifier, bool>(BalanceVisibilityNotifier.new);

class AccountsExpandedNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  
  void toggle() => state = !state;
}

final accountsExpandedProvider = NotifierProvider<AccountsExpandedNotifier, bool>(AccountsExpandedNotifier.new);
