import 'package:flutter/material.dart';
import 'package:firstproject/services/auth.dart';
import 'package:firstproject/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstproject/screens/home/stock_list.dart';
import 'package:firstproject/models/stock.dart';
import 'package:firstproject/models/user.dart';
import 'package:firstproject/screens/home/settings_form.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);
  final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {

    void showSettings(){
      //will be used for buy sell later
      showModalBottomSheet(context: context, builder: (context){
        return  Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    final user = Provider.of<myUser?>(context);
    return StreamProvider<List<Stock>?>.value(
       // catchError: (_,__) => null,
        value :  DatabaseService(uid:user!.uid).stocks,

      initialData: null,

      child : Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Stock Crew'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon:Icon(Icons.person),
            label : Text('Log Out'),
            onPressed : () async {
                await _auth.signout();
            },
          ),
          TextButton.icon(
            icon:Icon(Icons.settings),
            label : Text('settings'),
            onPressed : ()  => showSettings(),
          ),
        ],
      ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Bgstock.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        child : StockList()),
          bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
               // 'Total Portfolio Value: \$${getTotalValue().toStringAsFixed(2)}',
                'Total Portfolio Value',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
    ),
    );
  }
}
