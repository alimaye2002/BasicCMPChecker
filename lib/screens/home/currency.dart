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
class CurrencyData {
  double currentPrice;
  double currentIncrease;

  CurrencyData(this.currentPrice, this.currentIncrease);
}

class CurrencyScreen extends StatelessWidget {
  final List<String> currencies = [
    'USD', 'EUR', 'JPY', 'GBP', 'AUD', 'CAD', 'CHF', 'CNY', 'SEK', 'NZD'
  ];

  Future<CurrencyData> _fetchCurrencyData(String c) async {
    String url = 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/${c}INR=X?modules=price';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['quoteSummary']['result'][0]['price']['regularMarketPrice']['raw'];
      double currentIncrease = jsonData['quoteSummary']['result'][0]['price']['regularMarketChange']['raw'];
      return CurrencyData(currentPrice,currentIncrease);
    }
    return CurrencyData(0,0);
  }

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
      appBar: AppBar(
        title: Text('Currency'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 20),
            child: Text(
              'Change',
              style: TextStyle(
                fontSize: 20,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
     // backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: currencies.length,
        itemBuilder: (BuildContext context, int index) {
          final currency = currencies[index];

          return FutureBuilder<CurrencyData>(
            future: _fetchCurrencyData(currency),
            builder: (BuildContext context, AsyncSnapshot<CurrencyData> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                 leading: Text('\u{20B9}',
                    style: TextStyle(fontSize: 25),
                  ),
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
                double currentPrice = snapshot.data!.currentPrice ?? 0;
                double currentIncrease = snapshot.data!.currentIncrease ?? 0;
                return ListTile(
                  leading: Text('\u{20B9}',
                    style: TextStyle(fontSize: 25),
                  ),
              title: Text(
              currency,
              style: TextStyle(
              color: snapshot.data!.currentIncrease >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              ),
              subtitle: Text(
              currentPrice.toStringAsFixed(2),
              style: TextStyle(
              color: snapshot.data!.currentIncrease >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              ),
              trailing: Container(
                color: snapshot.data!.currentIncrease >= 0 ? Colors.green : Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  currentIncrease.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white),
              ),
              ),
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
