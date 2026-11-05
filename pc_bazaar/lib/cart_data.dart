// cart_data.dart
class CartItem {
  final String name;
  final String image;
  final double price;

  CartItem({required this.name, required this.image, required this.price});
}

/// Global cart list (can later replace with provider / state management)
List<CartItem> cartItems = [];
