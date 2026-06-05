import 'package:flutter/material.dart';

/// Exercise 3 - Layout Basics: Column, Row, Padding, ListView
class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(20, (i) => 'Movie ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Layout Basics Demo')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Highlighted section',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Card A'),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Card B'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Popular movies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Use Expanded to allow ListView.builder inside Column
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.movie),
                  title: Text(items[index]),
                  subtitle: const Text('Example subtitle'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
