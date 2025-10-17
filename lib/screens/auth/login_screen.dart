import 'dart:math' as math;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  late final AnimationController _animController;
  //bool _isLoading = false; bad practise to do so
  bool isSendingOtp = false;
  bool isLoggingIn = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter mobile number')));
      return;
    }

    setState(() => isSendingOtp = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      //_isLoading = false;
      _otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent — enter it below')));
    FocusScope.of(context).requestFocus(_otpFocus);
  }

  Future<void> _onLoginPressed() async {
    if (!_otpSent) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request OTP first')));
      return;
    }
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter OTP')));
      return;
    }

    setState(() => isLoggingIn = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => isLoggingIn = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in — Welcome, Farmer! 🌿')));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Color darkGreen = const Color(0xFF1B5E20);
    final Color midGreen = const Color(0xFF2E7D32);
    final Color lightGreen = const Color(0xFFC8E6C9);
    final Color accent = const Color(0xFF66BB6A);

    return Scaffold(
      backgroundColor: lightGreen.withOpacity(0.12),
      body: SafeArea(
        child: Column(
          children: [
            // TOP HEADER -------------------------------------------------------
            SizedBox(
              height: 340,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Curved gradient background
                  Positioned.fill(
                    child: ClipPath(
                      clipper: _BottomCurveClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [lightGreen, midGreen],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // glowing sun
                  Positioned(
                    left: width * 0.06,
                    top: 24,
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 700),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.06)],
                            radius: 0.9,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.white.withOpacity(0.18), blurRadius: 24, spreadRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // floating Fasal Sarathi badge
                  Positioned(
                    right: 22,
                    bottom: 8,
                    child: SlideInRight(
                      duration: const Duration(milliseconds: 900),
                      child: _FloatingBadge(animController: _animController),
                    ),
                  ),

                  // animated leaves and particles
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final t = _animController.value;
                        return Stack(
                          children: [
                            _animatedLeaf(t, width * 0.14, 70, 22, 1.0, 0.0),
                            _animatedLeaf((t + 0.33) % 1.0, width * 0.46, 42, 34, 0.85, 0.6),
                            _animatedLeaf((t + 0.66) % 1.0, width * 0.78, 60, 18, 1.05, 1.2),
                            _tinyParticle(t * 1.3, width * 0.28, 120, 6),
                            _tinyParticle((t + 0.5) % 1.0, width * 0.65, 90, 4),
                          ],
                        );
                      },
                    ),
                  ),

                  // header text
                  Positioned(
                    left: 20,
                    top: 36,
                    child: FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Farmer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Good day in your fields',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // LOGIN FORM -------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        'Sign in to continue with Fasal Sarathi',
                        style: TextStyle(color: darkGreen, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 14),

                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 14, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Phone + Send OTP
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.smartphone_outlined),
                                      hintText: 'Mobile Number',hintStyle: TextStyle(color: Colors.black),
                                      filled: true,
                                      fillColor: lightGreen.withOpacity(0.6),
                                      //labelText: 'Mobile',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _sendOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accent,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : Text(_otpSent ? 'Resend' : 'Send OTP',style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // OTP input
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: FadeInUp(
                                duration: const Duration(milliseconds: 350),
                                child: TextField(
                                  controller: _otpController,
                                  focusNode: _otpFocus,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.key_outlined),
                                    hintText: 'Enter OTP',
                                    //labelText: 'OTP',
                                    filled: true,
                                    fillColor: lightGreen.withOpacity(0.6),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              crossFadeState:
                                  _otpSent ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 300),
                            ),

                            const SizedBox(height: 14),

                            // Helper buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.info_outline, size: 18,color: Colors.green),
                                  label: const Text('Help',style: TextStyle(color: Colors.green)),
                                  //style: TextButton.styleFrom(foregroundColor: lightGreen),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('New Farmer? Sign Up',
                                  style: TextStyle(color: Colors.green)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Login button (icon & text set to white)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _onLoginPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkGreen,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: Colors.white),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.agriculture_rounded, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text(
                              'By continuing you agree to Fasal Sarathi Terms & Conditions',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // animated leaf icon
  Widget _animatedLeaf(double t, double x, double baseY, double amplitude, double scale, double phase) {
    final y = baseY + math.sin((t + phase) * 2 * math.pi) * amplitude;
    final rotation = (t + phase) * 2 * math.pi;
    final easedScale = 0.9 + 0.2 * math.sin((t + phase) * 2 * math.pi);

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        angle: rotation * 0.25,
        child: Transform.scale(
          scale: easedScale * scale,
          child: Opacity(
            opacity: 0.95,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
              ),
              child: const Center(child: Icon(Icons.spa, size: 16, color: Color(0xFF2E7D32))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tinyParticle(double t, double x, double baseY, double size) {
    final y = baseY + math.cos(t * 2 * math.pi) * 12;
    final opacity = 0.4 + 0.6 * (0.5 + 0.5 * math.sin(t * 2 * math.pi));
    return Positioned(
      left: x,
      top: y,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          decoration:
              BoxDecoration(color: Colors.white.withOpacity(0.85), shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final AnimationController animController;
  const _FloatingBadge({required this.animController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        final t = animController.value;
        final bob = 6 * math.sin(t * 2 * math.pi);
        final rotate = 0.08 * math.sin(t * 2 * math.pi);
        return Transform.translate(
          offset: Offset(0, -bob),
          child: Transform.rotate(angle: rotate, child: child),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 8))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.agriculture_rounded, size: 34, color: Color(0xFF2E7D32)),
            SizedBox(height: 6),
            Text(
              'Fasal Sarathi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// curved header shape
class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 70);
    final firstControl = Offset(size.width * 0.25, size.height);
    final firstEnd = Offset(size.width * 0.5, size.height);
    final secondControl = Offset(size.width * 0.75, size.height);
    final secondEnd = Offset(size.width, size.height - 70);
    path.quadraticBezierTo(firstControl.dx, firstControl.dy, firstEnd.dx, firstEnd.dy);
    path.quadraticBezierTo(secondControl.dx, secondControl.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
