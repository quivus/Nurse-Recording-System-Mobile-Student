import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../widgets/app_colors.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('profile_image_path');
      if (imagePath != null && imagePath.isNotEmpty) {
        final savedFile = File(imagePath);
        if (await savedFile.exists()) {
          setState(() => _image = savedFile);
        }
      }
    } catch (e) {
      debugPrint("Load Error: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = p.basename(pickedFile.path);
        final String savedPath = p.join(directory.path, fileName);
        final File localImage = await File(pickedFile.path).copy(savedPath);

        setState(() => _image = localImage);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', savedPath);
      }
    } catch (e) {
      debugPrint("Pick image error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: const [
                _GradientInfoTile(
                  label: "NAME",
                  value: "Rajiemae V. Villa",
                  icon: Icons.person_outline_rounded,
                ),
                _GradientInfoTile(
                  label: "AGE",
                  value: "21 Years Old",
                  icon: Icons.wb_sunny_outlined,
                ),
                _GradientInfoTile(
                  label: "EMAIL",
                  value: "v.rajime.v@gmail.com",
                  icon: Icons.alternate_email_rounded,
                ),
                _GradientInfoTile(
                  label: "PHONE",
                  value: "+63 912 345 6789",
                  icon: Icons.phone_iphone_rounded,
                ),
                _GradientInfoTile(
                  label: "ADDRESS",
                  value: "Lapu-Lapu City, Cebu",
                  icon: Icons.map_outlined,
                ),
                _GradientInfoTile(
                  label: "EMERGENCY",
                  value: "+63 912 000 1111",
                  icon: Icons.support_agent_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 30,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    // Key forces the UI to replace the Icon with the Image
                    key: ValueKey(_image?.path),
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 70,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Container(
                  height: 38,
                  width: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 5),
          Text(
            "ID: MAN00019",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _GradientInfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B3E),
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
