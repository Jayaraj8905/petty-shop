import 'package:flutter/material.dart';
// https://pub.dev/packages/flutter_typeahead#-readme-tab-
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:petty_shop/providers/product.dart';
import 'package:petty_shop/providers/products.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:petty_shop/screens/product_add_screen.dart';
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              )
            ),
            suggestionsCallback: (pattern) async {
              return await Provider.of<Products>(context, listen: false).queryProducts(nameStr: pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: suggestion.image != null 
                                    ? NetworkImage(suggestion.image)
                                    : Text(suggestion.name.substring(0,1)),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: suggestion.image != null ? Image.network(suggestion.image) : Text('Image')
                    ),
                  ),
                ),
                title: Text(suggestion.name),
                trailing: Text('Price: \$${suggestion.price}'),
              );
            },
            onSuggestionSelected: (Product suggestion) {
              Navigator.of(context).pushNamed(ProductAddScreen.routeName, arguments: ProductAddScreenArguments(shopId: shop.id, product: suggestion));
            },
          ),
        ),
      )
    );
  }
}