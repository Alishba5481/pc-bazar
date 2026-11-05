import 'package:flutter/material.dart';
import 'favorites_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: favoritesItems.isEmpty
          ? const Center(child: Text('No favorite items yet'))
          : ListView.builder(
              itemCount: favoritesItems.length,
              itemBuilder: (context, index) {
                final item = favoritesItems[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(item.image,
                          width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.location} • ${item.price}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          favoritesItems.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Removed from Favorites')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void didChangeDependencies() {
    // Refresh the list when user returns
    setState(() {});
    super.didChangeDependencies();
  }
}
