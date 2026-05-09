import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AppSettingsScreen extends StatelessWidget {
  final String title;
  final List<AppSettingItem> items;

  const AppSettingsScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: Text(title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon, color: item.color),
            ),
            title: Text(item.title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
            subtitle: Text(item.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: item.isToggle 
              ? Switch(value: item.initialValue, onChanged: (v) {}, activeThumbColor: AppColors.bpiTeal)
              : const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: item.isToggle ? null : () {},
          );
        },
      ),
    );
  }
}

class AppSettingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isToggle;
  final bool initialValue;

  const AppSettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isToggle = false,
    this.initialValue = false,
  });
}
