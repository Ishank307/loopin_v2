import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:loopin_v2/screens/login/otppage.dart';

class MobileNoPage extends StatefulWidget {
  const MobileNoPage({super.key});

  @override
  State<MobileNoPage> createState() => _MobileNoPageState();
}

class _MobileNoPageState extends State<MobileNoPage> {
  final TextEditingController _phoneController = TextEditingController();
  Country selectedCountry = Country.parse('IN');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Rebuild the widget when the text changes to update the button state
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  void _navigateToOTP() {
    // Only proceed if the button is active and not already loading
    if (_phoneController.text.length == 10 && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network call and navigate
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(
              phoneNumber: _phoneController.text,
              countryCode: '+${selectedCountry.phoneCode}',
            ),
          ),
        ).then((_) {
          // Reset loading state when returning to this page
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      });
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.grey[900],
        bottomSheetHeight: 500,
        textStyle: const TextStyle(color: Colors.white),
        searchTextStyle: const TextStyle(color: Colors.white),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: 'Search country',
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isButtonActive = _phoneController.text.length == 10;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Recommended for better UX
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/mobile.png', fit: BoxFit.cover),

          // Grainy/Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          // Main content column
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Glassmorphism container
                  _buildGlassmorphismCard(size),
                  const Spacer(flex: 3),
                  // Continue Button
                  _buildContinueButton(isButtonActive),
                  const SizedBox(height: 16),
                  // Bottom Legal Text
                  _buildBottomLegalText(size),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphismCard(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Your exclusive access\nstarts here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              // Phone input container
              _buildPhoneInputContainer(size),
              SizedBox(height: size.height * 0.03),
              // Terms and conditions
              Text(
                'By confirming you are to receive SMS messages from Loopin for phone verification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: size.width * 0.03,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputContainer(Size size) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Country picker
          GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              color: Colors.transparent, // for better hit-testing
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    selectedCountry.flagEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${selectedCountry.phoneCode}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 28, color: Colors.white.withOpacity(0.2)),
          // Phone number input
          // Phone number input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0000000000',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: size.width * 0.045,
                  letterSpacing: 1.5,
                ),
                // Corrected padding for vertical centering
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0, // This applies padding to top and bottom
                ),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(bool isActive) {
    final Color activeBackgroundColor = Color(
      0xFF3A3A3C,
    ); // Medium-dark gray for active state
    final Color inactiveBackgroundColor = Color(
      0xFF2C2C2E,
    ); // Very dark gray for inactive state
    final Color activeTextColor = Colors.white;
    final Color inactiveTextColor = Colors.grey[600]!;

    return GestureDetector(
      onTap: isActive ? _navigateToOTP : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          // Use the new colors based on the button's state
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
                    // The loader should be light since the button is dark
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        // Use the new text colors
                        color: isActive ? activeTextColor : inactiveTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.arrow_right,
                      // Use the new icon colors
                      color: isActive ? activeTextColor : inactiveTextColor,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBottomLegalText(Size size) {
    return Text(
      'By tapping Continue, you are agreeing to\nour Terms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: size.width * 0.03,
        height: 1.4,
      ),
    );
  }
}
