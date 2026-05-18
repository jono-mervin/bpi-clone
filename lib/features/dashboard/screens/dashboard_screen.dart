import 'package:flutter/material.dart';
import '../../../widgets/bpi_nav_bar.dart';
import '../../transfers/screens/move_money_screen.dart';
import '../../products/screens/products_screen.dart';
import '../../more/screens/more_screen.dart'; // We'll create this next
import '../../qr/screens/qr_scanner_screen.dart';
import 'my_accounts_screen.dart'; // Renaming the previous dashboard to this

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MyAccountsScreen(),
    const MoveMoneyScreen(),
    const ProductsScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Map _currentIndex (0-3) to NavBar index (0,1,3,4)
    int navBarIndex = _currentIndex;
    if (_currentIndex >= 2) navBarIndex++;

    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: _screens[_currentIndex],
      bottomNavigationBar: BPINavBar(
        currentIndex: navBarIndex,
        onTap: (index) {
          if (index == 2) return; // FAB space
          setState(() {
            _currentIndex = index > 2 ? index - 1 : index;
          });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: BPIFAB(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerScreen()),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
