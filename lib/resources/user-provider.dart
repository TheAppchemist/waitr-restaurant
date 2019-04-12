import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<FirebaseUser> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> signup(String email, String password, Map<String, dynamic> extra) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    if (extra != null) {
      extra['uid'] = user.uid;
      await _firestore.document('users/${user.uid}').setData(extra);
    }

    return user;
  }

  Future<FirebaseUser> signedIn() async {
    return await _auth.currentUser();
  }

  Stream<FirebaseUser> authChanged() {
    return _auth.onAuthStateChanged;
  }

  logout() {
    return _auth.signOut();
  }

}


