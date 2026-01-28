import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_background.dart';
import 'signin.dart';

const _kGradient = LinearGradient(
  colors: [Color(0xFF2933FF), Color(0xFFFF5451)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  late AnimationController _mainCtrl, _floatCtrl;
  late Animation<double> _scale, _float, _opacity;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_mainCtrl);

    _opacity = CurvedAnimation(parent: _mainCtrl, curve: Curves.easeIn);

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _float = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _runSequence();
  }

  void _runSequence() async {
    await _mainCtrl.forward();

    await Future.delayed(const Duration(seconds: 3));

    await _mainCtrl.animateTo(
      0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInBack,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SignIn(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: AnimatedBuilder(
                animation: _float,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _float.value),
                  child: ShaderMask(
                    shaderCallback: (bounds) => _kGradient.createShader(bounds),
                    child: SvgPicture.asset(
                      'assets/ACLC.svg',
                      width: 160,
                      height: 160,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
