import 'package:flutter/material.dart';
import 'buy_now_page.dart';
import 'favorites_data.dart';

class FeaturedItemsPage extends StatefulWidget {
  const FeaturedItemsPage({super.key});

  @override
  State<FeaturedItemsPage> createState() => _FeaturedItemsPageState();
}

class _FeaturedItemsPageState extends State<FeaturedItemsPage> {
  // Updated list of featured items (5 items now)
  final featuredItems = [
    {
      "img": "assets/feature3.jpeg",
      "location": "Mianwali",
      "name": "Razor Blade Mouse Black",
      "price": "PKR 6500"
    },
    {
      "img": "assets/feature2.jpg",
      "location": "Lahore",
      "name": "LG 144hz Display Monitor",
      "price": "PKR 44000"
    },
    {
      "img": "assets/gpu.webp",
      "location": "Karachi",
      "name": "NVIDIA RTX GPU",
      "price": "PKR 180000"
    },
    {
      "img": "assets/feature4.jpg",
      "location": "Islamabad",
      "name": "Mechanical Gaming Keyboard",
      "price": "PKR 9500"
    },
    {
      "img": "assets/feature5.jpg",
      "location": "Rawalpindi",
      "name": "AMD Radeon GPU",
      "price": "PKR 125000"
    },
  ];

  bool _isFavorite(String name) {
    return favoritesItems.any((item) => item.name == name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Featured Items For Sale"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: featuredItems.length,
        itemBuilder: (context, index) {
          final item = featuredItems[index];
          final img = item['img']!;
          final name = item['name']!;
          final price = item['price']!;
          final location = item['location']!;

          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                location,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w500,
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
                                      content: Text('Removed from Favorites')),
                                );
                              } else {
                                favoritesItems.add(FavoriteItem(
                                  name: name,
                                  image: img,
                                  location: location,
                                  price: price,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Added to Favorites')),
                                );
                              }
                            });
                          },
                        ),

                        /// 📦 Buy Now Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BuyNowPage(
                                  itemName: name,
                                  itemImage: img,
                                  price: double.tryParse(
                                            price.replaceAll(
                                                RegExp(r'[^0-9]'), '')) ??
                                      0,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Get Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
