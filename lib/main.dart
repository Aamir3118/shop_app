import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/auth.dart';
import 'package:shop/Provider/cart.dart';
import 'package:shop/Provider/order.dart';
import 'package:shop/Provider/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, null, []),
            update: (ctx, auth, previousProds) => Products(
              auth.token,
              auth.userId,
              previousProds!.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order(null, null, []),
            update: (ctx, auth, previousOrder) =>
                Order(auth.token, auth.userId, previousOrder!.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
              ),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.autoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
