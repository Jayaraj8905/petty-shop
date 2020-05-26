import 'package:flutter/material.dart';
import 'package:petty_shop/helpers/custom_route.dart';
import 'package:petty_shop/providers/shops.dart';
import 'package:petty_shop/screens/shop_add_screen.dart';
import 'package:petty_shop/screens/shop_list_screen.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/orders_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(PettyShopApp());

class PettyShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth()
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items
          ), create: (BuildContext context) {},
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Shops(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders
          ), create: (BuildContext context) {},
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Petty Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
            splashColor: Colors.black87,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              }
            )
          ),
          home: auth.isAuthenticated 
                ? ProductOverviewScreen() 
                : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) => 
                    snapshot.connectionState == ConnectionState.waiting 
                            ? SplashScreen()
                            : AuthScreen()
                  
              ),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ShopAddScreen.routeName: (ctx) => ShopAddScreen(),
            ShopListScreen.routeName: (ctx) => ShopListScreen()
          },
        ),
      )
      
    );
  }
}
