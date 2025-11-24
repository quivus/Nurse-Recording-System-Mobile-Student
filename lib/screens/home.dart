import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_temp/widgets/app_colors.dart';
import 'package:flutter_temp/widgets/app_background.dart';
import 'userinfo.dart';
import '../landing/signin.dart';
import 'medical_record.dart';

class MedicalRecordModel {
  final String date;
  final String activity;
  final String scheduledTime;
  final String doctor;

  const MedicalRecordModel({
    required this.date,
    required this.activity,
    required this.scheduledTime,
    required this.doctor,
  });
}

const List<MedicalRecordModel> allRecords = [
  MedicalRecordModel(date: 'January 4th, 2018', activity: 'Dental hygiene', scheduledTime: '9:00am', doctor: 'Nurse Chavez'),
  MedicalRecordModel(date: 'December 17th, 2017', activity: 'Sore throat checkup', scheduledTime: '10:30am', doctor: 'Nurse Rai'),
  MedicalRecordModel(date: 'August 21th, 2017', activity: 'Circulatory problems', scheduledTime: '4:45pm', doctor: 'Nurse AYumi'),
  MedicalRecordModel(date: 'July 10th, 2017', activity: 'Blood pressure check', scheduledTime: '2:00pm', doctor: 'Nurse Jan'),
  MedicalRecordModel(date: 'July 10th, 2017', activity: 'Blood pressure check', scheduledTime: '2:00pm', doctor: 'Nurse Inot'),
  MedicalRecordModel(date: 'July 10th, 2017', activity: 'Blood pressure check', scheduledTime: '2:00pm', doctor: 'Nurse Gab'),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MedicalRecordModel> _filteredRecords = allRecords;

  void _filterRecords(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecords = allRecords;
      } else {
        _filteredRecords = allRecords.where((record) {
          final doctorMatch = record.doctor.toLowerCase().contains(query.toLowerCase());
          final activityMatch = record.activity.toLowerCase().contains(query.toLowerCase());
          return doctorMatch || activityMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const _Header(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: const Text(
                        'Hello, Ayums! ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Medical Record',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),
                _SearchBar(onSearch: _filterRecords),
                const SizedBox(height: 16),
                Expanded(child: _PatientRecordSection(allRecords: _filteredRecords)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: SvgPicture.asset(
                'assets/ACLC.svg',
                height: 50,
                width: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'ACLC Clinic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const _ProfileMenu(),
      ],
    );
  }
}

class _ProfileMenu extends StatefulWidget {
  const _ProfileMenu();

  @override
  State<_ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<_ProfileMenu> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 55),
      elevation: 12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primaryGradient.colors.first.withOpacity(0.2),
          width: 1,
        ),
      ),
      onOpened: () => setState(() => _isMenuOpen = true),
      onCanceled: () => setState(() => _isMenuOpen = false),
      child: Container(
        decoration: BoxDecoration(
          gradient: _isMenuOpen ? AppColors.primaryGradient : null,
          color: _isMenuOpen ? null : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          Icons.person,
          color: _isMenuOpen ? Colors.white : Colors.grey.shade600,
          size: 16,
        ),
      ),
      itemBuilder: (_) => [
        _menuItem(
          'account',
          Icons.account_circle_rounded,
          'Account',
          AppColors.primaryGradient.colors.first,
        ),
        const PopupMenuDivider(height: 16),
        _menuItem(
          'logout',
          Icons.logout_rounded,
          'Logout',
          Colors.red.shade400,
        ),
      ],
      onSelected: (value) {
        setState(() => _isMenuOpen = false);
        if (value == 'account') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserInfo()));
        } else if (value == 'logout') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
        }
      },
    );
  }

  static PopupMenuItem<String> _menuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: value == 'account'
                  ? LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: value == 'logout' ? color.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  
  const _SearchBar({required this.onSearch});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isFocused
              ? AppColors.primaryGradient.colors.first
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: AppColors.primaryGradient.colors.first.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'Search by doctor or diagnosis',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 10,
          ),
        ),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _PatientRecordSection extends StatelessWidget {
  final List<MedicalRecordModel> allRecords;
  const _PatientRecordSection({required this.allRecords});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: allRecords.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PatientRecordTile(record: allRecords[index]),
        );
      },
    );
  }
}

class _PatientRecordTile extends StatelessWidget {
  final MedicalRecordModel record;
  const _PatientRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalRecord()));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.date,
                    style: const TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    record.activity,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scheduled: ${record.scheduledTime}',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Doctor: ${record.doctor}',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}