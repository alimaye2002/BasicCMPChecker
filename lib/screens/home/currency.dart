import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyScreen(),
    );
  }
}

class CurrencyScreen extends StatelessWidget {
  final List<String> currencies = [
    'USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'CHF', 'CNY', 'SEK', 'NZD'
  ];

  Future<double> _fetchCurrencyData(String c) async {
    String url = 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/${c}INR=X?modules=price';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['quoteSummary']['result'][0]['price']['regularMarketPrice']['raw'];
      return currentPrice;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (BuildContext context, int index) {
          final currency = currencies[index];

          return FutureBuilder<double>(
            future: _fetchCurrencyData(currency),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text(currency),
                  trailing: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Error occurred'),
                  subtitle: Text(snapshot.error.toString()),
                );
              } else {
                double currentPrice = snapshot.data ?? 0;
                return ListTile(
                  leading: Text('\u{20B9}',
                    style: TextStyle(fontSize: 25),
                  ),
                  title: Text(currency),
                  subtitle: Text(currentPrice.toString()),
                //  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    //This is kept for future scope
                    // Handle currency selection
                    // You can navigate to another screen or perform any other action here
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
