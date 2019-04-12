import 'package:flutter/material.dart';
import '../resources/user-provider.dart';
import 'package:flutter/services.dart';
import '../util.dart' as Util;
import './signup.dart';
import './home.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginData {
  String email = '';
  String password = '';
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginData _loginData = LoginData();
  final _userProvider = UserProvider();

  _login(BuildContext context) async {
    // Navigator.pushReplacement(context, newRoute)

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Util.showLoading('Logging In', context);
        await this._userProvider.login(_loginData.email, _loginData.password);

        print('Logged in');
        Navigator.pop(context);
        Navigator.pop(context);
         Util.setCurrentScreen(context, HomePage());
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
                    style: TextStyle(
                      color: Colors.white,
                    ),

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
                    child: Text('Sign In', style: TextStyle(color: Colors.white)),
                    borderSide: BorderSide(
                      color: Colors.white
                    ),
                    onPressed: () {
                      _login(context);
                    },
                    highlightColor: Colors.white,
                    highlightedBorderColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                  Center(
                    child: FlatButton(
                      child: Text('Create Account', style: TextStyle(color: Colors.white)),

                      onPressed: () {
                        Util.goToScreen(context, SignUpPage());
                      },
                    ),
                  )
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