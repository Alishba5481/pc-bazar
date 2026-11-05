import 'package:flutter/material.dart';
import 'keyboards_page.dart';
import 'mouse_page.dart';
import 'gpus_page.dart';
import 'monitors_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // All categories list
  final List<Map<String, dynamic>> allCategories = [
    {'name': 'Keyboards', 'brand': 'Logitech', 'price': 50, 'available': true},
    {'name': 'Mouse', 'brand': 'Razer', 'price': 30, 'available': true},
    {'name': 'Monitors', 'brand': 'Dell', 'price': 200, 'available': false},
    {'name': 'GPUs', 'brand': 'Nvidia', 'price': 400, 'available': true},
  ];

  // Filtered list to display
  List<Map<String, dynamic>> filteredCategories = [];

  // Advanced search options
  bool showAdvanced = false;
  RangeValues priceRange = const RangeValues(0, 500);
  String selectedBrand = 'All';
  bool onlyAvailable = false;

  final List<String> brands = ['All', 'Logitech', 'Razer', 'Dell', 'Nvidia'];

  @override
  void initState() {
    super.initState();
    filteredCategories = allCategories; // initially all
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = allCategories.where((item) {
        final matchesQuery =
            item['name'].toString().toLowerCase().contains(query.toLowerCase());

        final matchesBrand = selectedBrand == 'All' || item['brand'] == selectedBrand;

        final matchesPrice = item['price'] >= priceRange.start &&
            item['price'] <= priceRange.end;

        final matchesAvailability = !onlyAvailable || item['available'] == true;

        return matchesQuery && matchesBrand && matchesPrice && matchesAvailability;
      }).toList();
    });
  }

  void _openCategoryPage(String item) {
    if (item == "Keyboards") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KeyboardsPage()),
      );
    } else if (item == "Mouse") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MousePage()),
      );
    } else if (item == "GPUs") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GPUsPage()),
      );
    } else if (item == "Monitors") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MonitorsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Categories'),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(showAdvanced ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                showAdvanced = !showAdvanced;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: 'Search any keyword...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Advanced Search Options
          if (showAdvanced)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Brand dropdown
                  Row(
                    children: [
                      const Text('Brand:'),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedBrand,
                        items: brands
                            .map((brand) =>
                                DropdownMenuItem(value: brand, child: Text(brand)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBrand = val!;
                            _filterCategories('');
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price range slider
                  Row(
                    children: [
                      const Text('Price:'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RangeSlider(
                          min: 0,
                          max: 500,
                          values: priceRange,
                          onChanged: (RangeValues values) {
                            setState(() {
                              priceRange = values;
                              _filterCategories('');
                            });
                          },
                        ),
                      ),
                      Text('\$${priceRange.start.toInt()} - \$${priceRange.end.toInt()}'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Availability checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: onlyAvailable,
                        onChanged: (val) {
                          setState(() {
                            onlyAvailable = val!;
                            _filterCategories('');
                          });
                        },
                      ),
                      const Text('Only Available'),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final item = filteredCategories[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('${item['brand']} - \$${item['price']}'),
                  trailing: item['available']
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),
                  onTap: () {
                    _openCategoryPage(item['name']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}