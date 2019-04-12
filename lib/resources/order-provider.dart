import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class OrderProvider {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  Future addToOrder(meal, count, requirements) async {
    final user = await _auth.currentUser();
    print(user);

    if (user != null) {
      final snapshot = await _firestore.collection('cart').where('uid', isEqualTo: user.uid).getDocuments();
      DocumentReference cartRef;

      if (snapshot.documents.isEmpty) {
        cartRef = await _firestore.collection('cart').add({
          'uid': user.uid
        });
      } else {
        cartRef = snapshot.documents[0].reference;
      }
      await cartRef.collection('items').add({
        'meal': meal,
        'qty': count,
        'requirement': requirements
      });
      print('Order added');
    } else {
      print('User is not logged in');
    }
  }

  Stream<List<Map<String, dynamic>>> cart() {
    return Observable.fromFuture(_auth.currentUser())
      .flatMap((FirebaseUser user) {
        print('🤪 Got User');
        return Observable(_firestore.collection('cart').where('uid', isEqualTo: user.uid).snapshots());
      })
      .flatMap((QuerySnapshot snapshots) {
        print ('🤬 Got Cart');
        print(snapshots);
        if (snapshots.documents.length > 0) {
          return snapshots.documents[0].reference.collection('items').snapshots();
        } else {
          print('Gonna return null 🤪');
          return Observable.just(null);
        }
      })
      .map((QuerySnapshot snapshots) {
        if (snapshots != null) {
          print('😀 Got Cart Items');
          return snapshots.documents.map((snapshot) {
            return snapshot.data;
          }).toList();
        } else {
          print('🤬 No Cart Items');
          return [];
        }
      });
  }

  clearCart() async {
    final user = await _auth.currentUser();
    final cart = await _firestore.collection('cart').where('uid', isEqualTo: user.uid).snapshots().first;

    if (cart.documents.length > 0) {
      await cart.documents[0].reference.delete();
    } else {
      print('No cart to clear');
    }
  }
}