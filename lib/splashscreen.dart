import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:loopin_v2/screens/host/interest.dart'; // The screen to navigate to

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Hide system UI for a full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = VideoPlayerController.asset('assets/video/splash.mp4')
      ..initialize().then((_) {
        // *** THE FIX IS HERE ***
        // This block of code only runs AFTER the video has finished initializing.

        // Ensure the first frame is shown and trigger a rebuild
        setState(() {});

        // Now, play the video
        _controller.play();

        // And ONLY NOW, start the timer to navigate away.
        _navigateToHome();
      });

    // Set volume can be done here.
    _controller.setVolume(0.0);
  }

  void _navigateToHome() async {
    // Wait for a duration. 4 seconds should be enough for your video.
    await Future.delayed(const Duration(seconds: 4));

    // Check if the widget is still in the tree before navigating
    if (mounted) {
      Navigator.pushReplacement(
        context,
        // Use a FadeTransition for a smoother screen change
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              InvitationPreferencesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _controller.dispose();
    // Restore system UI when leaving the splash screen
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Match the video's background
      body: Center(
        // We wait for the controller to be initialized before showing the video
        child: _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            // While loading, you can show a black screen or a loading indicator
            : Container(color: Colors.black),
      ),
    );
  }
}
