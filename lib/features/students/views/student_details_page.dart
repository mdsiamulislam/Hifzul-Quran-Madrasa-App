import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/colors.dart';
import '../../sms_service/views/send_sms_page.dart';

class StudentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> student;
  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF1E40AF),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(student),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF1E40AF),
                      unselectedLabelColor: const Color(0xFF6B7280),
                      indicatorColor: const Color(0xFF1E40AF),
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: "Personal", icon: Icon(Icons.person, size: 16)),
                        Tab(text: "Academic", icon: Icon(Icons.school, size: 16)),
                        Tab(text: "Finance", icon: Icon(Icons.account_balance_wallet, size: 16)),
                        Tab(text: "Medical", icon: Icon(Icons.medical_information, size: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalTab(student),
              _buildAcademicTab(student),
              _buildFinanceTab(student),
              _buildMedicalTab(student),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, student),
    );
  }

  Widget _buildHeader(Map<String, dynamic> student) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E40AF),
            Color(0xFF3B82F6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Student Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  student['gender'] == 'Female' ? Icons.woman : Icons.man,
                  color: Colors.white,
                  size: 50,
                ),
              ),

              const SizedBox(height: 16),

              // Student Name
              Text(
                student['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Student ID and Class
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "ID: ${student['id']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${student['class']}-${student['section']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickStat("Attendance", "${student['attendancePercentage']}%"),
                  _buildQuickStat("Surahs", "${student['totalSurahMemorized']}"),
                  _buildQuickStat("Rating", "${student['academicRating']}/5"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalTab(Map<String, dynamic> student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoSection(
            "Personal Information",
            Icons.person_outline,
            [
              _buildInfoRow("Full Name", student['name']),
              _buildInfoRow("Father's Name", student['fatherName']),
              _buildInfoRow("Mother's Name", student['motherName']),
              _buildInfoRow("Date of Birth", student['dateOfBirth']),
              _buildInfoRow("Age", "${student['age']} years"),
              _buildInfoRow("Gender", student['gender']),
              _buildInfoRow("Status", student['status']),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoSection(
            "Contact Information",
            Icons.contact_phone_outlined,
            [
              _buildInfoRow("Student Phone", student['phone'], isCopiable: true),
              _buildInfoRow("Guardian Phone", student['guardianPhone'], isCopiable: true),
              _buildInfoRow("Emergency Contact", student['emergencyContact'], isCopiable: true),
              _buildInfoRow("Email", student['email'], isCopiable: true),
              _buildInfoRow("Address", student['address']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicTab(Map<String, dynamic> student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoSection(
            "Academic Details",
            Icons.school_outlined,
            [
              _buildInfoRow("Class", "${student['class']}-${student['section']}"),
              _buildInfoRow("Roll Number", "${student['rollNumber']}"),
              _buildInfoRow("Admission Date", student['admissionDate']),
              _buildInfoRow("Last Attendance", student['lastAttendance']),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoSection(
            "Quran Progress",
            Icons.menu_book_outlined,
            [
              _buildInfoRow("Current Progress", student['currentProgress']),
              _buildInfoRow("Total Surahs Memorized", "${student['totalSurahMemorized']}"),
            ],
          ),

          const SizedBox(height: 16),

          // Performance Chart
          _buildPerformanceCard(student),

          const SizedBox(height: 16),

          _buildInfoSection(
            "Extra Activities",
            Icons.sports_soccer_outlined,
            student['extraActivities'].map<Widget>((activity) =>
                _buildActivityChip(activity)
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTab(Map<String, dynamic> student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Fee Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: student['feeStatus'] == 'Paid'
                    ? [Colors.green[400]!, Colors.green[600]!]
                    : [Colors.red[400]!, Colors.red[600]!],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  student['feeStatus'] == 'Paid'
                      ? Icons.check_circle_outline
                      : Icons.warning_outlined,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  "Fee Status: ${student['feeStatus']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Monthly Fee: ৳${student['monthlyFee']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Payment History (Mock Data)
          _buildInfoSection(
            "Recent Payments",
            Icons.payment_outlined,
            [
              _buildPaymentRow("August 2024", "৳${student['monthlyFee']}", "Paid", true),
              _buildPaymentRow("July 2024", "৳${student['monthlyFee']}", "Paid", true),
              _buildPaymentRow("June 2024", "৳${student['monthlyFee']}", "Paid", true),
              _buildPaymentRow("May 2024", "৳${student['monthlyFee']}", "Paid", true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalTab(Map<String, dynamic> student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoSection(
            "Medical Information",
            Icons.medical_information_outlined,
            [
              _buildInfoRow("Blood Group", student['bloodGroup']),
              _buildInfoRow("Medical Info", student['medicalInfo']),
              _buildInfoRow("Emergency Contact", student['emergencyContact'], isCopiable: true),
            ],
          ),

          const SizedBox(height: 16),

          // Health Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.health_and_safety_outlined,
                  color: Colors.green[600],
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  "Health Status: Good",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Last checkup: January 2024",
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1E40AF), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isCopiable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isCopiable)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$label copied to clipboard")),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChip(String activity) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        activity,
        style: TextStyle(
          color: Colors.blue[700],
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(Map<String, dynamic> student) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, color: Color(0xFF1E40AF)),
              SizedBox(width: 8),
              Text(
                "Performance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar("Attendance", student['attendancePercentage'], Colors.green),
          const SizedBox(height: 16),
          _buildProgressBar("Academic Rating", student['academicRating'] * 20, Colors.blue),
          const SizedBox(height: 16),
          _buildProgressBar("Behavior Rating", student['behaviorRating'] * 20, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, dynamic value, Color color) {
    final percentage = value is int ? value.toDouble() : value.toDouble();
    final displayValue = value is int ? value : value.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label.contains("Rating") ? "${displayValue / 20}/5" : "$displayValue%",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String month, String amount, String status, bool isPaid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isPaid ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              month,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isPaid ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call, color: Colors.white),
              label: const Text("Call", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: Implement call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Calling feature coming soon!")),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.message, color: Colors.white),
              label: const Text("Send SMS", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => SendSmsPage(preselectedStudent: student),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}