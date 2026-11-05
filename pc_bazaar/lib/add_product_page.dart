import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'backend.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imageFileName;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _selectedCategory;
  String? _priceErrorText;

  final List<String> _categories = ["Mouse", "Keyboards", "Monitors", "GPUs"];

  // ==========================
  // AI FRAUD DETECTION API URL
  // ==========================
  static const String fraudApiUrl = "http://localhost:5000/check_fraud";

  // ==========================
  // PRICE RECOMMENDATION FUNCTION
  // ==========================
  String getPriceRecommendation(String category) {
    switch (category) {
      case "Mouse":
        return "800 – 2000";
      case "Keyboards":
        return "1500 – 4000";
      case "Monitors":
        return "15000 – 45000";
      case "GPUs":
        return "30000 – 200000";
      default:
        return "";
    }
  }

  // ==========================
  // PICK IMAGE
  // ==========================
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageFileName = kIsWeb ? picked.name : picked.path.split('/').last;
      });
    }
  }

  // ==========================
  // CHECK FRAUD STATUS
  // ==========================
  Future<String> _checkFraudStatus() async {
    if (_selectedCategory == null ||
        _titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return "safe";
    }

    try {
      final response = await http.post(
        Uri.parse(fraudApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _titleController.text.trim(),
          "description": _descController.text.trim(),
          "category": _selectedCategory!,
          "price": double.tryParse(_priceController.text.trim()) ?? 0.0,
        }),
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        print("Fraud API error: ${response.statusCode}, body: ${response.body}");
        return "safe";
      }

      final data = jsonDecode(response.body);

      String result = data["result"] ?? "safe";

      if (result != "safe" && result != "medium_risk" && result != "high_risk") {
        result = "safe";
      }

      return result;
    } catch (e) {
      print("Fraud API exception: $e");
      return "safe";
    }
  }

  // ==========================
  // SHOW FRAUD DIALOG
  // ==========================
  Future<void> _showFraudDialog(String result) async {
    IconData icon;
    Color color;
    String text;

    if (result == "safe") {
      icon = Icons.check_circle;
      color = Colors.green;
      text = "Safe";
    } else if (result == "medium_risk") {
      icon = Icons.warning;
      color = Colors.orange;
      text = "Under Review";
    } else {
      icon = Icons.block;
      color = Colors.red;
      text = "Blocked";
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
        content: const Text("AI Fraud Detection Result"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ==========================
  // SUBMIT PRODUCT
  // ==========================
  void _submitProduct() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedCategory == null ||
        _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and add image')),
      );
      return;
    }

    final rec = getPriceRecommendation(_selectedCategory!);
    final parts = rec.split('–');
    final min = int.parse(parts[0].trim());
    final max = int.parse(parts[1].trim());
    final entered = int.parse(_priceController.text.trim());

    if (entered < min || entered > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Price must be between $min and $max PKR")),
      );
      return;
    }

    final currentUser = Backend.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add a product')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final fraudResult = await _checkFraudStatus();
      await _showFraudDialog(fraudResult);

      if (fraudResult == "high_risk") {
        Navigator.of(context).pop();
        return;
      }

      await Backend.instance.addProduct(
        title: _titleController.text.trim(),
        price: _priceController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory!,
        status: fraudResult == "medium_risk" ? "under_review" : "active",
        imageBytes: _imageBytes,
      );

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: const Color(0xFF0081FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imageBytes == null
                  ? Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_a_photo, size: 50),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _imageBytes!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: const OutlineInputBorder(),
                errorText: _priceErrorText,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _priceErrorText = null;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0081FF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: const Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}
