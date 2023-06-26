import 'package:flutter/material.dart';
import 'package:firstproject/Shared/constants.dart';

import 'package:firstproject/models/user.dart';
import 'package:firstproject/services/database.dart';
import 'package:provider/provider.dart';
import 'package:firstproject/Shared/loading.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {

  @override
  final _formKey = GlobalKey<FormState>();

  String? _currentName;
  double? _price;
  int? _quantity;
  double? _total;
  double? _currentPrice;

  void _updateTotal() {
    if (_price != null && _quantity != null) {
      _total = _price! * _quantity!;
    } else {
      _total = null;
    }
  }
  void _showAddPanel() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Text('bottom sheet'),
      );
    });
  }



  Widget build(BuildContext context) {

    final user = Provider.of<myUser?>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid:user!.uid).userData,
    builder: (context,snapshot){
        //this snapshot has nothing to do with firebase it is kinda flutter implementation
    if(snapshot.hasData){
      UserData userData=snapshot!.data!;
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Add',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextFormField(
           //   initialValue: userData.Name,
              decoration: InputTextDecoration.copyWith(hintText: 'Name'),
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
              onChanged: (val) {
                setState(() => _currentName = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
          //    initialValue: userData.Price.toString(),
              decoration: InputTextDecoration.copyWith(hintText: 'Price'),
              validator: (val) => val!.isEmpty ? 'Enter Valid Price' : null,
              onChanged: (val) {
                setState(() {
                  _price = double.tryParse(val ?? '');
                  _updateTotal();
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
            //  initialValue: userData.Quantity.toString(),
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
           //     print('Update has been pressed');
             if(_formKey.currentState?.validate() ?? false){
             //  print('I am at addstock of add_form.dart');
               await DatabaseService(uid: user.uid).addStock(
                  _currentName ?? 'AAPL',
                 _price ?? 1.0,
                 _quantity ?? 1,
               );
             //  print('I am at addstock of add_form.dart');
               Navigator.pop(context);
             }
           //  print('addstock of add_form.dart didnt reach');
              },
            ),

          ],
        ),
      );
    }else {
      return Loading();//added to avoid null return
    }

  }
  );
}
  }

