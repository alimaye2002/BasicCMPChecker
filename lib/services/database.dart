import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstproject/models/stock.dart';
import 'package:firstproject/models/user.dart';

class DatabaseService{

   final String uid;

   DatabaseService({this.uid=''});
  //Collection Reference
  final CollectionReference stockCollection = FirebaseFirestore.instance.collection('stocks');

  // Future updateUserData (String name, int price, int quantity ) async {
  //   return await stockCollection.doc(uid).set({
  //      'Name' : name,
  //     'Price' : price,
  //     'Quantity' : quantity,
  //   });
  // }

  //for list of stocks per user

   Future<void> addFirstStock(String name, double price, int quantity) async {
     final stockData = Stock(Name: name, Price: price, Quantity: quantity);
     await stockCollection.doc(uid).set({
       'uid': uid,
       'S': [
         {
           'Name': stockData.Name,
           'Price': stockData.Price,
           'Quantity': stockData.Quantity,
         },
       ],
     });
   }

   Future<void> addStock(String name, double price, int quantity) async {
     final stockData = Stock(Name: name, Price: price, Quantity: quantity);

     // Retrieve the current stock list
     final snapshot = await stockCollection.doc(uid).get() as DocumentSnapshot<Map<String, dynamic>>;
     final List<Map<String, dynamic>>? currentStocks = (snapshot.data()?['S'] as List<dynamic>).cast<Map<String, dynamic>>();

     // Check if the stock with the given name already exists in the list
     final existingStockIndex = currentStocks?.indexWhere((stock) => stock['Name'] == stockData.Name);

     if (existingStockIndex != null && existingStockIndex >= 0) {
       // Stock already exists, update the quantity and adjust the price

       final existingStock = currentStocks![existingStockIndex];
       final int existingQuantity = existingStock['Quantity'];
       final int updatedQuantity = existingQuantity + stockData.Quantity;
       final double existingPrice = existingStock['Price'];
       final double updatedPrice = (existingPrice * existingQuantity + stockData.Price * stockData.Quantity) / updatedQuantity;




       // Update the existing stock with the adjusted quantity and price
       currentStocks[existingStockIndex]['Quantity'] = updatedQuantity;
       currentStocks[existingStockIndex]['Price'] = updatedPrice;
     } else {
       // Stock does not exist, add it to the list
       currentStocks?.add({
         'Name': stockData.Name,
         'Price': stockData.Price,
         'Quantity': stockData.Quantity,
       });
     }

     // Update the document in Firestore with the updated stock list
     await stockCollection.doc(uid).set({
       'uid': uid,
       'S': currentStocks,
     });
   }


   //function to delete a stock

   Future<void> deleteStock(String name, double price, int quantity) async {
     final stockData = {
       'Name': name,
       'Price': price,
       'Quantity': quantity,
     };

     await stockCollection.doc(uid).update({
       'S': FieldValue.arrayRemove([stockData]),
     });
   }



   //stockList from a snapshot

   // List<Stock> _stockListFromSnapshot(QuerySnapshot snapshot){
   //  return snapshot.docs.map((doc){
   //
   //    return Stock(
   //      Name: doc.get('Name')?? '',
   //      Price: doc.get('Price') ?? 0,
   //      Quantity: doc.get('Quantity') ?? 0,
   //    );
   //  }).toList();
   // }
   // List<Stock> _stockListFromSnapshot(DocumentSnapshot snapshot){
   //  // return snapshot.docs.map((doc){
   //
   //   final stock =  Stock(
   //       Name: snapshot.get('Name')?? '',
   //       Price: snapshot.get('Price') ?? 0,
   //       Quantity: snapshot.get('Quantity') ?? 0,
   //     );
   //   return [stock];
   //  // }).toList();
   // }

   List<Stock> _stockListFromSnapshot(DocumentSnapshot snapshot) {
     final userData = UserData.fromSnapshot(snapshot);

     return userData.S;
   }


   //user data from snapshot
// UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
//     return UserData(uid: uid,
//         Name: snapshot.get('Name'),
//         Price: snapshot.get('Price'),
//         Quantity: snapshot.get('Quantity'),
//     );
// }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
 //   final data = snapshot.data();
    final uid = snapshot.get('uid');
    final stocksData = List<Map<String, dynamic>>.from(snapshot.get('S'));

    final stocks = stocksData.map((stockData) {
      return Stock(
        Name: stockData['Name'] ?? '',
        Price: stockData['Price'] ?? 0,
        Quantity: stockData['Quantity'] ?? 0,
      );
    }).toList();

    return UserData(uid: uid, S: stocks);
  }


  //get stock stream

  Stream<List<Stock>> get stocks{
    return stockCollection.doc(uid).snapshots()
    .map(_stockListFromSnapshot);
  }

  //get user doc stream

Stream<UserData> get userData{
    return stockCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
}

}