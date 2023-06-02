import 'package:firstproject/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firstproject/models/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firstproject/screens/home/stock_list.dart';
import 'package:provider/provider.dart';
import 'package:firstproject/models/user.dart';
class StockTile extends StatefulWidget {
  final Stock stock;

  StockTile({required this.stock});

  @override
  _StockTileState createState() => _StockTileState();
}


class _StockTileState extends State<StockTile> {

  double _currentPrice=0.0;

  Future<void> _fetchStockData() async {
    String url = 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/${widget.stock.Name}?modules=price';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['quoteSummary']['result'][0]['price']['regularMarketPrice']['raw'];
      setState(() {
        _currentPrice = currentPrice;
      });
    }
  }

  void initState() {
    super.initState();
    _fetchStockData();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid:user!.uid).userData,
    builder: (context,snapshot){



    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),

        child: ListTile(
          title: Text(widget.stock.Name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _currentPrice == 0.0
                  ? Text('Loading...'):
              Text('CMP: ${_currentPrice}'),
              Text('Quantity: ${widget.stock.Quantity}'),
              Text('Price: ${widget.stock.Price}'),
              _currentPrice == 0.0
                  ? Text('Loading...'):
             Text('Unrealized Profit: ${(widget.stock.Quantity*(_currentPrice-widget.stock.Price)).toStringAsFixed(2)}'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.sell),
            onPressed: () async{
              await DatabaseService(uid: user.uid).deleteStock(
                widget.stock.Name ?? 'AAPL',
                widget.stock.Price ?? 1,
                widget.stock.Quantity ?? 1,
              );

              // sellStock(stock.symbol);
            },
          ),
        ),
      ),
    );
    }
    );
  }
}
