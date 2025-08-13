import 'package:flutter/material.dart';
import '../../../core/constents/templates/message_templates.dart';
import '../../../core/utils/snackbar_helper.dart';

class SendSmsPage extends StatefulWidget {
  final Map<String, dynamic>? preselectedStudent;
  final List<Map<String, dynamic>> students;
  SendSmsPage({super.key, this.preselectedStudent, required this.students});

  @override
  State<SendSmsPage> createState() => _SendSmsPageState();
}

class _SendSmsPageState extends State<SendSmsPage>
    with TickerProviderStateMixin {
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;


  Map<String, dynamic>? selectedStudent;
  List<Map<String, dynamic>> selectedStudents = [];
  bool isBulkMode = false;
  String searchQuery = '';
  String selectedRecipientType = 'Student';
  int characterCount = 0;
  int estimatedSmsCount = 1;



  // Predefined message templates

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.preselectedStudent != null) {
      selectedStudent = widget.preselectedStudent;
    }

    _msgController.addListener(_updateCharacterCount);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _msgController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      characterCount = _msgController.text.length;
      estimatedSmsCount = (characterCount / 160).ceil().clamp(1, 10);
    });
  }

  List<Map<String, dynamic>> get filteredStudents {
    if (searchQuery.isEmpty) return widget.students;
    return widget.students.where((student) {
      return student['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          student['id'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          student['class'].toString().toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> students = widget.students;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Send SMS",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(
              isBulkMode ? Icons.person : Icons.groups,
              color: const Color(0xFF1E40AF),
            ),
            onPressed: () {
              setState(() {
                isBulkMode = !isBulkMode;
                selectedStudents.clear();
                selectedStudent = null;
              });
            },
            tooltip: isBulkMode ? 'Single Mode' : 'Bulk Mode',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showMessageHistory(context);
            },
            tooltip: 'Message History',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E40AF).withOpacity(0.1),
                    const Color(0xFF3B82F6).withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isBulkMode ? Icons.groups : Icons.person,
                    color: const Color(0xFF1E40AF),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isBulkMode ? "Bulk SMS Mode" : "Individual SMS Mode",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  if (isBulkMode)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${selectedStudents.length} selected",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipient Selection
                    _buildRecipientSection(),

                    const SizedBox(height: 24),

                    // Message Templates
                    _buildMessageTemplatesSection(),

                    const SizedBox(height: 24),

                    // Message Input
                    _buildMessageInputSection(),

                    const SizedBox(height: 24),

                    // Send Button
                    _buildSendButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientSection() {
    return Container(
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
          Row(
            children: [
              const Icon(Icons.people_outline, color: Color(0xFF1E40AF)),
              const SizedBox(width: 8),
              const Text(
                "Recipients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              // Recipient Type Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedRecipientType,
                  underline: const SizedBox(),
                  items: ['Student', 'Guardian', 'Emergency Contact'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedRecipientType = value!);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (!isBulkMode) ...[
            // Single Student Selection
            if (selectedStudent != null)
              _buildSelectedStudentCard(selectedStudent!)
            else
              _buildStudentSelector(),
          ] else ...[
            // Bulk Selection
            _buildBulkSelectionInterface(),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedStudentCard(Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E40AF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              student['gender'] == 'Female' ? Icons.woman : Icons.man,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: ${student['id'].toString()} • ${student['class']}-${student['section']}",
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getRecipientPhone(student),
                  style: const TextStyle(
                    color: Color(0xFF1E40AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => selectedStudent = null);
            },
            icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: InputDecoration(
            hintText: "Search students...",
            prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              final student = filteredStudents[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1E40AF),
                  child: Icon(
                    student['gender'] == 'Female' ? Icons.woman : Icons.man,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(student['name']),
                subtitle: Text("${student['id'].toString()} • ${student['class']}-${student['section']}"),
                onTap: () {
                  setState(() {
                    selectedStudent = student;
                    searchQuery = '';
                    _searchController.clear();
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBulkSelectionInterface() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.select_all),
                label: const Text("Select All"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    selectedStudents = List.from(widget.students);
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.clear_all),
                label: const Text("Clear All"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7280),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    selectedStudents.clear();
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            itemCount: widget.students.length,
            itemBuilder: (context, index) {
              final student = widget.students[index];
              final isSelected = selectedStudents.contains(student);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      selectedStudents.add(student);
                    } else {
                      selectedStudents.remove(student);
                    }
                  });
                },
                title: Text(student['name']),
                subtitle: Text("${student['id'].toString()} • ${student['class']}-${student['section']}"),
                secondary: CircleAvatar(
                  backgroundColor: const Color(0xFF1E40AF),
                  child: Icon(
                    student['gender'] == 'Female' ? Icons.woman : Icons.man,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTemplatesSection() {
    return Container(
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
              Icon(Icons.message_outlined, color: Color(0xFF1E40AF)),
              SizedBox(width: 8),
              Text(
                "Message Templates",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: messageTemplates.length,
              itemBuilder: (context, index) {
                final template = messageTemplates[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _msgController.text = template['message']!;
                        _updateCharacterCount();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                template['message']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputSection() {
    return Container(
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
              Icon(Icons.edit_outlined, color: Color(0xFF1E40AF)),
              SizedBox(width: 8),
              Text(
                "Compose Message",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _msgController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: "Type your message here...",
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
                borderSide: const BorderSide(color: Color(0xFF1E40AF)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$characterCount characters",
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                ),
              ),
              Text(
                "$estimatedSmsCount SMS",
                style: TextStyle(
                  color: estimatedSmsCount > 3 ? Colors.red : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final bool canSend = _msgController.text.isNotEmpty &&
        ((!isBulkMode && selectedStudent != null) ||
            (isBulkMode && selectedStudents.isNotEmpty));

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: canSend
            ? const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        )
            : null,
        color: canSend ? null : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: canSend ? [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canSend ? _sendSMS : null,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.send_rounded,
                  color: canSend ? Colors.white : const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 8),
                Text(
                  isBulkMode ? "Send to ${selectedStudents.length} Students" : "Send SMS",
                  style: TextStyle(
                    color: canSend ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRecipientPhone(Map<String, dynamic> student) {
    switch (selectedRecipientType) {
      case 'Guardian':
        return student['guardianPhone'];
      case 'Emergency Contact':
        return student['emergencyContact'];
      default:
        return student['phone'];
    }
  }

  void _sendSMS() {
    if (isBulkMode) {
      final recipientCount = selectedStudents.length;
      SnackbarHelper.showSuccess(
        context,
        "SMS sent successfully to $recipientCount students",
      );
    } else {
      SnackbarHelper.showSuccess(
        context,
        "SMS sent successfully to ${selectedStudent!['name']}",
      );
    }

    // Clear the message after sending
    _msgController.clear();
    setState(() {
      characterCount = 0;
      estimatedSmsCount = 1;
    });
  }

  void _showMessageHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Message History"),
        content: const SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Center(
            child: Text("Message history feature coming soon!"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}