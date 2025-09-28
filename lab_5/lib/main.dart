import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const HomePage(),     // Task 1 + Task 5 + Task 6
        '/list10': (_) => const List10(), // Task 2
        '/grid6': (_) => const Grid6(),   // Task 3
        '/cards': (_) => const CardsPage()// Task 4
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _toast() {
    Fluttertoast.showToast(msg: "Hello, Flutter!"); // Task 6
  }

  void _snack(BuildContext c, String msg) {
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(msg))); // Task 5
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Task 1
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lab 5'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'List (5)'),
              Tab(text: 'Images Grid'),
            ],
          ),
          // simple access to Tasks 2-4
          actions: [
            IconButton(onPressed: () => Navigator.pushNamed(context, '/list10'), icon: const Icon(Icons.list)),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/grid6'), icon: const Icon(Icons.grid_view)),
            IconButton(onPressed: () => Navigator.pushNamed(context, '/cards'), icon: const Icon(Icons.credit_card)),
          ],
        ),
        drawer: Drawer( // Task 5
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(title: const Text('Home'),    onTap: () { Navigator.pop(context); _snack(context, 'Home selected'); }),
              ListTile(title: const Text('Profile'), onTap: () { Navigator.pop(context); _snack(context, 'Profile selected'); }),
              ListTile(title: const Text('Settings'),onTap: () { Navigator.pop(context); _snack(context, 'Settings selected'); }),
              ListTile(title: const Text('Logout'),  onTap: () { Navigator.pop(context); _snack(context, 'Logout selected'); }),
            ],
          ),
        ),
        body: TabBarView( // Task 1 content
          children: [
            // First tab: ListView of 5 items
            ListView(
              children: const [
                ListTile(title: Text('Item 1'), subtitle: Text('Subtitle 1')),
                ListTile(title: Text('Item 2'), subtitle: Text('Subtitle 2')),
                ListTile(title: Text('Item 3'), subtitle: Text('Subtitle 3')),
                ListTile(title: Text('Item 4'), subtitle: Text('Subtitle 4')),
                ListTile(title: Text('Item 5'), subtitle: Text('Subtitle 5')),
              ],
            ),
            // Second tab: Grid of images from assets
            GridView.count(
              crossAxisCount: 2,
              children: const [
                Image(image: AssetImage('assets/images/image1.jpg')),
                Image(image: AssetImage('assets/images/image2.jpg')),
                Image(image: AssetImage('assets/images/image1.jpg')),
                Image(image: AssetImage('assets/images/image2.jpg')),
                Image(image: AssetImage('assets/images/image1.jpg')),
                Image(image: AssetImage('assets/images/image2.jpg')),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton( // Task 6
          onPressed: _toast,
          child: const Icon(Icons.message),
        ),
      ),
    );
  }
}

// Task 2: ListView with 10 items (title + subtitle)
class List10 extends StatelessWidget {
  const List10({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 2: List of 10')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          final n = i + 1;
          return ListTile(title: Text('Title $n'), subtitle: Text('Subtitle $n'));
        },
      ),
    );
  }
}

// Task 3: GridView with 6 colored containers, numbers inside
class Grid6 extends StatelessWidget {
  const Grid6({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.teal];
    return Scaffold(
      appBar: AppBar(title: const Text('Task 3: Grid of 6')),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(6, (i) {
          return Container(
            margin: const EdgeInsets.all(8),
            color: colors[i],
            child: Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 24, color: Colors.white))),
          );
        }),
      ),
    );
  }
}

// Task 4: Cards with image + title + description
class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'img': 'assets/images/image1.jpg', 'title': 'Card 1', 'desc': 'Simple description 1'},
      {'img': 'assets/images/image2.jpg', 'title': 'Card 2', 'desc': 'Simple description 2'},
      {'img': 'assets/images/image1.jpg', 'title': 'Card 3', 'desc': 'Simple description 3'},
      {'img': 'assets/images/image2.jpg', 'title': 'Card 4', 'desc': 'Simple description 4'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Task 4: Cards')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: items.map((e) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage(e['img']!)),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(e['desc']!),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
