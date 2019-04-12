import 'package:flutter/material.dart';
import '../util.dart' as Util;
import './meal-info.dart';
import '../widgets/cart-action.dart';

class MenuPage extends StatefulWidget {
  final id;
  final menu;

  MenuPage(this.id, this.menu);

  @override
  State<StatefulWidget> createState() {
    return MenuPageState();
  }
}

class MenuPageState extends State<MenuPage> {
  String _id;
  Map<dynamic, dynamic> _menu;

  _buildMenuList() {
    return (_menu['items'] as Map<dynamic, dynamic>).keys.toList().map((key) {
      print(key);
      return Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20
        ),
        child: GestureDetector(
          onTap: () {
            Util.goToScreen(context, MealInfo(
              meal: _menu['items'][key],
            ));
          },
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _menu['items'][key]['name'],
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                  ),
                  Text(
                      'R${_menu['items'][key]['price']}'
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
              ),
              Text(
                _menu['items'][key]['desc'],
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ],
          ),
        )
      );
    }).toList();
  }

  _buildHeader() {
    return [
    Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Image.asset(
              'assets/images/$_id.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              color: Color(0xFF000000).withOpacity(0.3),
              colorBlendMode: BlendMode.darken
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Your selections below',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ),
        ],
      ),
    )
    ];
  }

  List<Widget> _build() {
    List<Widget> array = [_buildHeader(), _buildMenuList(), [Padding(padding: const EdgeInsets.all(10))]].expand<Widget>((x) => x).toList();

    return array;
  }

  @override
  Widget build(BuildContext context) {
    if (_id == null) {
      _id = widget.id;
    }

    if (_menu == null) {
      _menu = widget.menu;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_menu['name']),
        actions: <Widget>[
          CartActionWidget()
        ],
      ),
      body: ListView(
        children: _build(),
      ),
    );
  }
}