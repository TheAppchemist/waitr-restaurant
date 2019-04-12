import 'package:flutter/material.dart';
import '../bloc/menu-bloc.dart';
import '../util.dart' as Util;
import '../resources/repository.dart';
import 'package:flutter/services.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartPageState();
  }
}

class CartPageState extends State<CartPage> {
  double _total = 0;
  double _tip = 0;
  bool _initialTipCalculate = true;

  @override
  void initState() {
    super.initState();

    menuBloc.fetchCart();
  }

  _scanBarcode() async {

  }

  _pay() async {
    try {
      Future<String> barcode = new QRCodeReader()
          .setAutoFocusIntervalInMs(200) // default 5000
          .setForceAutoFocus(true) // default false
          .setTorchEnabled(true) // default false
          .setHandlePermissions(true) // default true
          .setExecuteAfterPermissionGranted(true) // default true
          .scan();
//      String barcode = await BarcodeScanner.scan();
      print('Barcode Found');
      print(barcode);
    } on PlatformException catch (e) {
      print('Could not scan barcode');
      print(e.toString());
    }

    Util.showLoading('Processing Payment', context);

    await Repository().orderProvider.clearCart();
    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank You'),
            content: Text('Your order is on its way'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  _calculateTotals(meals) {
    double total = 0;
    meals.forEach((meal) {
      total += (double.parse(meal['meal']['price']) * meal['qty']);
    });

    this._total = total;

    if (this._initialTipCalculate) {
      this._tip = this._total * 0.1;
      this._initialTipCalculate = false;
    }
  }

  _changeTip() {
    final controller = TextEditingController();
    String currentValue = '${this._tip.toStringAsFixed(2)}';
    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Tip'),
          content: TextField(
            controller: controller,
            onChanged: (value) {
              currentValue = value;
            },
            decoration: InputDecoration(
              labelText: 'Tip',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              setState(() {
                this._tip = double.parse(currentValue);
              });
              print(currentValue);
              Navigator.of(context).pop();
            }, child: Text('Change Tip')),
            FlatButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Nevermind'))
          ],
        );
      }
    );
  }

  _buildTip() {
    return ListTile(
      title: Text('Tip (Tap to change)'),
      trailing: Text('R${this._tip.toStringAsFixed(2)}'),
      onTap: () => _changeTip()
    );
  }

  _buildTotals() {
    return Column(
      children: <Widget>[
        Divider(),
        _buildSubtotal(),
        _buildTip(),
        _buildTotal()
      ],
    );
  }

  _buildSubtotal() {
    return ListTile(
        title: Text(
          'Subtotal',
          style: TextStyle(
              fontWeight: FontWeight.normal
          ),
        ),
        trailing: Text(
          'R${this._total.toStringAsFixed(2)}',
          style: TextStyle(
              fontWeight: FontWeight.normal
          ),
        )
    );
  }

  _buildTotal() {
    return ListTile(
        title: Text(
          'Total',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        trailing: Text(
          'R${(this._total + this._tip).toStringAsFixed(2)}',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: menuBloc.cart,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    _calculateTotals(data);
                    print('Length: ${data.length}');
                    print('Got data for cart');

                    if (data.length == 0) {
                      return Center(
                        child: Text(
                          "You currently don't have anything in your cart",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: data.length + 2,
                      itemBuilder: (context, index) {
                        print('Index is: $index');

                        if (index < data.length) {
                          final meal = data[index]['meal'];
                          return ListTile(
                            title: Text("${data[index]['qty']} x ${meal['name']}"),
                            trailing: Text('R${(double.parse(meal['price']) * data[index]['qty']).toStringAsFixed(2)}'),
                          );
                        } else if (index == data.length) {
                          return _buildTotals();
                        }else {
                          return FlatButton(
                              onPressed: () => _pay(),
                              color: Colors.pink,
                              child: Text(
                                'Pay',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                          );
                        }

                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            ),
          ],
        ),
      ),
    );
  }
}