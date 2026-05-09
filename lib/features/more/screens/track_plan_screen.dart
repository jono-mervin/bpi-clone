import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class TrackPlanScreen extends StatelessWidget {
  const TrackPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.navy), onPressed: () => Navigator.pop(context)),
        title: const Text('Track & Plan', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bpiTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.insights, color: AppColors.bpiTeal),
                      SizedBox(width: 10),
                      Text('Spending Analysis', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Get a better understanding of where your money goes with our automatic spending categorization.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bpiTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Enroll for free', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Financial Goals', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            _buildGoalCard('Emergency Fund', 'Target: PHP 100,000', 0.4, Colors.blue),
            _buildGoalCard('Dream Vacation', 'Target: PHP 50,000', 0.1, Colors.orange),
            _buildGoalCard('New Car', 'Target: PHP 500,000', 0.05, Colors.purple),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: AppColors.bpiTeal),
                label: const Text('Create a new goal', style: TextStyle(color: AppColors.bpiTeal, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String title, String target, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold)),
              Text('${(progress * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(target, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
