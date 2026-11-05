// lib/favorites_data.dart
class FavoriteItem {
  final String name;
  final String image;
  final String location;
  final String price;

  FavoriteItem({
    required this.name,
    required this.image,
    required this.location,
    required this.price,
  });
}

List<FavoriteItem> favoritesItems = [];
