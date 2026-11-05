import 'package:flutter/material.dart';
import 'keyboards_page.dart';
import 'mouse_page.dart';
import 'monitors_page.dart';
import 'gpus_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "img": "assets/feature.jpg",
        "name": "Keyboards",
        "page": const KeyboardsPage()
      },
      {
        "img": "assets/mouse.webp",
        "name": "Mouse",
        "page": const MousePage()
      },
      {
        "img": "assets/monitor.webp",
        "name": "Monitors",
        "page": const MonitorsPage()
      },
      {
        "img": "assets/gpu.webp",
        "name": "GPUs",
        "page": const GPUsPage()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // navigate to its page:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => category['page'] as Widget),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(category['img'] as String),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.4),
                ),
                alignment: Alignment.center,
                child: Text(
                  category['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
