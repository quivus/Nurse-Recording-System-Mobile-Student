import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' show PdfGoogleFonts;
import 'package:printing/printing.dart';
import '../widgets/app_colors.dart';

class MedicalRecord extends StatefulWidget {
  const MedicalRecord({super.key});

  @override
  State<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecord> {
  final _recordIDController = TextEditingController(text: "R001");
  final _dateController = TextEditingController(text: "October 10, 2025");

  final _firstNameController = TextEditingController(text: "Rajiemae");
  final _middleNameController = TextEditingController(text: "V.");
  final _lastNameController = TextEditingController(text: "Villa");
  final _addressController =
      TextEditingController(text: "Lapu-Lapu City, Cebu, Philippines");
  final _contactController = TextEditingController(text: "0912-345-6789");
  final _emailController =
      TextEditingController(text: "v.rajime.v@gmail.com");

  final _diagnosisController =
      TextEditingController(text: "Eczema (skin inflammation)");
  final _treatmentController =
      TextEditingController(text: "Topical cream and hydration");
  final _notesController =
      TextEditingController(text: "Patient advised to avoid sun exposure.");
  final _otherSymptomController = TextEditingController(text: "Itchy skin");

  final List<Map<String, dynamic>> _symptoms = [
    {"name": "Fever", "icon": Icons.thermostat_rounded},
    {"name": "Cough", "icon": Icons.sick_rounded},
    {"name": "Dizziness", "icon": Icons.rotate_right_rounded},
    {"name": "Chest Pain", "icon": Icons.monitor_heart_rounded},
    {"name": "Fatigue", "icon": Icons.battery_full_rounded},
    {"name": "Injury", "icon": Icons.healing_rounded},
    {"name": "Other", "icon": Icons.edit_note_rounded},
  ];
  final List<String> _selectedSymptoms = ["Itchy skin", "Fatigue"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Medical Record",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _animatedField(_recordIDController, "Record ID", Icons.badge_rounded),
            const SizedBox(height: 16),
            _animatedField(_dateController, "Date", Icons.calendar_today_rounded),
            const SizedBox(height: 16),
            _animatedField(_firstNameController, "First Name", Icons.person_rounded),
            const SizedBox(height: 16),
            _animatedField(_middleNameController, "Middle Name", Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _animatedField(_lastNameController, "Last Name", Icons.person_pin_rounded),
            const SizedBox(height: 16),
            _animatedField(_addressController, "Address", Icons.home_rounded),
            const SizedBox(height: 16),
            _animatedField(_contactController, "Contact Number", Icons.call_rounded),
            const SizedBox(height: 16),
            _animatedField(_emailController, "Email", Icons.email_rounded),
            const SizedBox(height: 16),
            _animatedField(_diagnosisController, "Diagnosis", Icons.medical_information_rounded),
            const SizedBox(height: 16),
            _buildSymptomSection(),
            const SizedBox(height: 16),
            _animatedField(_treatmentController, "Treatment", Icons.healing_rounded),
            const SizedBox(height: 16),
            _animatedField(
              _notesController,
              "Notes",
              Icons.note_rounded,
              maxLines: 3,
              requiredField: false,
            ),
            const SizedBox(height: 30),
            _buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  // READ-ONLY GRADIENT FIELD
  Widget _animatedField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool requiredField = true,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.colors.first.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Icon(icon, color: Colors.white),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          ),
        ),
      ),
    );
  }

  // SYMPTOM SECTION
  Widget _buildSymptomSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.colors.first.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text("Symptoms",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))
        ]),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _symptoms.map((symptom) {
            final isSelected =
                _selectedSymptoms.contains(symptom["name"]) ||
                    (symptom["name"] == "Other" &&
                        _selectedSymptoms.contains(_otherSymptomController.text));
            return _buildSymptomChip(symptom["name"], symptom["icon"], isSelected);
          }).toList(),
        ),
        const SizedBox(height: 8),
        _animatedField(
          _otherSymptomController,
          "Other Symptom",
          Icons.edit_note_rounded,
          requiredField: false,
        ),
      ]),
    );
  }

  Widget _buildSymptomChip(String name, IconData icon, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: isSelected ? AppColors.primaryGradient : null,
        color: isSelected ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.primaryGradient.colors.first.withOpacity(0.3)),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: AppColors.primaryGradient.colors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon,
            size: 18,
            color: isSelected
                ? Colors.white
                : AppColors.primaryGradient.colors.first),
        const SizedBox(width: 6),
        Text(name,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13))
      ]),
    );
  }

  // DOWNLOAD BUTTON
  Widget _buildDownloadButton() {
    return InkWell(
      onTap: _downloadPdf,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradient.colors.first.withOpacity(0.5),
              offset: const Offset(0, 8),
              blurRadius: 20,
            ),
          ],
        ),
        child: const Center(
          child: Text("Download PDF",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
        ),
      ),
    );
  }

  // PDF DOWNLOAD LOGIC
  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.openSansRegular();
    final bold = await PdfGoogleFonts.openSansBold();

    final data = {
      'Record ID': _recordIDController.text,
      'Date': _dateController.text,
      'First Name': _firstNameController.text,
      'Middle Name': _middleNameController.text,
      'Last Name': _lastNameController.text,
      'Address': _addressController.text,
      'Contact Number': _contactController.text,
      'Email': _emailController.text,
      'Diagnosis': _diagnosisController.text,
      'Symptoms': _selectedSymptoms.join(", "),
      'Other Symptom': _otherSymptomController.text,
      'Treatment': _treatmentController.text,
      'Notes': _notesController.text,
    };

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Center(
            child: pw.Text("MEDICAL RECORD",
                style: pw.TextStyle(font: bold, fontSize: 22)),
          ),
          pw.SizedBox(height: 12),
          pw.Divider(),
          pw.SizedBox(height: 10),
          ...data.entries.map((e) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(e.key,
                          style: pw.TextStyle(
                              font: bold,
                              fontSize: 11,
                              color: PdfColors.grey700)),
                      pw.Text(e.value,
                          style: pw.TextStyle(font: font, fontSize: 12)),
                      pw.SizedBox(height: 5)
                    ]),
              )),
        ],
      ),
    );

    final lastName = _lastNameController.text.isNotEmpty
        ? _lastNameController.text.toLowerCase()
        : 'record';
    final fileName = "${lastName}_medical_record.pdf";

    await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
  }
}
