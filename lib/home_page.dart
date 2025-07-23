import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> buttonWidths = [320, 280, 240, 200];
    final List<String> buttonTexts = [
      'Customize Juice',
      'Order History',
      'Settings',
      'About'
    ];
    final List<String> routes = [
      '/customize',
      '/history',
      '/settings',
      '/about'
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Background Image
          Image.asset(
            'assets/home_back.jpg', // Make sure this image exists in your assets folder
            fit: BoxFit.cover,
          ),

          // 🟣 Dark overlay for contrast
          Container(color: Colors.black.withOpacity(0.4)),

          // 📦 Button List
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(buttonTexts.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _HoverAnimatedButton(
                      width: buttonWidths[index],
                      label: buttonTexts[index],
                      onTap: () {
                        Navigator.pushNamed(context, routes[index]);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔁 Custom Widget to handle hover animation
class _HoverAnimatedButton extends StatefulWidget {
  final double width;
  final String label;
  final VoidCallback onTap;

  const _HoverAnimatedButton({
    required this.width,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HoverAnimatedButton> createState() => _HoverAnimatedButtonState();
}

class _HoverAnimatedButtonState extends State<_HoverAnimatedButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: widget.width,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.orange[600],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
