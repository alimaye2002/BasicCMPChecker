import 'package:flutter/material.dart' ;
import 'package:firstproject/services/auth.dart';
import 'package:firstproject/Shared/constants.dart';
import 'package:firstproject/Shared/loading.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function changeView;
  SignIn({required this.changeView});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth=AuthService();
  final _formkey=GlobalKey<FormState>();
  bool loading =false;
  String email=" ";
  String password= " ";
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to your Portfolio'),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label :Text('Register'),
            onPressed : (){
              widget.changeView();
            }

          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical :20.0, horizontal: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget> [
              SizedBox(height : 20.0),
              TextFormField(
                decoration: InputTextDecoration.copyWith(hintText:'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email': null,
                onChanged: (val){//username
                  setState(()=> email=val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputTextDecoration.copyWith(hintText:'Password'),
                obscureText: true,
                validator: (val)=>val!.length<6? 'Enter a valid(6+) password':null,
                onChanged: (val){//Password
                setState(()=> password=val);
                },
              ),
              SizedBox(height: 20.0),
               MaterialButton(
                color : Colors.pink[400],
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async { //async as this task takes time

                    if(_formkey.currentState!.validate()){
                      setState(() => loading= true);
                      dynamic result=await _auth.signinemailpass(email, password);
                      if(result==null){
                        setState((){
                          loading=false;
                            error= 'User not registered';
                        });
                      }

                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red,fontSize: 14),
              ),

            ],
          ),
        ),
      ),


    );

  }
}
