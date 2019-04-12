import 'package:flutter/material.dart';
import '../resources/user-provider.dart';
import '../util.dart' as Util;
import './home.dart';
import './login.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoadingScreenState();
  }
}

class LoadingScreenState extends State<StatefulWidget> {
  UserProvider _userProvider = UserProvider();

  @override
  initState() {
    super.initState();


  }

  LoadingScreenState(): super() {
    _userProvider.signedIn().then((user) {
      if (user == null) {
        Util.setCurrentScreen(context, LoginPage());
      } else {
        Util.setCurrentScreen(context, HomePage());
      }
    }).catchError((error) {
      Util.setCurrentScreen(context, LoginPage());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}