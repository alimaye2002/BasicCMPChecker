import 'package:flutter/material.dart';
import 'package:firstproject/models/stock.dart';

class StockTile extends StatelessWidget {
//  const StockTile({Key? key}) : super(key: key);

    final Stock stock;
    StockTile({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown,

          ),
          title:Text(stock.Name) ,
          subtitle: Text(stock.Price.toString()),

        ),
      ),
    );
  }
}
