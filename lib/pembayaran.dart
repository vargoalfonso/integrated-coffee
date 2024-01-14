import 'package:flutter/material.dart';
import 'package:flutter_application_3/list-kopi.dart';
import 'package:flutter_application_3/listkopitesting.dart';

class PembayaranPage extends StatefulWidget {
  final String qrCodeAssetPath;
  final TextEditingController paymentImageController;
  final VoidCallback onPaymentComplete;

  PembayaranPage({
    required this.qrCodeAssetPath,
    required this.paymentImageController,
    required this.onPaymentComplete,
  });

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  bool isPaymentSubmitted = false;
  bool isTextFieldFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPaymentSubmitted
                ? Column(
                    children: [
                      Image.asset('assets/images/QR.jpg',
                          height: 400, width: 400),
                      SizedBox(height: 20),
                      TextField(
                        controller: widget.paymentImageController,
                        onChanged: (value) {
                          setState(() {
                            // Check if the text field is filled
                            isTextFieldFilled = value.isNotEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Gambar Pembayaran (Asset Path)',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isTextFieldFilled
                            ? () {
                                // Handle the "Selesai" button press
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Pesanan Diterima'),
                                      content: Text(
                                          'Terima kasih! Pesanan Anda telah diterima.'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Trigger the onPaymentComplete callback
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CoffeeOrderScreen1()),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null, // Disable button if text field is not filled
                        style: ElevatedButton.styleFrom(
                          primary:
                              isTextFieldFilled ? Colors.blue : Colors.grey,
                        ),
                        child: Text('Selesai'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Handle the "Selanjutnya" button press
                      setState(() {
                        isPaymentSubmitted = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    child: Text('Klik me!'),
                  ),
          ],
        ),
      ),
    );
  }
}
