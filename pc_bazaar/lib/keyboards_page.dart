import 'package:flutter/material.dart';
import 'buy_now_page.dart';
import 'favorites_data.dart';
import 'backend.dart';

class KeyboardsPage extends StatefulWidget {
  const KeyboardsPage({super.key});

  @override
  State<KeyboardsPage> createState() => _KeyboardsPageState();
}

class _KeyboardsPageState extends State<KeyboardsPage> {
  // Static demo items
  final keyboardItems = [
    {
      "img": "assets/keyboard2.jpg",
      "location": "Karachi",
      "name": "Mechanical Keyboard",
      "price": "PKR 5000"
    },
    {
      "img": "assets/keyboard1.jpg",
      "location": "Lahore",
      "name": "RGB Gaming Keyboard",
      "price": "PKR 7500"
    },
    {
      "img": "assets/feature.jpg",
      "location": "Islamabad",
      "name": "Wireless Slim Keyboard",
      "price": "PKR 6000"
    },
  ];

  List<BackendProduct> dynamicKeyboards = [];
  bool isLoading = true;

  bool _isFavorite(String name) {
    return favoritesItems.any((item) => item.name == name);
  }

  @override
  void initState() {
    super.initState();
    fetchDynamicKeyboards();
  }

  Future<void> fetchDynamicKeyboards() async {
    try {
      final response =
          await Backend.instance.fetchProductsByCategory('Keyboards');
      setState(() {
        dynamicKeyboards = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching keyboards: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildKeyboardCard({
    required Widget imgWidget,
    required String name,
    required String price,
    required String location,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          imgWidget,

          /// --- Gradient Overlay ---
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
                  /// TEXT
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

                  /// FAVORITE BUTTON
                  IconButton(
                    icon: Icon(
                      _isFavorite(name)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorite(name) ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isFavorite(name)) {
                          favoritesItems.removeWhere((fav) => fav.name == name);
                        } else {
                          favoritesItems.add(FavoriteItem(
                            name: name,
                            image: "",
                            location: location,
                            price: price,
                          ));
                        }
                      });
                    },
                  ),

                  /// BUY BUTTON
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BuyNowPage(
                            itemName: name,
                            itemImage: "",
                            price: double.tryParse(
                                    price.replaceAll(RegExp(r'[^0-9]'), '')) ??
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keyboards"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/feature.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Featured Keyboards",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Static Keyboards
                ...keyboardItems.map((item) {
                  return buildKeyboardCard(
                    imgWidget: Image.asset(
                      item["img"]!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    name: item["name"]!,
                    price: item["price"]!,
                    location: item["location"]!,
                  );
                }),

                /// Dynamic (Local backend) Keyboards
                ...dynamicKeyboards.map((item) {
                  return buildKeyboardCard(
                    imgWidget: item.imageBytes != null
                        ? Image.memory(
                            item.imageBytes!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 60),
                          ),
                    name: item.title,
                    price: "PKR ${item.price}",
                    location: "Local Seller",
                  );
                }),
              ],
            ),
    );
  }
}
