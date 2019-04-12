import 'package:flutter/material.dart';
import '../resources/order-provider.dart';
import '../util.dart' as Util;

class MenuInfoData {
  int count = 1;
  String requirements = '';
}

class MealInfo extends StatefulWidget {
  final Map<dynamic, dynamic> meal;

  MealInfo({this.meal});

  @override
  State<StatefulWidget> createState() {
    return MealInfoState();
  }
}

class MealInfoState extends State<MealInfo> {
  Map<dynamic, dynamic> _meal;
  final _data = MenuInfoData();
  final _formKey = GlobalKey<FormState>();
  final _orderProvider = OrderProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _buildMenuInfo() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                _meal['name'],
                style: TextStyle(
                    fontSize: 30
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
            ),
            Text(
                'R${_meal['price']}'
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
        ),
        Text(
          _meal['desc'],
          style: TextStyle(
              fontSize: 18
          ),
        ),
      ],
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'How Many'
            ),
            items: List.generate(10, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'),
              );
            }),
            value: _data.count,
            onChanged: (count) {
              setState(() {
                _data.count = count;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Extra Requirements (Optional)',
            ),
          )
        ],
      ),
    );
  }

  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Util.showLoading('Adding item', context);
     _orderProvider.addToOrder(_meal, _data.count, _data.requirements).then((onValue) {
       _scaffoldKey.currentState.showSnackBar(SnackBar(
         content: Text('Order Added'),
       ));
      //  Scaffold.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      //    content: Text('Order Added'),
      //  ));
       Navigator.of(context).pop();
       Navigator.of(context).pop();
       
     }).catchError((err) {
       Navigator.of(context).pop();
       print(err);
       Util.showAlert('Error', 'Could not add item: ${err.toString()}', context);
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_meal == null) {
      _meal = widget.meal;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Meal Info'
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  _buildMenuInfo(),
                  Divider(),
                  _buildForm()
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    onPressed: () => _save(),
                    child: Text('Done'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}