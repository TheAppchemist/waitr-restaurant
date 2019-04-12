import 'package:flutter/material.dart';
import '../bloc/menu-bloc.dart';
import '../util.dart' as Util;
import './menu.dart';
import '../widgets/drawer.dart';
import '../widgets/cart-action.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  double _screenWidth;
  Map<dynamic, dynamic> _menu;

  @override
  initState() {
    super.initState();

    menuBloc.fetchMenu();
    // menuBloc.fetchCart();
  }

  _buildBlock(String title, String image, String key) {

    return GestureDetector(
      onTap: () {
        Util.goToScreen(context, MenuPage(key, _menu[key]));
      },
      child: GridTile(
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/$image',
                height: _screenWidth / 2,
                width: _screenWidth / 2,
                fit: BoxFit.cover,
                color: Color(0xFF000000).withOpacity(0.5),
                colorBlendMode: BlendMode.darken,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Wait.r'),
        actions: <Widget>[
          CartActionWidget()
        ],
      ),
      body: StreamBuilder(
        stream: menuBloc.menu,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _menu = snapshot.data;
            final keys = _menu.keys.toList();
            keys.sort((a, b) {
              return a.toString().compareTo(b.toString());
            });

            return GridView(
              children: keys.map<Widget>((key) {
                return _buildBlock(_menu[key]['name'], '$key.jpg', key);
              }).toList(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          }
        },
      )
    );
  }
}