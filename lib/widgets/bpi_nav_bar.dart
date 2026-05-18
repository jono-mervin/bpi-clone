import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../core/utils/responsive.dart';

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
      height: 80.s,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80.s),
            painter: BNBCustomPainter(),
          ),
          SizedBox(
            height: 80.s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                if (item.icon == null) return SizedBox(width: 70.s);
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
            SizedBox(height: 18.s),
            Icon(
              icon,
              color: isSelected ? AppColors.bpiRed : Colors.grey.shade600,
              size: 26.s,
            ),
            SizedBox(height: 4.s),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.bpiRed : Colors.grey.shade600,
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4.s),
                height: 2.s,
                width: 25.s,
                decoration: BoxDecoration(
                  color: AppColors.bpiRed,
                  borderRadius: BorderRadius.circular(1.s),
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
    path.moveTo(0, 25.s);
    path.quadraticBezierTo(0, 8.s, 25.s, 8.s);
    
    path.lineTo(size.width * 0.35, 8.s);
    path.cubicTo(
      size.width * 0.40, 8.s, 
      size.width * 0.38, 48.s, 
      size.width * 0.50, 48.s,
    );
    path.cubicTo(
      size.width * 0.62, 48.s, 
      size.width * 0.60, 8.s, 
      size.width * 0.65, 8.s,
    );
    
    path.lineTo(size.width - 25.s, 8.s);
    path.quadraticBezierTo(size.width, 8.s, size.width, 25.s);
    
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
      width: 56.s,
      height: 56.s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.bpiRed.withValues(alpha: 0.4),
            blurRadius: 12.s,
            spreadRadius: 1.s,
            offset: Offset(0, 3.s),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.bpiRed,
        elevation: 0,
        shape: const CircleBorder(),
        child: Icon(Icons.qr_code_scanner, color: AppColors.white, size: 28.s),
      ),
    );
  }
}
