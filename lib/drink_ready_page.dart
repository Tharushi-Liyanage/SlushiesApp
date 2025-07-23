import 'package:flutter/material.dart';

class DrinkReadyPage extends StatefulWidget {
  const DrinkReadyPage({super.key});

  @override
  State<DrinkReadyPage> createState() => _DrinkReadyPageState();
}

class _DrinkReadyPageState extends State<DrinkReadyPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate some processing/loading (e.g., waiting for the drink to be prepared)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Status"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/confirm_back.jpg'), // your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5), // dark overlay for contrast
          child: Center(
            child: _isLoading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Preparing your drink...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/drink_ready.jpg', // your "drink ready" image
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your drink is ready!",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          // or navigate to your main/home page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Done",
                          style: TextStyle(fontSize: 18),
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
