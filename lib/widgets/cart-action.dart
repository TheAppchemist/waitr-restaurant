import 'package:flutter/material.dart';
import '../bloc/menu-bloc.dart';
import 'package:badges/badges.dart';
import '../util.dart' as Util;
import '../pages/cart.dart';

class CartActionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartActionWidgetState();
  }
}

class CartActionWidgetState extends State<CartActionWidget> {
  @override
  void initState() {
    super.initState();

    menuBloc.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: menuBloc.cart,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          return BadgeIconButton(
            itemCount: snapshot.data.length,
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            badgeColor: Colors.red,
            badgeTextColor: Colors.white,
            hideZeroCount: true,
            onPressed: () {
              print('Going to cart');
              Util.goToScreen(context, CartPage());
            },
          );
        } else {
          return IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
//              menuBloc.fetchCart();
            print('Going to cart');
            Util.goToScreen(context, CartPage());
            },
          );
        }
      },
    );
  }
}