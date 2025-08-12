import 'package:flutter/material.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../theme/colors.dart';

class SendSmsPage extends StatefulWidget {
  final Map<String, String>? preselectedStudent;
  const SendSmsPage({super.key, this.preselectedStudent});

  @override
  State<SendSmsPage> createState() => _SendSmsPageState();
}

class _SendSmsPageState extends State<SendSmsPage> {
  final TextEditingController _msgController = TextEditingController();

  List<Map<String, String>> students = [
    {"name": "Abdullah Al Noman", "id": "S101", "phone": "01700000001"},
    {"name": "Samiul Haque", "id": "S102", "phone": "01700000002"},
    {"name": "Mahmudul Hasan", "id": "S103", "phone": "01700000003"},
  ];

  Map<String, String>? selectedStudent;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedStudent != null) {
      selectedStudent = widget.preselectedStudent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send SMS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: "Select Student",
                border: OutlineInputBorder(),
              ),
              value: selectedStudent,
              items: students.map((student) {
                return DropdownMenuItem(
                  value: student,
                  child: Text(student["name"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudent = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Send"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (selectedStudent == null || _msgController.text.isEmpty) {
                  SnackbarHelper.showError(context, "Please select student and enter message");
                } else {
                  SnackbarHelper.showSuccess(
                    context,
                    "SMS sent to ${selectedStudent!["name"]}",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
