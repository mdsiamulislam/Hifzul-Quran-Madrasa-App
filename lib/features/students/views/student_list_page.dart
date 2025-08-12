import 'package:flutter/material.dart';
import 'student_details_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  String searchQuery = '';
  String selectedClass = 'All';

  static final List<Map<String, dynamic>> students = [
    {
      "id": "S001",
      "name": "Abdullah Al Noman",
      "fatherName": "Md. Abdur Rahman",
      "motherName": "Fatema Khatun",
      "dateOfBirth": "2010-03-15",
      "age": 14,
      "gender": "Male",
      "phone": "01700000001",
      "guardianPhone": "01800000001",
      "email": "abdullah.noman@email.com",
      "address": "123 Main Street, Dhaka-1205",
      "class": "Hifz-3",
      "section": "A",
      "rollNumber": 15,
      "admissionDate": "2020-01-15",
      "currentProgress": "Surah Al-Baqarah completed",
      "totalSurahMemorized": 8,
      "attendancePercentage": 95.5,
      "monthlyFee": 2500,
      "feeStatus": "Paid",
      "bloodGroup": "B+",
      "medicalInfo": "No known allergies",
      "emergencyContact": "01900000001",
      "photo": "assets/images/student_1.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-12",
      "behaviorRating": 4.8,
      "academicRating": 4.6,
      "extraActivities": ["Naat Competition", "Arabic Calligraphy"]
    },
    {
      "id": "S002",
      "name": "Samiul Haque Rifat",
      "fatherName": "Md. Shahjahan Haque",
      "motherName": "Rashida Begum",
      "dateOfBirth": "2009-07-22",
      "age": 15,
      "gender": "Male",
      "phone": "01700000002",
      "guardianPhone": "01800000002",
      "email": "samiul.rifat@email.com",
      "address": "456 Park Road, Dhaka-1207",
      "class": "Hifz-4",
      "section": "B",
      "rollNumber": 8,
      "admissionDate": "2019-06-20",
      "currentProgress": "Surah Ali Imran ongoing",
      "totalSurahMemorized": 12,
      "attendancePercentage": 92.3,
      "monthlyFee": 3000,
      "feeStatus": "Paid",
      "bloodGroup": "A+",
      "medicalInfo": "Asthma - carries inhaler",
      "emergencyContact": "01900000002",
      "photo": "assets/images/student_2.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-12",
      "behaviorRating": 4.5,
      "academicRating": 4.8,
      "extraActivities": ["Quran Recitation", "Islamic History Quiz"]
    },
    {
      "id": "S003",
      "name": "Mahmudul Hasan Sakib",
      "fatherName": "Md. Golam Hasan",
      "motherName": "Salma Khatun",
      "dateOfBirth": "2011-11-08",
      "age": 13,
      "gender": "Male",
      "phone": "01700000003",
      "guardianPhone": "01800000003",
      "email": "mahmud.sakib@email.com",
      "address": "789 Green Avenue, Dhaka-1209",
      "class": "Hifz-2",
      "section": "A",
      "rollNumber": 22,
      "admissionDate": "2021-03-10",
      "currentProgress": "Surah An-Nisa ongoing",
      "totalSurahMemorized": 6,
      "attendancePercentage": 88.7,
      "monthlyFee": 2200,
      "feeStatus": "Pending",
      "bloodGroup": "O+",
      "medicalInfo": "Healthy",
      "emergencyContact": "01900000003",
      "photo": "assets/images/student_3.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-11",
      "behaviorRating": 4.2,
      "academicRating": 4.3,
      "extraActivities": ["Sports Day", "Community Service"]
    },
    {
      "id": "S004",
      "name": "Fatima Zahara",
      "fatherName": "Md. Ibrahim Khan",
      "motherName": "Ayesha Siddique",
      "dateOfBirth": "2010-09-14",
      "age": 14,
      "gender": "Female",
      "phone": "01700000004",
      "guardianPhone": "01800000004",
      "email": "fatima.zahara@email.com",
      "address": "321 Rose Garden, Dhaka-1203",
      "class": "Hifz-3",
      "section": "C",
      "rollNumber": 11,
      "admissionDate": "2020-08-25",
      "currentProgress": "Surah Al-Maidah completed",
      "totalSurahMemorized": 9,
      "attendancePercentage": 97.2,
      "monthlyFee": 2500,
      "feeStatus": "Paid",
      "bloodGroup": "AB+",
      "medicalInfo": "No known issues",
      "emergencyContact": "01900000004",
      "photo": "assets/images/student_4.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-12",
      "behaviorRating": 4.9,
      "academicRating": 4.7,
      "extraActivities": ["Islamic Art", "Hadith Study Circle"]
    },
    {
      "id": "S005",
      "name": "Aminul Islam Rahat",
      "fatherName": "Md. Kamal Uddin",
      "motherName": "Nasreen Akter",
      "dateOfBirth": "2012-01-30",
      "age": 12,
      "gender": "Male",
      "phone": "01700000005",
      "guardianPhone": "01800000005",
      "email": "aminul.rahat@email.com",
      "address": "654 Lake View, Dhaka-1206",
      "class": "Hifz-1",
      "section": "B",
      "rollNumber": 33,
      "admissionDate": "2022-02-14",
      "currentProgress": "Surah Al-Fatiha to An-Nas completed",
      "totalSurahMemorized": 4,
      "attendancePercentage": 91.8,
      "monthlyFee": 2000,
      "feeStatus": "Paid",
      "bloodGroup": "B-",
      "medicalInfo": "Vegetarian diet required",
      "emergencyContact": "01900000005",
      "photo": "assets/images/student_5.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-12",
      "behaviorRating": 4.4,
      "academicRating": 4.1,
      "extraActivities": ["Nature Club", "Volunteer Work"]
    },
    {
      "id": "S006",
      "name": "Aisha Rahman",
      "fatherName": "Dr. Mizanur Rahman",
      "motherName": "Rehana Parveen",
      "dateOfBirth": "2009-12-05",
      "age": 15,
      "gender": "Female",
      "phone": "01700000006",
      "guardianPhone": "01800000006",
      "email": "aisha.rahman@email.com",
      "address": "987 University Area, Dhaka-1000",
      "class": "Hifz-5",
      "section": "A",
      "rollNumber": 5,
      "admissionDate": "2018-04-12",
      "currentProgress": "Surah At-Tawbah completed",
      "totalSurahMemorized": 18,
      "attendancePercentage": 96.8,
      "monthlyFee": 3500,
      "feeStatus": "Paid",
      "bloodGroup": "A-",
      "medicalInfo": "Wears glasses",
      "emergencyContact": "01900000006",
      "photo": "assets/images/student_6.jpg",
      "status": "Active",
      "lastAttendance": "2024-08-12",
      "behaviorRating": 4.9,
      "academicRating": 4.9,
      "extraActivities": ["Debate Club", "Quran Translation", "Peer Tutoring"]
    }
  ];

  List<Map<String, dynamic>> get filteredStudents {
    return students.where((student) {
      final matchesSearch = student['name'].toString().toLowerCase()
          .contains(searchQuery.toLowerCase()) ||
          student['id'].toString().toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesClass = selectedClass == 'All' ||
          student['class'].toString() == selectedClass;

      return matchesSearch && matchesClass;
    }).toList();
  }

  List<String> get availableClasses {
    final classes = students.map((s) => s['class'].toString()).toSet().toList();
    classes.sort();
    return ['All', ...classes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Students Directory",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: Navigate to add student page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Add Student - Coming Soon!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search by name or ID...",
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                  ),
                ),

                const SizedBox(height: 12),

                // Class Filter
                Row(
                  children: [
                    const Text(
                      "Class: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: availableClasses.map((classLevel) {
                            final isSelected = selectedClass == classLevel;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(classLevel),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => selectedClass = classLevel);
                                },
                                backgroundColor: const Color(0xFFF3F4F6),
                                selectedColor: const Color(0xFF3B82F6),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Summary Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${filteredStudents.length} students found",
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Total: ${students.length}",
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return _buildStudentCard(context, student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDetailsPage(student: student),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Student Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _getAvatarColor(student['gender']),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        student['gender'] == 'Female'
                            ? Icons.woman
                            : Icons.man,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Student Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  student['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              _buildStatusBadge(student['feeStatus']),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "ID: ${student['id']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.school_outlined,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${student['class']}-${student['section']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Progress and Attendance
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  "📖 ${student['totalSurahMemorized']} Surahs",
                                  Colors.green[50]!,
                                  Colors.green[700]!,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildInfoChip(
                                  "📊 ${student['attendancePercentage']}%",
                                  Colors.blue[50]!,
                                  Colors.blue[700]!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFD1D5DB),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isPaid = status.toLowerCase() == 'paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isPaid ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _getAvatarColor(String gender) {
    return gender == 'Female'
        ? const Color(0xFFEC4899)
        : const Color(0xFF3B82F6);
  }
}