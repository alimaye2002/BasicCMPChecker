import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {

  runApp(IndicesApp());
}


class IndicesApp extends StatelessWidget {
  final List<String> indices = [
    'Sensex','Dow Jones', 'NASDAQ', 'FTSE 100', 'DAX', 'Nikkei 225', 'Hang Seng'
  ];
  final List<String> symbols = [
    'BSESN', 'DJI', 'IXIC', 'FTSE', 'GDAXI', 'N225', 'HSI'
  ];
  Future<double> _fetchIndiceData(String c) async {
    String url = 'https://query1.finance.yahoo.com/v8/finance/chart/%5E$c?interval=1d&range=1d';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['chart']['result'][0]['meta']['regularMarketPrice'];
      return currentPrice;
    }else {
      print('Request failed for $c with status: ${response.statusCode}.');

      return 0;
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
          title: const Text('Indices'),
        ),
       // backgroundColor: Colors.transparent,
        body: ListView.builder(
          itemCount: indices.length,
          itemBuilder: (BuildContext context, int index) {
            final indexName = indices[index];
            final indexCode = symbols[index];
            return FutureBuilder<double>(
              future: _fetchIndiceData(indexCode),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
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
                  double currentPrice = snapshot.data ?? 0;
                  return ListTile(
                    leading:const  Icon(Icons.trending_up),
                    title: Text(indexName),
                    subtitle: Text(currentPrice.toStringAsFixed(2)),
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
