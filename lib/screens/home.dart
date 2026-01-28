import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aclc_clinic/widgets/app_colors.dart';
import 'userinfo.dart';
import '../landing/signin.dart';
import 'medical_record.dart';

class MedicalRecordModel {
  final String date;
  final String activity;
  final String doctor;
  const MedicalRecordModel({
    required this.date,
    required this.activity,
    required this.doctor,
  });
}

const List<MedicalRecordModel> allRecords = [
  MedicalRecordModel(
    date: 'Jan 4, 2018',
    activity: 'Dental hygiene',
    doctor: 'Nurse Chavez',
  ),
  MedicalRecordModel(
    date: 'Dec 17, 2017',
    activity: 'Sore throat checkup',
    doctor: 'Nurse Rai',
  ),
  MedicalRecordModel(
    date: 'Aug 21, 2017',
    activity: 'Circulatory problems',
    doctor: 'Nurse AYumi',
  ),
  MedicalRecordModel(
    date: 'July 10, 2017',
    activity: 'Blood pressure check',
    doctor: 'Nurse Jan',
  ),
];

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  List<MedicalRecordModel> _filteredRecords = allRecords;
  bool _isEmergencyActive = false;
  Timer? _emergencyTimer;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) setState(() => _profileImage = file);
    }
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords = allRecords.where((record) {
        return record.doctor.toLowerCase().contains(query.toLowerCase()) ||
            record.activity.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _triggerEmergency() {
    HapticFeedback.heavyImpact();
    setState(() => _isEmergencyActive = true);
    _emergencyTimer?.cancel();
    _emergencyTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _isEmergencyActive = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FE),
      drawer: _buildSidebar(context),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CustomAppBar(scaffoldKey: _scaffoldKey),
                _WelcomeHeader(profileImage: _profileImage),
                const SizedBox(height: 25),
                _EmergencyActionCard(onLongPress: _triggerEmergency),
                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Medical Records',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SearchBar(
                    controller: _searchController,
                    onChanged: _filterRecords,
                  ),
                ),

                Expanded(child: _PatientRecordList(records: _filteredRecords)),
              ],
            ),
          ),

          if (_isEmergencyActive)
            _EmergencyOverlay(
              onCancel: () {
                _emergencyTimer?.cancel();
                setState(() => _isEmergencyActive = false);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80, bottom: 40),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: SvgPicture.asset(
                    'assets/ACLC.svg',
                    height: 90,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'ACLC CLINIC',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserInfo()),
            ).then((_) => _loadProfileImage()),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SignIn()),
              (route) => false,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final File? profileImage;
  const _WelcomeHeader({this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : null,
              child: profileImage == null
                  ? const Icon(Icons.person, color: Colors.blue)
                  : null,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello There,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const Text(
                'Rajiemae!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientRecordList extends StatelessWidget {
  final List<MedicalRecordModel> records;
  const _PatientRecordList({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Text("No records found", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      // No shrinkWrap here so it scrolls efficiently
      itemCount: records.length,
      itemBuilder: (context, index) {
        final r = records[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MedicalRecord()),
            ),
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const GradientIcon(Icons.assignment_outlined, size: 26),
            ),
            title: Text(
              r.activity,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B3E),
              ),
            ),
            subtitle: Text(
              '${r.date} • ${r.doctor}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: const GradientIcon(Icons.chevron_right_rounded),
          ),
        );
      },
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const GradientIcon(this.icon, {this.size = 28, super.key});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _CustomAppBar({required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notes_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          const Icon(
            Icons.notifications_active_outlined,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  final VoidCallback onLongPress;
  const _EmergencyActionCard({required this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              const GradientIcon(Icons.touch_app_rounded, size: 55),
              const SizedBox(height: 15),
              const Text(
                'EMERGENCY? HOLD PRESS!',
                style: TextStyle(
                  color: Color(0xFF0D1B3E),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Long press to notify the medical team',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  const _SearchBar({required this.controller, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search records...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, right: 10),
            child: GradientIcon(Icons.search_rounded),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

class _EmergencyOverlay extends StatelessWidget {
  final VoidCallback onCancel;
  const _EmergencyOverlay({required this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red.withOpacity(0.96),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "ALERT SENT!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Text(
                "Immediate signal sent to clinical staff. Vibration active.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                elevation: 10,
              ),
              child: const Text(
                "CANCEL ALERT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
