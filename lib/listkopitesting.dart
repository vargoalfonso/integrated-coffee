import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/pembayaran.dart';
import 'package:http/http.dart' as http;

class CoffeeOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: CoffeeOrderScreen1(),
    );
  }
}

class CoffeeOrderScreen1 extends StatefulWidget {
  @override
  _CoffeeOrderScreenState1 createState() => _CoffeeOrderScreenState1();
}

class _CoffeeOrderScreenState1 extends State<CoffeeOrderScreen1> {
  int coffeeCount = 0;
  bool isHot = true;
  bool isLessSugar = false;
  bool isDelivery = false; // New variable for delivery
  String selectedCoffee = 'Bloemen Latte';

  // Prices (replace with your actual prices)
  final Map<String, double> coffeePrices = {
    'Bloemen Latte': 23000,
    'Lemon Aerocano': 25000,
    'Tiramisu Koffie': 28000,
    'Bloemen Koffie': 23000,
    'Ropresso Latte': 28000,
    'Bloem Matcha': 25000,
    'Bloem Choco': 25000,
    'Bloem Taro': 25000,
    'Bloem Fresher Lychee': 28000,
    'Bloem Fresher Strawberry': 30000,
  };

  double calculateTotalPrice() {
    double basePrice = coffeePrices[selectedCoffee] ?? 0.0;
    double totalPrice = basePrice * coffeeCount;

    // Additional charges for hot/cold and sugar preference
    if (isHot) {
      totalPrice += 0.0; // Adjust with your actual hot price
    }

    if (isLessSugar) {
      totalPrice += 0.0; // Adjust with your actual less sugar price
    }

    // Additional charge for delivery
    if (isDelivery) {
      totalPrice += 10000; // Adjust with your actual delivery charge
    }

    return totalPrice;
  }

  Future<void> sendOrderToGoogleSheets() async {
    final url =
        'https://script.google.com/macros/s/AKfycbyuus-QiskxHhAFvopgwjx9AJ4dFw8Q-DSfkLBA0jMgz8_SQXOpFOHgMTCXVZ4rSXw/exec'; // Gantilah dengan URL skrip Anda

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'coffeeType': selectedCoffee,
        'coffeeCount': coffeeCount,
        'isHot': isHot,
        'isLessSugar': isLessSugar,
        'isDelivery': isDelivery,
      }),
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim ke Google Sheets');
    } else {
      print('Gagal mengirim data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.local_cafe),
              title: Text(selectedCoffee),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        coffeeCount++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                  Text('$coffeeCount'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (coffeeCount > 0) {
                          coffeeCount--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Pilih Minuman:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCoffee,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCoffee = newValue!;
                });
              },
              items: <String>[
                'Bloemen Latte',
                'Lemon Aerocano',
                'Tiramisu Koffie',
                'Bloemen Koffie',
                'Ropresso Latte',
                'Bloem Matcha',
                'Bloem Choco',
                'Bloem Taro',
                'Bloem Fresher Lychee',
                'Bloem Fresher Strawberry'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text(
              'Pilihan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isHot = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isHot ? Colors.brown : Colors.grey),
                  ),
                  child: Text('Hot'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isHot = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        !isHot ? Colors.brown : Colors.grey),
                  ),
                  child: Text('Cold'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLessSugar = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        !isLessSugar ? Colors.brown : Colors.grey),
                  ),
                  child: Text('Normal Sugar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLessSugar = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isLessSugar ? Colors.brown : Colors.grey),
                  ),
                  child: Text('Less Sugar'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Delivery'),
                Switch(
                  value: isDelivery,
                  onChanged: (value) {
                    setState(() {
                      isDelivery = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Harga: ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                await sendOrderToGoogleSheets();
                // Navigate to OrderCompleteScreen
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PembayaranPage(
                      qrCodeAssetPath: 'assets/images/QR.jpg',
                      paymentImageController: TextEditingController(),
                      onPaymentComplete: () {
                        // Handle payment complete, e.g., navigate to OrderCompleteScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderCompleteScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Text('Pesanan Selesai'),
            ),
          ],
        ),
      ),
    );
  }
}

// New screen for order completion
class OrderCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Complete'),
      ),
      body: Center(
        child: Text('Terima kasih! Pesanan Anda telah selesai.'),
      ),
    );
  }
}
