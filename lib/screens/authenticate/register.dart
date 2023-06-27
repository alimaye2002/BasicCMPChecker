import 'package:flutter/material.dart';
import 'package:firstproject/services/auth.dart';
import 'package:firstproject/Shared/constants.dart';
import 'package:firstproject/Shared/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Register extends StatefulWidget {
  //const Register({Key? key}) : super(key: key);
  final Function changeView;
  Register({required this.changeView});
  @override
  State<Register> createState() => _RegisterState();
}

class Article {
  final String title;
  final String description;

  Article({
    required this.title,
    required this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] != null ? json['title'] as String : '',
      description: json['description'] != null ? json['description'] as String : '',
    );
  }

}

class _RegisterState extends State<Register> {
  List<Article> articles = [];



 String myapikey='3e4023c8f7814a5fa278836833fe2eae';
  Future<void> fetchStockMarketNews() async {
    final url =
    Uri.parse('https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$myapikey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articlesData = jsonData['articles'];

      setState(() {
        // Convert the JSON data to a list of articles
        print('stcks there');
        articles = articlesData.map<Article>((articleJson) => Article.fromJson(articleJson)).toList();
      });
    } else {
      print('Failed to fetch stock market news: ${response.statusCode}');
    }
  }

  final AuthService _auth=AuthService();
  final _formkey=GlobalKey<FormState>();
bool loading=false;
  String email=" ";
  String password= " ";
  String error='';

  @override

  void initState() {
    super.initState();
    fetchStockMarketNews();
  }
  Widget build(BuildContext context) {
    return loading ? Loading():  Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register to your Portfolio'),
        actions: <Widget>[
          ElevatedButton.icon(
              icon: Icon(Icons.person),
              label :Text('Sign In'),
              onPressed : (){
                  widget.changeView();
              }

          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical :20.0, horizontal: 50.0),
    child: Column(
        children: [
          Form(
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
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async { //async as this task takes time
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        loading=true;
                      });
                        dynamic result=await _auth.registeremailpass(email, password);
                        if(result==null){
                          setState(() {
                            loading=false;
                            error= 'Please supply valid data';
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
        Expanded(
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ListTile(
                title: Text(
                  article.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Times',
                  ),
                ),
                subtitle: Text(
                  article.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Times',
                  ),
                ),
              );
            },
          ),
        ),

        ],
    ),

      )
    );
  }
}
