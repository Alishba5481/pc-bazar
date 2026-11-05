import 'package:flutter/material.dart';
import 'backend.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  Future<List<BackendOrder>> fetchOrders() async {
    return Backend.instance.fetchOrders();
  }

  Future<void> updateStatus(String id, String status) async {
    await Backend.instance.updateOrderStatus(id, status);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Orders"),
        backgroundColor: const Color(0xFF0081FF),
      ),
      body: FutureBuilder(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data as List;

          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.itemName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text("PKR ${order.itemPrice}"),
                      Text("Phone: ${order.phone}"),
                      Text("Payment: ${order.paymentMethod}"),
                      Text("Txn ID: ${order.transactionId ?? '-'}"),
                      Text("Status: ${order.status}"),
                      const SizedBox(height: 10),

                      if (order.status == 'pending')
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  updateStatus(order.id, 'confirmed'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  updateStatus(order.id, 'rejected'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text("Reject"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
