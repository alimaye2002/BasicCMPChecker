import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {

  runApp(IndicesApp());
}
class IndiceData {
  double currentPrice;
  double currentIncrease;

  IndiceData(this.currentPrice, this.currentIncrease);
}

class IndicesApp extends StatelessWidget {
  final List<String> indices = [
    'Sensex','Dow Jones', 'NASDAQ', 'FTSE 100', 'DAX', 'Nikkei 225', 'Hang Seng'
  ];
  final List<String> symbols = [
    'BSESN', 'DJI', 'IXIC', 'FTSE', 'GDAXI', 'N225', 'HSI'
  ];
  Future<IndiceData> _fetchIndiceData(String c) async {
    String url = 'https://query1.finance.yahoo.com/v8/finance/chart/%5E$c?interval=1d&range=1d';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['chart']['result'][0]['meta']['regularMarketPrice'];
      double previousClose = jsonData['chart']['result'][0]['meta']['chartPreviousClose'];
      double currentIncrease = currentPrice - previousClose;
      return IndiceData(currentPrice,currentIncrease);
    }else {
      print('Request failed for $c with status: ${response.statusCode}.');

      return IndiceData(0,0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indices App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indices'),
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
          itemCount: indices.length,
          itemBuilder: (BuildContext context, int index) {
            final indexName = indices[index];
            final indexCode = symbols[index];
            return FutureBuilder<IndiceData>(
              future: _fetchIndiceData(indexCode),
              builder: (BuildContext context, AsyncSnapshot<IndiceData> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: const Icon(Icons.trending_up),
                    title:  Text(indexName),
                    trailing: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    leading: const Icon(Icons.error),
                    title: const Text('Error occurred'),
                    subtitle: Text(snapshot.error.toString()),
                  );
                } else {
                  double currentPrice = snapshot.data!.currentPrice ?? 0;
                  double currentIncrease = snapshot.data!.currentIncrease ?? 0;
                  return ListTile(
                    leading: snapshot.data!.currentIncrease >= 0
                        ? const Icon(Icons.trending_up, color: Colors.green)
                        : const Icon(Icons.trending_down, color: Colors.red),
                    title: Text(
                      indexName,
                      style: TextStyle(
                        color: snapshot.data!.currentIncrease >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      currentPrice.toStringAsFixed(2),
                      style: TextStyle(
                        color: snapshot.data!.currentIncrease >= 0 ? Colors.green : Colors.red,
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
      ),
    );
  }
}
