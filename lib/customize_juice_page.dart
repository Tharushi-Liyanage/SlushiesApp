import 'package:flutter/material.dart';

class CustomizeJuicePage extends StatelessWidget {
  const CustomizeJuicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Your Juice"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/customize_back.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: const [
                  JuiceBox(title: "Mango Juice", image: "assets/mango.jpg"),
                  SizedBox(height: 16),
                  JuiceBox(title: "Pineapple Juice", image: "assets/pineapple.webp"),
                  SizedBox(height: 16),
                  JuiceBox(title: "Papaya Juice", image: "assets/papaya.jpg"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JuiceBox extends StatefulWidget {
  final String title;
  final String image;

  const JuiceBox({super.key, required this.title, required this.image});

  @override
  State<JuiceBox> createState() => _JuiceBoxState();
}

class _JuiceBoxState extends State<JuiceBox> {
  bool addSugar = false;
  bool addWater = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(widget.image, width: 70, height: 70),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => addSugar = !addSugar);
                },
                icon: Icon(addSugar ? Icons.check_box : Icons.add),
                label: Text(addSugar ? "Sugar Added" : "Add Sugar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: addSugar ? Colors.green : Colors.orange,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => addWater = !addWater);
                },
                icon: Icon(addWater ? Icons.check_box : Icons.water_drop),
                label: Text(addWater ? "Water Added" : "Add Water"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: addWater ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/selectMachine',
                  arguments: {
                    'selectedDrink': widget.title,
                    'addSugar': addSugar,
                    'addWater': addWater,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Order", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
