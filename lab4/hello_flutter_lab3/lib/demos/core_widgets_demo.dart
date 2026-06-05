import 'package:flutter/material.dart';

/// Exercise 1 - Core Widgets: Text, Image, Icon, Card, ListTile
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Widgets Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline Text
            const Text(
              'Welcome to Core Widgets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Icon using Material icons
            Row(
              children: const [
                Icon(Icons.star, size: 40, color: Colors.amber),
                SizedBox(width: 8),
                Text('Featured'),
              ],
            ),
            const SizedBox(height: 16),

            // Image from network (picsum for placeholder)
            Center(
              child: Image.network(
                'https://picsum.photos/300/180',
                width: 300,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Card containing a ListTile
            Card(
              elevation: 4,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('ListTile inside Card'),
                subtitle: const Text('Use Card + ListTile for list items'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'This screen demonstrates basic display widgets used in Flutter UIs.',
            ),
          ],
        ),
      ),
    );
  }
}
