import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/order.dart' show Order;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_items.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final myOrders = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(myOrders.orders[i]),
        itemCount: myOrders.orders.length,
      ),
    );
  }
}
