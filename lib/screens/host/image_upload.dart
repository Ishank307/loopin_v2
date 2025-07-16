// lib/photo_upload_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  // A list to hold the File objects of the picked images.
  final List<File?> _images = List.filled(6, null);

  final ImagePicker _picker = ImagePicker();

  // This computed property checks if all 6 photos have been uploaded.
  bool get _isUploadComplete => _images.every((image) => image != null);

  // Function to handle picking an image
  Future<void> _pickImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  // Function to handle the save action
  void _savePhotos() {
    if (_isUploadComplete) {
      // Add your logic to upload files or navigate to the next screen
      print("All photos are selected. Saving...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photos saved successfully!')),
      );
    } else {
      print("Please select all 6 photos.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('6 photos required to save.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // A dark background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 97),
              // Top Icon
              Image.asset(
                'assets/images/icon.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),

              // Header Text
              const Text(
                'Make Your First Impression',
                style: TextStyle(
                  fontFamily: 'BricolageGrotesqueMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2, // Line height
                ),
              ),
              const Text(
                'Count',
                style: TextStyle(
                  fontFamily: 'BricolageGrotesqueMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),

              // Photo Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0, // Makes the items square
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    if (_images[index] != null) {
                      return _buildPhotoBox(_images[index]!, index);
                    } else {
                      return _buildPlaceholderBox(index);
                    }
                  },
                ),
              ),

              // Description Text
              const Text(
                '6 photos required',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Medium weight
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your photo will be visible to event hosts and members',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderBox(int index) {
    // The GestureDetector itself cannot be const because its `onTap`
    // callback is a new closure created for each index.
    return GestureDetector(
      onTap: () => _pickImage(index),
      // However, its child WIDGET is visually identical every time.
      // Making it `const` allows Flutter to create it once and reuse it,
      // which is a major performance boost.
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        color: Colors.white38,
        strokeWidth: 1.5,
        dashPattern: [6, 6],
        child: _PlaceholderContent(),
      ),
    );
  }

  // Widget for the box showing a picked image
  Widget _buildPhotoBox(File image, int index) {
    return GestureDetector(
      onTap: () => _pickImage(index), // Allow re-picking an image
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(image, fit: BoxFit.cover),
      ),
    );
  }

  // Widget for the Save button with state-dependent styling
  Widget _buildSaveButton() {
    bool isEnabled = _isUploadComplete;

    return GestureDetector(
      onTap: isEnabled ? _savePhotos : null,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // Apply gradient only when enabled, otherwise a solid gray color
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [
                    Color(0xFF8A2387),
                    Color(0xFFE94057),
                    Color(0xFFF27121),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey[850], // Inactive color
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // SemiBold
                  color: Colors.white.withOpacity(isEnabled ? 1.0 : 0.5),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                color: Colors.white.withOpacity(isEnabled ? 1.0 : 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent(); // Note the const constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      // The background color and border radius are part of the static content.
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          255,
          255,
          255,
          0.05,
        ), // Use const-compatible color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        // The image is also constant.
        child: Image.asset('assets/images/grp.png'),
      ),
    );
  }
}
