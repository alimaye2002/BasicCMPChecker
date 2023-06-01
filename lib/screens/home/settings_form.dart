import 'package:flutter/material.dart';
import 'package:firstproject/Shared/constants.dart';
import 'package:yahoofin/yahoofin.dart';
import 'package:yahoofin/src/models/stock_meta.dart';
import 'package:yahoofin/src/models/stock_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final yfin = YahooFin();
  @override
  final _formKey = GlobalKey<FormState>();

  String? _currentName;
  int? _price;
  int? _quantity;
  int? _total;
  double? _currentPrice;

  void _updateTotal() {
    if (_price != null && _quantity != null) {
      _total = _price! * _quantity!;
    } else {
      _total = null;
    }
  }
  Future<void> _fetchStockData() async {
    String url = 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/$_currentName?modules=price';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      double currentPrice = jsonData['quoteSummary']['result'][0]['price']['regularMarketPrice']['raw'];
      setState(() {
        _currentPrice = currentPrice;
      });
    }
  }





  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Update',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputTextDecoration.copyWith(hintText: 'Name'),
            validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) {
              setState(() => _currentName = val);
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputTextDecoration.copyWith(hintText: 'Price'),
            validator: (val) => val!.isEmpty ? 'Enter Valid Price' : null,
            onChanged: (val) {
              setState(() {
                _price = int.tryParse(val ?? '');
                _updateTotal();
              });
            },
          ),
          TextFormField(
            decoration: InputTextDecoration.copyWith(hintText: 'Quantity'),
            validator: (val) => val!.isEmpty ? 'Enter Valid Quantity' : null,
            onChanged: (val) {
              setState(() {
                _quantity = int.tryParse(val ?? '');
                _updateTotal();
              });
            },
          ),
          Text('Total Amount: ${_total ?? ''}'),
          if (_currentPrice != null) Text('Current Price: $_currentPrice'),
          MaterialButton(
            color: Colors.pink,
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(_currentName);
              print(_price);
              print(_quantity);
            },
          ),
          MaterialButton(
            color: Colors.pink,
            child: Text(
              'Check CMP',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _fetchStockData();
            },
          ),
        ],
      ),
    );
  }
}
