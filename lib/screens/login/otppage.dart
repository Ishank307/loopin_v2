// Make sure these imports are at the top of your file
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const OTPPage({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;
  bool _isOtpComplete = false;

  void _verifyOTP() {
    if (_isOtpComplete && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate OTP verification
      Future.delayed(const Duration(seconds: 2), () {
        // Here you would typically navigate to your app's home screen
        // For now, we'll just pop back and reset the state.
        print('OTP Verified: ${_pinController.text}');
        if (mounted) {
          Navigator.pop(context); // Go back to the mobile number page
        }
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Assuming the same background image
          Image.asset('assets/images/otpPage.png', fit: BoxFit.cover),

          // Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _buildGlassmorphismCard(context),
                  const Spacer(flex: 3),
                  _buildContinueButton(_isOtpComplete),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphismCard(BuildContext context) {
    // Define the theme for the OTP boxes
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        color: Colors.white.withOpacity(0.1),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Your Exclusive\nSpot',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 32),
              // Pinput OTP Field using the new themes
              Pinput(
                length: 4,
                controller: _pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onCompleted: (pin) {
                  setState(() {
                    _isOtpComplete = true;
                  });
                },
                onChanged: (value) {
                  if (value.length < 4 && _isOtpComplete) {
                    setState(() {
                      _isOtpComplete = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              Text(
                'By continuing you are to receive SMS messages from Loopine Circle for phone verification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(bool isActive) {
    final Color activeBackgroundColor = Color(0xFF3A3A3C);
    final Color inactiveBackgroundColor = Color(0xFF2C2C2E);
    final Color activeTextColor = Colors.white;
    final Color inactiveTextColor = Colors.grey[600]!;

    return GestureDetector(
      onTap: isActive ? _verifyOTP : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isActive ? activeBackgroundColor : inactiveBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: isActive ? activeTextColor : inactiveTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: isActive ? activeTextColor : inactiveTextColor,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
