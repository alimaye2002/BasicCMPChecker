import 'package:flutter/material.dart';
import 'package:firstproject/screens/authenticate/sign_in.dart';
import 'package:firstproject/screens/authenticate/register.dart';
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

bool signin=true;

void changeView(){
  setState(() => signin=!signin);
}

  @override
  Widget build(BuildContext context) {
   if(signin){
     return SignIn(changeView:changeView);
   }else return Register(changeView:changeView);
  }
}
