import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GenerateStudentReport {
  Future<void> generateStudentReport(Map<String, dynamic> student) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "Student Details Report",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Personal Info Section
          pw.Text("Personal Information",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _buildInfoRow("Full Name", student['name']),
          _buildInfoRow("Father's Name", student['fatherName']),
          _buildInfoRow("Mother's Name", student['motherName']),
          _buildInfoRow("Date of Birth", student['dateOfBirth']),
          _buildInfoRow("Age", "${student['age']} years"),
          _buildInfoRow("Gender", student['gender']),
          _buildInfoRow("Status", student['status']),
          pw.SizedBox(height: 12),

          // Contact Info
          pw.Text("Contact Information",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _buildInfoRow("Student Phone", student['phone']),
          _buildInfoRow("Guardian Phone", student['guardianPhone']),
          _buildInfoRow("Emergency Contact", student['emergencyContact']),
          _buildInfoRow("Email", student['email']),
          _buildInfoRow("Address", student['address']),
          pw.SizedBox(height: 12),

          // Academic Info
          pw.Text("Academic Information",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _buildInfoRow("Class", "${student['class']}-${student['section']}"),
          _buildInfoRow("Roll Number", student['rollNumber']),
          _buildInfoRow("Admission Date", student['admissionDate']),
          _buildInfoRow("Last Attendance", student['lastAttendance']),
          _buildInfoRow("Current Progress", student['currentProgress']),
          _buildInfoRow("Surahs Memorized", student['totalSurahMemorized']),
          pw.SizedBox(height: 12),

          // Finance Info
          pw.Text("Finance",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _buildInfoRow("Fee Status", student['feeStatus']),
          _buildInfoRow("Monthly Fee", "৳${student['monthlyFee']}"),
          pw.SizedBox(height: 12),

          // Medical Info
          pw.Text("Medical Information",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          _buildInfoRow("Blood Group", student['bloodGroup']),
          _buildInfoRow("Medical Info", student['medicalInfo']),
        ],
      ),
    );

    // Save & open PDF viewer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildInfoRow(String label, dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return pw.SizedBox();
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 150,
            child: pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value.toString())),
        ],
      ),
    );
  }
}
