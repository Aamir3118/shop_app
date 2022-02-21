import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/cart.dart';
import 'package:shop/widgets/my_cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .subtitle1!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  FlatButton(
                    child: Text("Order Now"),
                    onPressed: () {},
                    textColor: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.cartitems.length,
                itemBuilder: (ctx, i) => MyCartItem(
                      cart.cartitems.values.toList()[i].id,
                      cart.cartitems.keys.toList()[i],
                      cart.cartitems.values.toList()[i].price,
                      cart.cartitems.values.toList()[i].quantity,
                      cart.cartitems.values.toList()[i].title,
                    )),
          )
        ],
      ),
    );
  }
}
