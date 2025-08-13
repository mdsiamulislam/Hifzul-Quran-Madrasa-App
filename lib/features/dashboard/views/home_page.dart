import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hifzul_quran_madrasa/core/credintial/credintial_data.dart';
import 'package:hifzul_quran_madrasa/core/utils/snackbar_helper.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../core/utils/spacing.dart';
import '../../../theme/colors.dart';
import '../../sms_service/views/send_sms_page.dart';
import '../../students/views/student_list_page.dart';
import '../widgets/header_widget.dart';
import '../widgets/welcome_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int totalStudents = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Fetch students from server
    _getStudents();
  }

  void _getStudents() async {
    final response = await http.get(
      Uri.parse(CredintialData.apiLink),
    );
    print("Response Status for server: ${response.statusCode}");

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        totalStudents = responseBody['data'].length;
        students = List<Map<String, dynamic>>.from(responseBody['data']);
      });
    } else {
      // Handle error
      print("Failed to fetch students: ${response.statusCode}");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0F23),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                ],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Header Section
                      HeaderWidget(context: context),

                      // Main Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              // Welcome Section
                              WelcomeWidget(),

                              Spacing.h24,

                              // Action Cards
                              Expanded(
                                child: _buildActionCards(context),
                              ),

                              // Quick Stats
                              _buildQuickStats(
                                totalStudents,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/anim/hqm.json',
                      repeat: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      children: [
        // Main Action Cards
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: "Students",
                  subtitle: "Manage Records",
                  icon: Icons.people_outline,
                  gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StudentListPage(
                      students: students,
                    ),
                    ),
                  ),

                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: "SMS Service",
                  subtitle: "Send Messages",
                  icon: Icons.message_outlined,
                  gradient: const [Color(0xFF11998e), Color(0xFF38ef7d)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SendSmsPage(
                      students: students
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Secondary Action Cards
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: _buildSecondaryCard(
                  title: "Attendance",
                  icon: Icons.checklist_outlined,
                  gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
                  onTap: () {
                    // TODO: Navigate to attendance page
                    SnackbarHelper.showInfo(
                      context,
                      "Coming Soon!",
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryCard(
                  title: "Reports",
                  icon: Icons.analytics_outlined,
                  gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  onTap: () {
                    // TODO: Navigate to reports page
                    SnackbarHelper.showInfo(
                      context,
                      "Coming Soon!",
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryCard(
                  title: "Settings",
                  icon: Icons.settings_outlined,
                  gradient: const [Color(0xFFa8edea), Color(0xFFfed6e3)],
                  onTap: () {
                    // TODO: Navigate to settings page
                    SnackbarHelper.showInfo(
                      context,
                      "Coming Soon!",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryCard({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int totalStudents) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildStatItem("Total Students", totalStudents.toString(), Icons.people),
          const SizedBox(width: 20),
          Container(
            height: 30,
            width: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 20),
          _buildStatItem("Messages Sent", "2.4K", Icons.message),
          const SizedBox(width: 20),
          Container(
            height: 30,
            width: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(width: 20),
          _buildStatItem("Attendance", "94%", Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF00D4FF),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


