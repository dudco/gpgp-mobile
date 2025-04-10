import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth-screen.dart';

void main() {
  runApp(const GpgpApp());
}

class GpgpApp extends StatelessWidget {
  const GpgpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPGP App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3727EB),
          primary: const Color(0xFF3727EB),
          secondary: const Color(0xFFF7DD30),
          tertiary: const Color(0xFF1F04A8),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/background.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image isn't available
                        return Container(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Text Overlay - centered with some bottom offset
                  Positioned(
                    top: 250,
                    child: SizedBox(
                      width: 240,
                      height: 88,
                      child: Image.asset(
                        'assets/images/title-logo.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Positioned(
                    bottom: 120,
                    child: _buildGetStartedButton(context),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Container(
      width: 326,
      decoration: BoxDecoration(
        color: const Color(0xFFF7DD30), // Yellow color from design
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2C2C2C),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to the home screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Center(
              child: Text(
                "Let's Get Started!",
                style: TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// HomeScreen is imported from home_screen.dart