import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class MyStatementsScreen extends StatelessWidget {
  const MyStatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('My Statements', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 12,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final month = DateTime.now().month - index;
          final year = month <= 0 ? DateTime.now().year - 1 : DateTime.now().year;
          final adjustedMonth = month <= 0 ? month + 12 : month;
          final dateStr = '${_getMonthName(adjustedMonth)} $year';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.iconBgPurple, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.deepPurple),
            ),
            title: Text(
              'Electronic Statement',
              style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(dateStr, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.download_outlined, color: AppColors.bpiTeal),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading statement for $dateStr...')));
            },
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
