import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_button.dart' as widget_btn;
import '../widgets/app_colors.dart';
import '../screens/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white app background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO ---
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: SvgPicture.asset(
                    'assets/ACLC.svg',
                    height: 100,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- GRADIENT BOLD TEXT ---
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: const Text(
                    'ACLC CLINIC',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900, // Very Bold
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // --- PURE WHITE BG FIELDS ---
                _buildWhiteGradientField(
                  controller: userController,
                  hint: 'User ID',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                _buildWhiteGradientField(
                  controller: passController,
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  suffix: GestureDetector(
                    onTap: () => setState(() => isObscured = !isObscured),
                    child: Icon(
                      isObscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // --- LOGIN BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: widget_btn.CustomButton(
                    text: 'LOGIN',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const Home()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteGradientField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    Widget? suffix,
  }) {
    return Container(
      // The outer container handles the Gradient "Border"
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        // The inner container is SOLID WHITE
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.5),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword ? isObscured : false,
          style: const TextStyle(
            color: Color(0xFF2D3243),
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none, // Removes the default underline/border
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 10,
            ),
          ),
        ),
      ),
    );
  }
}
