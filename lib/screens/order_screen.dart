import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/order.dart' show Order;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_items.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building Orders');
    //final myOrders = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, myOrders, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(myOrders.orders[i]),
                  itemCount: myOrders.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
