import 'package:flutter/material.dart';
import '../resources/user-provider.dart';
import 'package:flutter/services.dart';
import '../util.dart' as Util;
import '../pages/home.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class LoginData {
  String email = '';
  String password = '';
  String name = '';
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginData _loginData = LoginData();
  final _userProvider = UserProvider();

  _login(BuildContext context) async {
    // Navigator.pushReplacement(context, newRoute)

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Util.showLoading('Signing Up', context);
        Map<String, dynamic> profile = {
          "displayName": _loginData.name,
          "email": _loginData.email,

        };
        await this._userProvider.signup(_loginData.email, _loginData.password, profile);
        Navigator.pop(context);
        print('Signing up');
        Util.setCurrentScreen(context, HomePage());
        // Util.setCurrentScreen(context, TabsScreen());
      } on PlatformException catch (error) {
        Navigator.pop(context);
        Util.showAlert('Error', error.message, context);
      } on Exception catch (error) {
        Navigator.pop(context);
        Util.showAlert('Error', 'An unknown error has occurred', context);
      } finally {
        print('Finally!!!');
      }
    }
  }

  _showForm(BuildContext context) {
    return Form(
        child: Container(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),

                      labelText: "Name",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name is required';
                      }
                    },
                    onSaved: (value) {
                      _loginData.name = value;
                    },
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),

                      labelText: "Email",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Email is required';
                      }
                    },
                    onSaved: (value) {
                      _loginData.email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white
                      ),

                      labelText: "Password",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required';
                      }
                    },
                    onSaved: (value) {
                      _loginData.password = value;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  OutlineButton(
                    child: Text('Create Account', style: TextStyle(color: Colors.white)),
                    borderSide: BorderSide(
                        color: Colors.white
                    ),
                    highlightColor: Colors.white,
                    highlightedBorderColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _login(context);
                    },
                  ),
                  // Center(
                  //   child: FlatButton(
                  //     child: Text('Forgot Password'),
                  //     onPressed: () {},
                  //   ),
                  // )
                ],
              ),
            )

        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(child: Image.asset(
                    'assets/images/infinite_bg.jpg',
                    fit: BoxFit.cover
                ))
              ],
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/home_logo.png',
                      width: 100,
                    ),
                    // child: Image.asset(),
                  ),
                ),
                _showForm(context)
              ],
            ),
          ],
        )
    );
  }

}