import 'package:flutter/material.dart';
import 'package:flutter_application_3/Pesanan.dart';
import 'package:flutter_application_3/pembayaran.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TambahPesananPage extends StatefulWidget {
  final Pesanan pesanan;

  TambahPesananPage({required this.pesanan});

  @override
  _TambahPesananPageState createState() => _TambahPesananPageState();
}

class _TambahPesananPageState extends State<TambahPesananPage> {
  bool isDeliveryEnabled = false;
  TextEditingController deliveryAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int totalPrice = calculateTotalPrice();
    int deliveryFee = isDeliveryEnabled ? 15000 : 0;
    TextEditingController paymentImageController = TextEditingController();
    String qrCodeAssetPath = 'assets/placeholder_qr_code.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pesanan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pesanan yang Ditambahkan:'),
            for (var entry in widget.pesanan.items.entries)
              Column(
                children: [
                  Text('${entry.key}: ${entry.value.jumlah}'),
                  Text('Ice: ${entry.value.ice}'),
                  Text('Sugar Level: ${entry.value.sugarLevel}'),
                  Divider(),
                ],
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Delivery'),
                Switch(
                  value: isDeliveryEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDeliveryEnabled = value;
                    });
                  },
                ),
              ],
            ),
            if (isDeliveryEnabled)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: deliveryAddressController,
                  decoration: InputDecoration(labelText: 'Alamat Pengiriman'),
                ),
              ),
            SizedBox(height: 20),
            Text('Total Harga: $totalPrice'),
            if (isDeliveryEnabled) Text('Ongkir: $deliveryFee'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Show loading indicator here
                  // ...

                  await submitOrder();

                  // Hide loading indicator after submission
                  // ...

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PembayaranPage(
                        paymentImageController: paymentImageController,
                        qrCodeAssetPath: qrCodeAssetPath,
                        onPaymentComplete: () {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName('/list'),
                          );
                        },
                      ),
                    ),
                  );
                } catch (error) {
                  // Handle error and hide loading indicator
                  // ...
                }
              },
              child: Text('Selanjutnya'),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var entry in widget.pesanan.items.entries) {
      int itemPrice = getItemPrice(entry.key);
      totalPrice += entry.value.jumlah! * itemPrice;
    }
    return totalPrice + (isDeliveryEnabled ? 15000 : 0);
  }

  int getItemPrice(String itemName) {
    switch (itemName) {
      case 'Bloemen Latte':
        return 23000;
      case 'Bloemen Koffie':
        return 23000;
      case 'Lemon Aerocano':
        return 25000;
      case 'Ropresso Latte':
        return 28000;
      case 'Tiramissu Koffie':
        return 28000;
      case 'Bloem Choco':
        return 25000;
      case 'Bloem Taro':
        return 25000;
      case 'Bloem Fresher Lychee':
        return 28000;
      case 'Bloem Fresher Strawberry':
        return 28000;
      case 'Bloem Matcha':
        return 25000;
      default:
        return 0;
    }
  }

  Future<void> submitOrder() async {
    try {
      final List<Map<String, dynamic>> orderDataList = [];
      for (var entry in widget.pesanan.items.entries) {
        final Map<String, dynamic> itemData = {
          'namaKopi': entry.key,
          'jumlah': entry.value.jumlah,
          'ice': entry.value.ice,
          'sugarLevel': entry.value.sugarLevel,
          'harga': getItemPrice(entry.key) * entry.value.jumlah!,
          'delivery': isDeliveryEnabled,
        };
        orderDataList.add(itemData);
      }

      final Map<String, dynamic> orderData = {
        'items': orderDataList,
        'deliveryEnabled': isDeliveryEnabled,
        'deliveryAddress':
            isDeliveryEnabled ? deliveryAddressController.text : null,
        'totalPrice': calculateTotalPrice(),
      };

      final Uri uri = Uri.parse(
        'https://script.google.com/macros/s/AKfycby3IHRu_zLkGKNyPBHCAdwyM5LGx7hiFhpjCx6JYd4xRw-XKl5mwxu8IUbvIxoidVrS/exec',
      );

      final response = await http.post(
        uri,
        body: json.encode(orderData),
        headers: {'Content-Type': 'application/json'},
      );

      print('Server Response: ${response.body}');

      if (response.statusCode == 200) {
        print('Order submitted successfully');
      } else {
        print('Failed to submit order. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error submitting order: $error');
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: TambahPesananPage(
        pesanan: Pesanan(),
      ),
    ),
  );
}
