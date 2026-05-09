import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';

class ManageAccountsScreen extends ConsumerWidget {
  const ManageAccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Manage My Accounts', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.bpiTeal),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                      Text(account.number, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                  onPressed: () => _showRenameDialog(context, ref, account),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Account account) {
    final controller = TextEditingController(text: account.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Account'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Account Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(accountsProvider.notifier).renameAccount(account.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
