import 'package:flutter/material.dart';
import 'cart_data.dart';
import 'backend.dart';

class BuyNowPage extends StatefulWidget {
  final String itemName;
  final String itemImage;
  final double price;

  const BuyNowPage({
    super.key,
    required this.itemName,
    required this.itemImage,
    required this.price,
  });

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  bool dealWithPcBazaar = true;

  // ================= USER INFO =================
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // ================= PAYMENT INFO =================
  final TextEditingController accHolderController = TextEditingController();
  final TextEditingController accNumberController = TextEditingController();
  final TextEditingController transactionIdController =
      TextEditingController();

  bool get isFormValid =>
      addressController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty;

  // ================= ADD TO CART =================
  void _addToCart() {
    cartItems.add(
      CartItem(
        name: widget.itemName,
        image: widget.itemImage,
        price: widget.price,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item added to cart")),
    );
  }

  // ================= SAVE ORDER TO SUPABASE =================
  Future<void> _saveOrder({
    required String paymentMethod,
    String? transactionId,
  }) async {
    await Backend.instance.addOrder(
      itemName: widget.itemName,
      itemPrice: widget.price,
      itemImage: widget.itemImage,
      address: addressController.text,
      phone: phoneController.text,
      paymentMethod: paymentMethod,
      transactionId: transactionId,
    );
  }

  // ================= PAYMENT METHOD DIALOG =================
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bankTransferButton(),
              const SizedBox(height: 10),
              _cashOnDeliveryButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _bankTransferButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0081FF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          _showBankTransferForm();
        },
        child: const Text(
          "Bank Transfer",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _cashOnDeliveryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          Navigator.pop(context);

          await _saveOrder(paymentMethod: "Cash on Delivery");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Order placed using Cash on Delivery"),
            ),
          );

          Navigator.pop(context);
        },
        child: const Text(
          "Cash on Delivery",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // ================= BANK TRANSFER FORM =================
  void _showBankTransferForm() {
    accHolderController.clear();
    accNumberController.clear();
    transactionIdController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bank Transfer Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Transfer Amount To:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text("Bank: Meezan Bank"),
                const Text("Account Title: PC Bazaar"),
                const Text("Account No: 1234567890"),
                const Text("IBAN: PK12MEZN000000123456789"),
                const Divider(height: 25),

                TextField(
                  controller: accHolderController,
                  decoration: const InputDecoration(
                    labelText: "Your Account Holder Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: accNumberController,
                  decoration: const InputDecoration(
                    labelText: "Your Account / Wallet Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: transactionIdController,
                  decoration: const InputDecoration(
                    labelText: "Transaction ID / Reference No",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0081FF),
              ),
              onPressed: () async {
                if (accHolderController.text.isEmpty ||
                    accNumberController.text.isEmpty ||
                    transactionIdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill all fields")),
                  );
                  return;
                }

                Navigator.pop(context);

                await _saveOrder(
                  paymentMethod: "Bank Transfer",
                  transactionId: transactionIdController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Order placed! Waiting for payment verification."),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Confirm Order",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    double serviceCharge = dealWithPcBazaar ? 500 : 0;
    double total = widget.price + serviceCharge;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out"),
        backgroundColor: const Color(0xFF0081FF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selected Item",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(widget.itemImage, width: 80, height: 80),
                  const SizedBox(width: 10),
                  Expanded(child: Text(widget.itemName)),
                  Text(
                    "PKR ${widget.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= ADD TO CART BUTTON =================
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _addToCart,
                style: OutlinedButton.styleFrom(
                  side:
                      const BorderSide(color: Color(0xFF0081FF), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0081FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Your Address",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter delivery address",
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 15),

            const Text("Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "03XXXXXXXXX",
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            const Divider(),

            _summaryRow("Item Price", "PKR ${widget.price.toStringAsFixed(0)}"),
            _summaryRow(
                "Service Charges", "PKR ${serviceCharge.toStringAsFixed(0)}"),
            const Divider(),
            _summaryRow("Total", "PKR ${total.toStringAsFixed(0)}",
                bold: true),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFormValid ? _showPaymentDialog : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFormValid ? const Color(0xFF0081FF) : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Confirm & Place Order",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text(value,
              style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        ],
      ),
    );
  }
}
