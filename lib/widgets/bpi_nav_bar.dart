import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class BPINavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BPINavItem>? customItems;

  const BPINavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.customItems,
  });

  @override
  Widget build(BuildContext context) {
    final items = customItems ?? [
      const BPINavItem(icon: Icons.account_balance_wallet_outlined, label: 'My Accounts'),
      const BPINavItem(icon: Icons.swap_horiz, label: 'Move money'),
      const BPINavItem(icon: null, label: ''), // Space for FAB
      const BPINavItem(icon: Icons.filter_none_outlined, label: 'Products'),
      const BPINavItem(icon: Icons.menu, label: 'More'),
    ];

    return SizedBox(
      height: 85,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 85),
            painter: BNBCustomPainter(),
          ),
          SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                if (item.icon == null) return const SizedBox(width: 60);
                return _buildNavItem(index, item.icon!, item.label);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Icon(
              icon,
              color: isSelected ? AppColors.bpiRed : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.bpiRed : Colors.grey.shade600,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.bpiRed,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BPINavItem {
  final IconData? icon;
  final String label;
  const BPINavItem({this.icon, required this.label});
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFF8F9FA)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(0, 10, 30, 10);
    
    path.lineTo(size.width * 0.35, 10);
    path.cubicTo(
      size.width * 0.40, 10, 
      size.width * 0.38, 55, 
      size.width * 0.50, 55,
    );
    path.cubicTo(
      size.width * 0.62, 55, 
      size.width * 0.60, 10, 
      size.width * 0.65, 10,
    );
    
    path.lineTo(size.width - 30, 10);
    path.quadraticBezierTo(size.width, 10, size.width, 30);
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path.shift(const Offset(0, -2)), Colors.black.withValues(alpha: 0.3), 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BPIFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const BPIFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.bpiRed.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.bpiRed,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: AppColors.white, size: 32),
      ),
    );
  }
}
