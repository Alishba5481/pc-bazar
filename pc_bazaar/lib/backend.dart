import 'dart:convert';
import 'dart:typed_data';

class BackendUser {
  final String email;
  final String fullName;
  final String phone;

  const BackendUser({
    required this.email,
    required this.fullName,
    required this.phone,
  });
}

class BackendProduct {
  final String id;
  final String title;
  final String category;
  final String price;
  final String description;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String status;

  const BackendProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.status,
    this.imageUrl,
    this.imageBytes,
  });
}

class BackendOrder {
  final String id;
  final String itemName;
  final double itemPrice;
  final String itemImage;
  final String address;
  final String phone;
  final String paymentMethod;
  final String? transactionId;
  String status;
  final DateTime createdAt;

  BackendOrder({
    required this.id,
    required this.itemName,
    required this.itemPrice,
    required this.itemImage,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.transactionId,
  });
}

class Backend {
  Backend._();

  static final Backend instance = Backend._();

  final Map<String, Map<String, String>> _users = {
    'demo@pcbazaar.com': {
      'password': '123456',
      'full_name': 'Demo User',
      'phone': '03001234567',
    },
  };

  BackendUser? _currentUser;
  BackendUser? get currentUser => _currentUser;

  final List<BackendProduct> _products = [];
  final List<BackendOrder> _orders = [];

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    if (_users.containsKey(email)) return false;
    _users[email] = {
      'password': password,
      'full_name': fullName,
      'phone': phone,
    };
    _currentUser = BackendUser(email: email, fullName: fullName, phone: phone);
    return true;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final user = _users[email];
    if (user == null) return false;
    if (user['password'] != password) return false;
    _currentUser = BackendUser(
      email: email,
      fullName: user['full_name'] ?? '',
      phone: user['phone'] ?? '',
    );
    return true;
  }

  Future<void> resetPasswordForEmail(String email) async {
    // Intentionally a no-op for local backend.
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<void> addOrder({
    required String itemName,
    required double itemPrice,
    required String itemImage,
    required String address,
    required String phone,
    required String paymentMethod,
    String? transactionId,
  }) async {
    _orders.insert(
      0,
      BackendOrder(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        itemName: itemName,
        itemPrice: itemPrice,
        itemImage: itemImage,
        address: address,
        phone: phone,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        status: 'pending',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<List<BackendOrder>> fetchOrders() async {
    return List<BackendOrder>.unmodifiable(_orders);
  }

  Future<void> updateOrderStatus(String id, String status) async {
    for (final order in _orders) {
      if (order.id == id) {
        order.status = status;
        break;
      }
    }
  }

  Future<void> addProduct({
    required String title,
    required String price,
    required String description,
    required String category,
    required String status,
    Uint8List? imageBytes,
  }) async {
    _products.insert(
      0,
      BackendProduct(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        price: price,
        description: description,
        category: category,
        status: status,
        imageBytes: imageBytes,
      ),
    );
  }

  Future<List<BackendProduct>> fetchProductsByCategory(String category) async {
    return _products.where((p) => p.category == category).toList(growable: false);
  }

  static Uint8List? tryDecodeDataUrl(String value) {
    // Supports: data:image/...;base64,AAAA
    final comma = value.indexOf(',');
    if (!value.startsWith('data:') || comma == -1) return null;
    final meta = value.substring(0, comma);
    if (!meta.contains('base64')) return null;
    final b64 = value.substring(comma + 1);
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }
}

