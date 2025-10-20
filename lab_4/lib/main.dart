import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lab 4', home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String path = 'assets/images/image1.jpg';   // image1.jpg + image2.jpg in assets
  BoxFit fit = BoxFit.cover;                  // change if you want to test other fits

  void toggleImage() {
    setState(() {
      path = (path == 'assets/images/image1.jpg')
          ? 'assets/images/image2.jpg'
          : 'assets/images/image1.jpg';
    });
  }

  void showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hello from SnackBar!')),
    );
  }

  void goSecond() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SecondScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lab 4: Images, Stack & Buttons')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(path, fit: fit),                   // Image + BoxFit
                Container(color: Colors.black.withOpacity(0.35)), // overlay
                Center(
                  child: Text('Welcome to Flutter',
                      style: TextStyle(color: Colors.white, fontSize: 28)),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: showSnack,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Show SnackBar'),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: 200,
            height: 50,
            child: TextButton(
              onPressed: goSecond,
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Text('Go to Second Screen'),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: 200,
            height: 50,
            child: OutlinedButton(
              onPressed: toggleImage,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black, width: 1.5),
                foregroundColor: Colors.black,
              ),
              child: Text('Toggle Image'),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen')),
      body: Center(child: Text('You made it to the second screen')),
    );
  }
}
