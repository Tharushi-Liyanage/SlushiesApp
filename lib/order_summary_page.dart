import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Juice: Mango"),
            Text("Sugar: Medium"),
            Text("Ice: Low"),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/payment'), child: Text("Proceed to Payment")),
          ],
        ),
      ),
    );
  }
}
