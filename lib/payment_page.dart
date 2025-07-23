import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Order Info
  late String selectedDrink;
  late String selectedMachine;
  late bool addSugar;
  late bool addWater;
  String? orderId;

  // Card Info
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  bool isSavingOrder = false;
  bool isProcessingPayment = false;
  bool orderSaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    selectedDrink = args?['drink'] ?? 'Unknown Drink';
    selectedMachine = args?['machine'] ?? 'Unknown Machine';
    addSugar = args?['addSugar'] ?? false;
    addWater = args?['addWater'] ?? false;
  }

  Future<void> saveOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not signed in.")),
      );
      return;
    }

    setState(() => isSavingOrder = true);

    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final newOrderId = orderRef.id;

      await orderRef.set({
        'userId': user.uid,
        'email': user.email,
        'drink': selectedDrink,
        'machine': selectedMachine,
        'addSugar': addSugar,
        'addWater': addWater,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 👇 Make sure setState updates both orderId and orderSaved
      setState(() {
        orderId = newOrderId;
        orderSaved = true;
        isSavingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order saved. Enter card details to proceed.")),
      );
    } catch (e) {
      setState(() => isSavingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save order: $e")),
      );
      debugPrint("❌ Error in saveOrder: $e");
    }
  }

  Future<void> handlePayment() async {
    final user = FirebaseAuth.instance.currentUser;

    final cardNumber = cardNumberController.text.trim();
    final expiry = expiryController.text.trim();
    final cvv = cvvController.text.trim();

    if (cardNumber.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all card details")),
      );
      return;
    }

    if (user == null || orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing order or user info")),
      );
      debugPrint("❌ Missing user or orderId (orderId: $orderId)");
      return;
    }

    setState(() => isProcessingPayment = true);

    try {
      final maskedCard = cardNumber.replaceRange(0, cardNumber.length - 4, '*' * (cardNumber.length - 4));
      final last4 = cardNumber.substring(cardNumber.length - 4);

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('payments')
          .doc(orderId) // 🔁 Match ID
          .set({
        'userId': user.uid,
        'email': user.email,
        'maskedCard': maskedCard,
        'cardLast4': last4,
        'expiry': expiry,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'success',
      });

      _showSuccessAndNavigate();
    } catch (e) {
      debugPrint("❌ Error in handlePayment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    } finally {
      setState(() => isProcessingPayment = false);
    }
  }

  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Successful"),
        content: const Text("Your card payment has been processed."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/drinkReady');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.orange[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm & Pay'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/payment_back.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 🔶 Order Summary Card
                Card(
                  color: const Color(0xFFFFF3E0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        buildSummaryRow('Selected Drink:', selectedDrink),
                        buildSummaryRow('Machine Location:', selectedMachine),
                        buildSummaryRow('Add Sugar:', addSugar ? 'Yes' : 'No'),
                        buildSummaryRow('Add Water:', addWater ? 'Yes' : 'No'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isSavingOrder ? null : saveOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isSavingOrder
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Confirm Order', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔶 Card Payment Section
                if (orderSaved)
                  Card(
                    color: const Color(0xFFFFF3E0),
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            "Enter Card Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: cardNumberController,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration("Card Number"),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration: buildInputDecoration("MM/YY"),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: cvvController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration("CVV"),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isProcessingPayment ? null : handlePayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isProcessingPayment
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Pay Now", style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
