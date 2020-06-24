import 'package:flutter/material.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:provider/provider.dart';

class ShopManage extends StatefulWidget {
  static const routeName = '/shop-manage';
  const ShopManage({Key key}) : super(key: key);

  @override
  _ShopManageState createState() => _ShopManageState();
}

class _ShopManageState extends State<ShopManage> {
  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments as String;
    final Shop shop = Provider.of<Shops>(context, listen: false).findById(shopId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
      ),
      body: Column(
        children: <Widget>[
          Text('Manage shop items in ' + shop.name)
        ],
      ),
    );
  }
}