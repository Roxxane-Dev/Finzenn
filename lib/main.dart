import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinzennApp());
}

class FinzennApp extends StatelessWidget {
  const FinzennApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finzenn',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Dark UI base
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6B48FF), // Purple/Blue glow from design
          secondary: const Color(0xFF11D4C4),
          surface: Colors.white.withOpacity(0.1),
        ),
        fontFamily: 'Inter',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Premium Glass style)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6B48FF).withOpacity(0.5),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your wallet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  // Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Balance', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
                            const SizedBox(height: 8),
                            const Text('\$9,520.35', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 24),
                            // Quick Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildActionIcon(Icons.swap_horiz, 'Swap'),
                                _buildActionIcon(Icons.ac_unit, 'Freeze'),
                                _buildActionIcon(Icons.send, 'Send'),
                                _buildActionIcon(Icons.api, 'Receive'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
      ],
    );
  }
}
