import 'package:flutter/material.dart';
import 'package:firstproject/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'package:firstproject/models/user.dart';
/*
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 */
// void main() async{
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
Future <void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();


    return StreamProvider<myUser?>.value(

      value: AuthService().user,
      catchError:(_,__)=>null,
      initialData: null,
      child : MaterialApp(
      home: Wrapper(),

    ),
    );
  }
}

