import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/order_item_widget.dart';
import './../widgets/app_drawer.dart';
import './../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Orders>(context, listen: false).fetchOrders(),
        child: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) {
                    return OrderItemWidget(
                      orderData.orders[index]
                    );
                  },
                ),
              );
            }

          },
        ),
      ),
      drawer: AppDrawer(),
    );
  }

}