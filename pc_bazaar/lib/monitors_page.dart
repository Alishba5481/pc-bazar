import 'package:flutter/material.dart';
import 'buy_now_page.dart';
import 'favorites_data.dart';

class MonitorsPage extends StatefulWidget {
  const MonitorsPage({super.key});

  @override
  State<MonitorsPage> createState() => _MonitorsPageState();
}

class _MonitorsPageState extends State<MonitorsPage> {
  // Monitor items list
  final monitorItems = [
    {
      "img": "assets/monitor1.jpeg",
      "location": "Karachi",
      "name": "Dell 75Hz Monitor",
      "price": "PKR 28000"
    },
    {
      "img": "assets/monitor2.jpeg",
      "location": "Lahore",
      "name": "LG 144Hz Monitor",
      "price": "PKR 44000"
    },
    {
      "img": "assets/feature2.jpg",
      "location": "Islamabad",
      "name": "Samsung Curved Monitor",
      "price": "PKR 60000"
    },
  ];

  bool _isFavorite(String name) {
    return favoritesItems.any((item) => item.name == name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitors"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// --- Banner ---
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/monitor.webp",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),

          /// --- Heading ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Featured Monitors",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// --- Product Cards ---
          ...monitorItems.map((item) {
            final img = item['img'] ?? "";
            final name = item['name'] ?? "Unknown";
            final price = item['price'] ?? "PKR 0";
            final location = item['location'] ?? "Unknown";

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Image.asset(
                    img,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// --- Gradient Bottom Info Box ---
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// --- Info Text ---
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    color: Color(0xFFE43E2B),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ❤️ Favorite Button
                          IconButton(
                            icon: Icon(
                              _isFavorite(name)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  _isFavorite(name) ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_isFavorite(name)) {
                                  favoritesItems
                                      .removeWhere((fav) => fav.name == name);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Removed from Favorites")),
                                  );
                                } else {
                                  favoritesItems.add(
                                    FavoriteItem(
                                      name: name,
                                      image: img,
                                      location: location,
                                      price: price,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to Favorites")),
                                  );
                                }
                              });
                            },
                          ),

                          /// 🛒 Buy Now Button
                          GestureDetector(
                            onTap: () {
                              final numericPrice = double.tryParse(
                                    price.replaceAll(RegExp(r'[^0-9]'), ''),
                                  ) ??
                                  0;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BuyNowPage(
                                    itemName: name,
                                    itemImage: img,
                                    price: numericPrice,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Get Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
