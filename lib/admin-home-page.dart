import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url =
        'https://script.google.com/macros/s/AKfycbw-turg-dyAGF6mMgv0btL2REp0gaw1wWvyQDgy45oAjQd--aAmBP-4qcdut7Bt2uk7/exec';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> newDataList = [];

        for (var item in jsonResponse) {
          // Assuming the structure of your data, adjust the keys accordingly
          Map<String, dynamic> data = {
            'timestamp': item['Timestamp'],
            'coffeeType': item['CoffeeType'],
            'coffeeCount': item['CoffeeCount'],
            // Add other fields as needed
          };

          newDataList.add(data);
        }

        setState(() {
          dataList = newDataList;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Timestamp: ${dataList[index]['timestamp']}'),
            subtitle: Text('Coffee Type: ${dataList[index]['coffeeType']}'),
            // Add other fields as needed
          );
        },
      ),
    );
  }
}
