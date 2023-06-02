import 'package:firstproject/models/stock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class myUser {
  final String uid;

  myUser({required this.uid}); //added required for null issuesss
}
  class UserData{

    final String uid;
    // final String Name;
    // final int Price;
    // final int Quantity;

    final List<Stock> S;
 //   UserData({required this.uid,required this.Name,required this.Price,required this.Quantity});
  UserData({required this.uid, required this.S});


    static UserData fromSnapshot(DocumentSnapshot snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'];
      final stocksData = List<Map<String, dynamic>>.from(data['S']);

      final stocks = stocksData.map((stockData) {
        return Stock(
          Name: stockData['Name'] ?? '',
          Price: stockData['Price'] ?? 0,
          Quantity: stockData['Quantity'] ?? 0,
        );
      }).toList();

      return UserData(uid: uid, S: stocks);
    }
  }
