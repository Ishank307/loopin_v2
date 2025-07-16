import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loopin_v2/interest_model.dart'; // Ensure this import is correct
import 'package:loopin_v2/screens/host/image_upload.dart'; // Ensure this import is correct

class InvitationPreferencesScreen extends StatefulWidget {
  const InvitationPreferencesScreen({super.key});

  @override
  State<InvitationPreferencesScreen> createState() =>
      _InvitationPreferencesScreenState();
}

class _InvitationPreferencesScreenState
    extends State<InvitationPreferencesScreen> {
  final Set<String> _selectedInterests = {};
  final int _maxSelections = 5;

  void _toggleInterest(String interestName) {
    setState(() {
      if (_selectedInterests.contains(interestName)) {
        _selectedInterests.remove(interestName);
      } else {
        if (_selectedInterests.length < _maxSelections) {
          _selectedInterests.add(interestName);
        } else {
          // Removes the previous snackbar if a new one is shown quickly
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 43, 35, 35),
              content: Text(
                'You can select a maximum of $_maxSelections preferences.',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        // Use a Stack to layer the floating button over the scrollable content
        child: Stack(
          children: [
            // Your main scrollable content
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Your Invitation Preferences',
                          style: TextStyle(
                            fontFamily:
                                'BricolageGrotesqueRegular', // Ensure this font is in your pubspec.yaml
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Max: $_maxSelections',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontFamily:
                                'PoppinsRegular', // Ensure this font is in your pubspec.yaml
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final interest = allInterests[index];
                      final isSelected = _selectedInterests.contains(
                        interest.imageName,
                      );
                      final double tiltDegrees = index.isEven ? -4.0 : 4.0;
                      final double tiltRadians = tiltDegrees * (pi / 180);

                      return InterestCard(
                        interestName: interest.imageName,
                        isSelected: isSelected,
                        tiltAngle: tiltRadians,
                        onTap: () => _toggleInterest(interest.imageName),
                      );
                    }, childCount: allInterests.length),
                  ),
                ),
                // IMPORTANT: Add padding at the bottom of the scroll view
                // so the last items are not hidden behind the floating button.
                // Height = button height (51) + button vertical padding (40) + extra space (29) = 120
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),

            // The floating button is placed at the bottom of the Stack
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child:
                  _buildSaveButton(), // Using the new and improved button builder
            ),
          ],
        ),
      ),
    );
  }

  // --- REPLACED BUTTON BUILDER METHOD ---
  // This method now builds the button with the desired style and logic.
  Widget _buildSaveButton() {
    // Button is enabled only if at least one interest is selected
    final bool isEnabled = _selectedInterests.isNotEmpty;

    // The container for the button provides the "footer" area background and padding
    return Container(
      color: Colors
          .black, // Opaque background to hide content scrolling underneath
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: GestureDetector(
        // The onTap action is only set if the button is enabled
        onTap: isEnabled
            ? () {
                debugPrint('Selected Interests: $_selectedInterests');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhotoUploadScreen(),
                  ),
                );
              }
            : null, // If disabled, onTap is null, making it non-reactive
        child: Container(
          width: 343,
          height: 51,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // Conditionally apply the gradient or a solid disabled color
            gradient: isEnabled
                ? const RadialGradient(
                    center: Alignment.center,
                    radius: 2.0, // This creates the wide, soft glow effect
                    colors: [Color(0xFF555560), Color(0xFF1C1C1D)],
                  )
                : null,
            color: isEnabled
                ? null
                : const Color(0xFF2C2C2E), // Solid color for disabled state
          ),
          child: Opacity(
            // Dim the text and arrow when the button is disabled
            opacity: isEnabled ? 1.0 : 0.5,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFFEAEAEA),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '→',
                  style: TextStyle(
                    color: Color(0xFFEAEAEA),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Your Existing InterestCard Widget (Unchanged) ---
class InterestCard extends StatelessWidget {
  final String interestName;
  final bool isSelected;
  final double tiltAngle;
  final VoidCallback onTap;

  const InterestCard({
    super.key,
    required this.interestName,
    required this.isSelected,
    required this.tiltAngle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Assumes your images are named like 'Art.png' and 'Art_bw.png'
    final String imagePath = isSelected
        ? 'assets/images/$interestName.png'
        : 'assets/images/${interestName}_bw.png';

    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: tiltAngle,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: ClipRRect(
              key: ValueKey<String>(imagePath),
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain, // Using cover to fill the card space
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback widget if an image fails to load
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
