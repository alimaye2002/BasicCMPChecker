import 'package:firstproject/screens/home/add_form.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firstproject/models/stock.dart';
import 'package:firstproject/screens/home/stock_tile.dart';
import 'package:firstproject/models/user.dart';
class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  void _showAddPanel() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: AddForm(),
      );
    });
  }
  Widget build(BuildContext context) {

    //final stocks=Provider.of<List<Stock>?>(context) ?? [];
    final userData = Provider.of<UserData?>(context);
    //final user = Provider.of<myUser?>(context);
final stocks = userData?.S;
//print(userData);
    //print(stocks.docs);
    // if (stocks?.docs != null) {
    //   for (var doc in stocks!.docs) {
    //     print(doc.data());
    //   }
    // }
    // stocks?.forEach((stock) {
    //     print(stock.Name);
    //     print(stock.Price);
    //     print(stock.Quantity);
    // });

    return Column(
      children: [
        Expanded(
      child : ListView.builder(
      itemCount: stocks?.length ?? 0,
      itemBuilder: (context, index) {
        final stock = stocks?[index];
        if (stock != null) {
          return StockTile(stock: stock);
        } else {
          return Container(); // Placeholder widget when stock is null
        }
      },
    ),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            // Implement your "Add" functionality here
            _showAddPanel();
            //print("add button clicked");
          },
        ),
      ],
    );

  }
}
