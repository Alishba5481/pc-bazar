import 'package:flutter/material.dart';
import 'package:pc_bazaar/categories_page.dart';
import 'notifications_page.dart';
import 'cart_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'featured_items_page.dart';
import 'buy_now_page.dart';
import 'keyboards_page.dart';
import 'mouse_page.dart';
import 'monitors_page.dart';
import 'gpus_page.dart';
import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(context),
      const SearchPage(),
      const FavoritesPage(),
      const ProfilePage(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: _currentIndex, children: pages),

        // Floating Add Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFE43E2B),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddProductPage()));
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF0081FF),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: _currentIndex == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => setState(() => _currentIndex = 0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: _currentIndex == 1
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => setState(() => _currentIndex = 1),
                ),

                const SizedBox(width: 40),

                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: _currentIndex == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => setState(() => _currentIndex = 2),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: _currentIndex == 3
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  onPressed: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ HOME CONTENT --------------------
  Widget _homeContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // --- Top Bar ---
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.asset("assets/logo2.png",
                width: 106, height: 54, fit: BoxFit.cover),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.notifications_none,
                    size: 28, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsPage()));
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    size: 28, color: Colors.black),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CartPage()));
                },
              ),
            ])
          ]),
          const SizedBox(height: 16),

          // --- Banner ---
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/Banner.png",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),

          // --- Shop by Category ---
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Shop By Category',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CategoriesPage()));
              },
              child: const Text(
                'See All',
                style: TextStyle(
                    color: Color(0xFFE43E2B),
                    fontSize: 12,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ]),
          const SizedBox(height: 10),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _categoryItem(
                "assets/feature.jpg",
                "Keyboards",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const KeyboardsPage())),
              ),
              _categoryItem(
                "assets/mouse.webp",
                "Mouse",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MousePage())),
              ),
              _categoryItem(
                "assets/monitor.webp",
                "Monitors",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MonitorsPage())),
              ),
              _categoryItem(
                "assets/gpu.webp",
                "GPUs",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GPUsPage())),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ---------------- FEATURED ITEMS -----------------
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Featured Items For Sale',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FeaturedItemsPage()));
              },
              child: const Text(
                'See All',
                style: TextStyle(
                    color: Color(0xFFE43E2B),
                    fontSize: 12,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ]),
          const SizedBox(height: 10),

          // ---------- 4 FEATURED BOXES (UPDATED) ----------
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _featuredItem(
                        context,
                        "assets/feature3.jpeg",
                        "Mianwali",
                        "Razor Blade Mouse Black",
                        "PKR 6500"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _featuredItem(
                        context,
                        "assets/feature2.jpg",
                        "Lahore",
                        "LG 144Hz Display Monitor",
                        "PKR 44000"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _featuredItem(
                        context,
                        "assets/feature4.jpg",
                        "Islamabad",
                        "Mechanical Gaming Keyboard",
                        "PKR 9500"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _featuredItem(
                        context,
                        "assets/feature5.jpg",
                        "Rawalpindi",
                        "AMD Radeon GPU",
                        "PKR 125000"),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  // ---------------- CATEGORY BOX ------------------
  static Widget _categoryItem(
      String img, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(img, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 4),
        Text(title,
            style: const TextStyle(
                fontSize: 10, fontFamily: 'Montserrat')),
      ]),
    );
  }

  // ---------------- FEATURED BOX ------------------
  Widget _featuredItem(BuildContext context, String img, String location,
      String name, String price) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image:
            DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
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
                          Text(location,
                              style: TextStyle(
                                  color:
                                      Colors.white.withOpacity(0.6),
                                  fontSize: 12)),
                          Text(name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w500)),
                          Text(price,
                              style: const TextStyle(
                                  color: Color(0xFFE43E2B),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700)),
                        ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BuyNowPage(
                            itemName: name,
                            itemImage: img,
                            price: double.tryParse(price
                                    .replaceAll(RegExp(r'[^0-9]'), '')) ??
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
                      child: const Text("Get Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
