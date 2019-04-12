import 'package:firebase_database/firebase_database.dart';

class MenuProvider {
  final _database = FirebaseDatabase.instance;

  Future<Map<dynamic, dynamic>> menu() {
    return _database.reference().child('menus/woolworths').once().then((snapshot) {
      return snapshot.value;
    });
  }
}