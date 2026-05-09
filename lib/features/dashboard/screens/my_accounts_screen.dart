import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/utils/responsive.dart';
import 'package:neobank_ph/features/notifications/screens/notifications_screen.dart';
import 'account_details_screen.dart';
import '../../more/screens/manage_accounts_screen.dart';

// --- Carousel Slide Data Model ---
class _AlertSlide {
  final String date;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? linkText;

  const _AlertSlide({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.linkText,
  });
}

final _slides = const [
  _AlertSlide(
    date: 'May 07',
    title: 'Fake BPI Text Alert 🚨',
    subtitle: 'Got a BPI text with a link? It could be a scam. Stay alert.',
    icon: Icons.warning_amber_rounded,
    iconColor: Color(0xFFFFA726),
  ),
  _AlertSlide(
    date: 'Apr 24',
    title: 'Fake App Download Alert',
    subtitle: 'Scammers may ask you to install fake apps. Learn how to spot this scam.',
    icon: Icons.phone_android_outlined,
    iconColor: Color(0xFFFFA726),
  ),
  _AlertSlide(
    date: '',
    title: 'Have a look at your inbox',
    subtitle: 'Check out the personal finance insights that you have so far',
    icon: Icons.move_to_inbox_outlined,
    iconColor: Color(0xFF546E7A),
    linkText: 'Go to Insights Inbox',
  ),
  _AlertSlide(
    date: 'May 05',
    title: 'New BPI Feature Available',
    subtitle: 'You can now set spending limits on your BPI credit card directly in the app.',
    icon: Icons.credit_card_outlined,
    iconColor: AppColors.bpiTeal,
  ),
  _AlertSlide(
    date: 'May 03',
    title: 'Phishing Email Alert',
    subtitle: 'Beware of fake BPI emails asking for your credentials. BPI will never ask for your password.',
    icon: Icons.email_outlined,
    iconColor: Color(0xFFEF5350),
  ),
  _AlertSlide(
    date: 'May 01',
    title: 'Earn Rewards with BPI Credit',
    subtitle: 'Use your BPI credit card for everyday purchases and earn points redeemable for exciting rewards.',
    icon: Icons.stars_outlined,
    iconColor: Color(0xFF8E24AA),
  ),
];

class MyAccountsScreen extends ConsumerStatefulWidget {
  const MyAccountsScreen({super.key});

  @override
  ConsumerState<MyAccountsScreen> createState() => _MyAccountsScreenState();
}

class _MyAccountsScreenState extends ConsumerState<MyAccountsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    final accounts = ref.watch(accountsProvider);
    final isExpanded = ref.watch(accountsExpandedProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                        Text(
                          user.name.split(' ')[0],
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(isPublic: false),
                      )),
                      child: const Icon(Icons.mail_outline, color: AppColors.navy, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              // --- Auto-playing Carousel ---
              SizedBox(
                height: 220.s,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return _buildSlideCard(slide);
                  },
                ),
              ),

              // Dot indicators
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.s),
                    width: _currentPage == index ? 18.s : 8.s,
                    height: 8.s,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.s),
                    ),
                  )),
                ),
              ),
              const SizedBox(height: 25),

              // Accounts Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.iconBgGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.savings_outlined, color: AppColors.bpiTeal, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Deposit accounts',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.bpiTeal,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${accounts.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                            onPressed: () => ref.read(accountsExpandedProvider.notifier).toggle(),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      const Divider(height: 1),
                      if (accounts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No accounts found.', style: TextStyle(color: Colors.grey)),
                        )
                      else
                        ...accounts.asMap().entries.map((entry) {
                          final account = entry.value;
                          final index = entry.key;
                          return Column(
                            children: [
                              _buildAccountItem(account),
                              if (index < accounts.length - 1)
                                const Divider(height: 1, indent: 15, endIndent: 15),
                            ],
                          );
                        }),
                    ],
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageAccountsScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.filter_none_outlined, color: AppColors.bpiTeal, size: 20),
                      const SizedBox(width: 10),
                      const Text(
                        'Manage My Accounts',
                        style: TextStyle(
                          color: AppColors.bpiTeal,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlideCard(_AlertSlide slide) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.s),
      padding: EdgeInsets.all(20.s),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.s),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.s,
            offset: Offset(0, 5.s),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text content
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (slide.date.isNotEmpty) ...[
                  Row(
                    children: [
                      Container(
                        width: 8.s,
                        height: 8.s,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        slide.date,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ] else ...[
                  Container(
                    width: 8.s,
                    height: 8.s,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  slide.title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  slide.subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                ),
                if (slide.linkText != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    slide.linkText!,
                    style: const TextStyle(
                      color: AppColors.bpiTeal,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Icon on the right
          Expanded(
            flex: 2,
            child: Center(
              child: Icon(slide.icon, color: slide.iconColor, size: 80.s),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(Account account) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountDetailsScreen(account: account)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              account.number,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'PHP ',
                        style: GoogleFonts.openSans(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        NumberFormat('#,##0.00', 'en_US').format(account.balance),
                        style: GoogleFonts.inconsolata(
                          color: AppColors.navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Available balance',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
