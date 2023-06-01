import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstproject/models/stock.dart';
import 'package:firstproject/models/user.dart';

class DatabaseService{

   final String uid;

   DatabaseService({this.uid=''});
  //Collection Reference
  final CollectionReference stockCollection = FirebaseFirestore.instance.collection('stocks');

  Future updateUserData (String name, int price, int quantity ) async {
    return await stockCollection.doc(uid).set({
       'Name' : name,
      'Price' : price,
      'Quantity' : quantity,
    });
  }

  //stockList from a snapshot

   List<Stock> _stockListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){

      return Stock(
        Name: doc.get('Name')?? '',
        Price: doc.get('Price') ?? 0,
        Quantity: doc.get('Quantity') ?? 0,
      );
    }).toList();
   }

   //user data from snapshot
UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(uid: uid,
        Name: snapshot.get('Name'),
        Price: snapshot.get('Price'),
        Quantity: snapshot.get('Quantity'),
    );
}

  //get stock stream

  Stream<List<Stock>> get stocks{
    return stockCollection.snapshots()
    .map(_stockListFromSnapshot);
  }

  //get user doc stream

Stream<UserData> get userData{
    return stockCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
}

}