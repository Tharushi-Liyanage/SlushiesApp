import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import your page files
import 'splash_screen.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'customize_juice_page.dart';
import 'settings_page.dart';
import 'history_page.dart';
import 'about_page.dart';
import 'signup_page.dart';
import 'machine_select.dart';
import 'payment_page.dart';
import 'drink_ready_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SlushiesApp());
}

class SlushiesApp extends StatelessWidget {
  const SlushiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slushies Juice Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/customize': (context) => const CustomizeJuicePage(),
        '/settings': (context) => const SettingsPage(),
        '/history': (context) => const HistoryPage(),
        '/about': (context) => const AboutPage(),
        '/drinkReady': (context) => const DrinkReadyPage(),
        '/payment': (context) => const PaymentPage(),
        // ❌ Removed '/selectMachine' and '/payment' — these need arguments and are now handled in `onGenerateRoute`
      },

      // ✅ Use onGenerateRoute to handle pages that require arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/selectMachine') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (_) => SelectMachinePage(
                selectedDrink: args['selectedDrink'] as String,
                addSugar: args['addSugar'] as bool,
                addWater: args['addWater'] as bool,
              ),
            );
          }
        }

        

        // Default fallback (optional)
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
