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
  final TextEditingController _typeAheadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments as String;
    final Shop shop =
        Provider.of<Shops>(context, listen: false).findById(shopId);
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage'),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadController,
                  decoration: InputDecoration(labelText: 'Add Product')),
              suggestionsCallback: (pattern) async {
                final products =
                    await Provider.of<Products>(context, listen: false)
                        .queryProducts(nameStr: pattern);
                if (products.length == 0) {
                  final emptyList = new List<Product>();
                  emptyList.add(new Product(
                      id: null,
                      name: null,
                      description: null,
                      price: null,
                      image: null));
                  return emptyList;
                }
                return products;
              },
              itemBuilder: (context, Product suggestion) {
                return ListTile(
                  leading: suggestion.id != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(suggestion.image),
                        )
                      : Icon(Icons.add),
                  title: suggestion.id != null
                      ? Text(suggestion.name)
                      : Text('Create New'),
                  trailing: suggestion.id != null
                      ? Text('Price: \$${suggestion.price}')
                      : null,
                );
              },
              onSuggestionSelected: (Product suggestion) {
                Navigator.of(context).pushNamed(ProductAddScreen.routeName,
                    arguments: ProductAddScreenArguments(
                        shopId: shop.id,
                        product: suggestion.id != null ? suggestion : null,
                        productName: this._typeAheadController.text));
              },
            ),
          ),
        ));
  }
}
