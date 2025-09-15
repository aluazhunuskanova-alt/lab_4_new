import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      home: const HomeScreen(),
      routes: {
        SecondScreen.route: (_) => const SecondScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String _currentImagePath = 'assets/images/image1.jpg';


  final BoxFit _fit = BoxFit.cover;

  void _toggleImage() {
    setState(() {
      _currentImagePath = _currentImagePath == 'assets/images/image1.jpg'
          ? 'assets/images/image2.jpg'
          : 'assets/images/image1.jpg';
    });
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hello from SnackBar!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lab 4: Images, Stack & Buttons',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
          
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  
                  Image.asset(
                    _currentImagePath,
                    fit: _fit,
                  ),

                  
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),

                  
                  Center(
                    child: Text(
                      'Welcome to Flutter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(1, 1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _showSnackBar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Show SnackBar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                 
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SecondScreen.route);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                       
                      ),
                      child: const Text(
                        'Go to Second Screen',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _toggleImage,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Toggle Image',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  static const route = '/second';

  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Second Screen',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'You made it to the second screen 🚀',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
