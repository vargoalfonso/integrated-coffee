import 'dart:convert';
import 'package:flutter_application_3/Pesanan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koffie App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ListKopiPage(),
        '/order': (context) => CoffeeOrderScreen(),
      },
    );
  }
}

class ListKopiPage extends StatefulWidget {
  @override
  _ListKopiPageState createState() => _ListKopiPageState();
}

class _ListKopiPageState extends State<ListKopiPage> {
  final Pesanan pesanan = Pesanan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kopi'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 20),
                const Text("KOFFIE"),
                SizedBox(height: 20),
                buildExpansionTile(
                  'Bloemen Latte',
                  'assets/images/Bloemen Latte.jpeg',
                  'Bloemen Latte',
                  'Perpaduan antara Susu dan Espresso',
                  '23.000',
                ),
                buildExpansionTile(
                  'Bloemen Koffie',
                  'assets/images/bloemenkoffie.JPG',
                  'Bloemen Koffie',
                  'Kopi susu dengan manis gula aren',
                  '23.000',
                ),
                // Tambahkan expansion tile lainnya sesuai kebutuhan
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahPesananPage(pesanan: pesanan),
                ),
              );
            },
            child: Text('Tambahkan ke Pesanan'),
          ),
        ],
      ),
    );
  }

  ExpansionTile buildExpansionTile(
    String title,
    String imagePath,
    String kopiNumber,
    String details,
    String price,
  ) {
    return ExpansionTile(
      leading: Image.asset(imagePath, width: 80, height: 80),
      title: Text(title),
      subtitle: Text('Detail for $title'),
      trailing: JumlahItemWidget(namaKopi: kopiNumber, pesanan: pesanan),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(details),
              SizedBox(height: 10),
              Text('Price: $price'),
            ],
          ),
        ),
      ],
    );
  }
}

class CoffeeOrderScreen extends StatefulWidget {
  @override
  _CoffeeOrderScreenState createState() => _CoffeeOrderScreenState();
}

class _CoffeeOrderScreenState extends State<CoffeeOrderScreen> {
  int coffeeCount = 0;
  bool isHot = true;
  bool isLessSugar = false;
  String selectedCoffee = 'Americano';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jumlah Kopi: $coffeeCount',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // ... (kode CoffeeOrderScreen tetap sama)
            ElevatedButton(
              onPressed: () async {
                await sendOrderToGoogleSheets();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pesanan Selesai'),
                      content:
                          Text('Terima kasih! Pesanan Anda telah selesai.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pesanan Selesai'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendOrderToGoogleSheets() async {
    final url =
        'https://script.google.com/macros/s/AKfycbwntAU9FhTJcA-gDzRAFJ4dD3qxZS8AQjK3QrCpy_LtGvO6BGg8KliOzzHDA1PM403m/exec'; // Gantilah dengan URL skrip Anda

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'coffeeType': selectedCoffee,
        'coffeeCount': coffeeCount,
        'isHot': isHot,
        'isLessSugar': isLessSugar,
      }),
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim ke Google Sheets');
    } else {
      print('Gagal mengirim data. Status code: ${response.statusCode}');
    }
  }
}

class TambahPesananPage extends StatelessWidget {
  final Pesanan pesanan;

  TambahPesananPage({required this.pesanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pesanan'),
      ),
      body: Center(
        child: Text('Halaman Tambah Pesanan'),
      ),
    );
  }
}

class JumlahItemWidget extends StatefulWidget {
  final String namaKopi;
  final Pesanan pesanan;

  JumlahItemWidget({required this.namaKopi, required this.pesanan});

  @override
  _JumlahItemWidgetState createState() => _JumlahItemWidgetState();
}

class _JumlahItemWidgetState extends State<JumlahItemWidget> {
  int jumlah = 0;
  String selectedIce = 'Ice';
  String selectedSugarLevel = 'Less Sugar';

  void _showOptionsBottomSheet() {
    // ... (kode _showOptionsBottomSheet tetap sama)
  }

  void _addToCart({required String ice, required String sugarLevel}) async {
    // ... (kode _addToCart tetap sama)
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (jumlah > 0) {
                jumlah--;
                widget.pesanan.kurangiItem(widget.namaKopi, 1);
              }
            });
          },
        ),
        Text(jumlah.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              jumlah++;
              _showOptionsBottomSheet();
            });
          },
        ),
      ],
    );
  }
}
