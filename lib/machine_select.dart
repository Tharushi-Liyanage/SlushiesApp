import 'package:flutter/material.dart';

class SelectMachinePage extends StatelessWidget {
  final String selectedDrink;
  final bool addSugar;
  final bool addWater;

  const SelectMachinePage({
    super.key,
    required this.selectedDrink,
    required this.addSugar,
    required this.addWater,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> machines = [
      {'location': 'Galle', 'name': 'Machine 01', 'image': 'assets/galle.jpg'},
      {'location': 'Talpe', 'name': 'Machine 02', 'image': 'assets/talpe.jpg'},
      {'location': 'Hikkaduwa', 'name': 'Machine 03', 'image': 'assets/hikkaduwa.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Machine"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/select.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Column(
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrange, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    "Selected Drink: $selectedDrink\nSugar: ${addSugar ? "Yes" : "No"}, Water: ${addWater ? "Yes" : "No"}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: machines.length,
                  itemBuilder: (context, index) {
                    final machine = machines[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.deepOrange, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              machine['image']!,
                              width: 70,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            "${machine['location']} - ${machine['name']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text("Available"),
                          trailing: const Icon(Icons.chevron_right, color: Colors.deepOrange),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: {
                                'drink': selectedDrink,
                                'addSugar': addSugar,
                                'addWater': addWater,
                                'machine': "${machine['location']} - ${machine['name']}",
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
