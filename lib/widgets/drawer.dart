import 'package:flutter/material.dart';
import '../resources/user-provider.dart';
import '../util.dart' as Util;
import '../pages/login.dart';

class MenuDrawer extends StatelessWidget {
  _showUserInfo() {
    return Column(
      children: <Widget>[
        Text(
          'Melvin Musehani',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ],
    );
  }

  _showProfilePic() {
    return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/images/avatar.png')
              ),
              border: Border.all(
                  color: Colors.white,
                  width: 3
              )
          ),
        )
    );
  }

  _menuItemTapped(item, context) {
    switch (item) {
      case 'logout': {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you would like to logout?'),
              actions: <Widget>[
                FlatButton(onPressed: () {
                  Navigator.pop(context);
                  UserProvider().logout();
                  Util.setCurrentScreen(context, LoginPage());
                }, child: Text('Yes')),
                FlatButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('No'))
              ],
            );
          }
        );
      }
    }
    print(item + ' Clicked');
  }

  _createMenuTile(String title, IconData icon, String type, context) {
    return InkWell(
        onTap: () => _menuItemTapped(type, context),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
          ),
          child: ListView(
            children: <Widget>[
//              _showProfilePic(),
//              _showUserInfo(),
              Padding(
                padding: const EdgeInsets.all(20),
              ),
              _createMenuTile('Favourites', Icons.favorite, 'favourites', context),
              _createMenuTile('History', Icons.history, 'history', context),
              _createMenuTile('Payment', Icons.credit_card, 'payment', context),
              _createMenuTile('Settings', Icons.settings, 'settings', context),
//              _createMenuTile('About', Icons.help, 'about'),
              _createMenuTile('Logout', Icons.exit_to_app, 'logout', context)
            ],
          ),
        )
    );
  }
}