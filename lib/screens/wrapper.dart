import 'package:flutter/material.dart';
import 'package:firstproject/screens/home/home.dart';
import 'package:firstproject/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:firstproject/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   //return either home or authenticate
    final user = Provider.of<myUser?>(context);
   // print(user);
    if(user==null)
    return Authenticate();
    else return Home();
  }
}
