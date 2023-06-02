import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/screens/home/StockIndices.dart';
import 'package:flutter/material.dart';
import 'package:firstproject/services/auth.dart';
import 'package:firstproject/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstproject/screens/home/stock_list.dart';
import 'package:firstproject/models/stock.dart';
import 'package:firstproject/models/user.dart';
import 'package:firstproject/screens/home/settings_form.dart';
import 'package:firstproject/screens/home/currency.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<myUser?>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stock Portfolio'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Log Out'),
              onPressed: () async {
                await _auth.signout();
              },
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
          child: TabBarView(
            children: [
              CurrencyApp(),
              StreamProvider<UserData?>.value(
                value: DatabaseService(uid: user!.uid).userData,
                initialData: null,
                child: Scaffold(
                  backgroundColor: Colors.transparent,

  //                body: Column(
//                    children : [
                  body :   StockList(),
    //                  ElevatedButton(
      //                  child: Text('Add'),
        //                onPressed: () {
                          // Implement your "Add" functionality here
                //        },
              //        ),
            //        ],
           //       ),
           //        bottomNavigationBar: BottomAppBar(
           //          child: Padding(
           //            padding: const EdgeInsets.all(16.0),
           //            child: Text(
           //              'Total Portfolio Value',
           //              style: TextStyle(fontSize: 18),
           //            ),
           //          ),
           //        ),
                ),
              ),

              IndicesApp(),
              // Add more tabs/widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}
