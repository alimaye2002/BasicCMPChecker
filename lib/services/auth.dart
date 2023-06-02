import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/models/user.dart';
import 'package:firstproject/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;// final so value wont
//change and underscore for private value


  //create custom user object
  myUser? _userFromFirebaseUser(User? user){
    return user!=null ? myUser(uid: user.uid) : null!;

  }
//auth change userstream

  Stream<myUser?> get user {
    return _auth.authStateChanges()
      //  .map((UserCredential user)=> _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future anonsignin () async{
    try{
      //'AuthResult' has been renamed to 'UserCredential'
      // and 'FirebaseUser' is renamed to 'User'.
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;//! to remove nullabe error

      return _userFromFirebaseUser(user);
    } catch(e){
    print(e.toString());
    return null;
    }
  }
  //email & pwd sign
  Future signinemailpass (String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user=result.user!;


      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  //user register

  Future registeremailpass (String email, String password) async{
    try{
       UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       User user=result.user!;
       //Create a new doc for user with uid
       //await DatabaseService(uid : user.uid).updateUserData('New Stock',1,1);
       await DatabaseService(uid: user.uid).addFirstStock('New Stock', 1, 1);
       return _userFromFirebaseUser(user);
    }catch(e){
        print(e.toString());
        return null;
    }
  }


  //sign out
Future signout() async{
    try{
      return await _auth.signOut();
    }catch(e){
    print(e.toString());
    return null;
  }
}
}