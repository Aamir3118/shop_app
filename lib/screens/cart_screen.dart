import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/cart.dart';
import 'package:shop/Provider/order.dart';
import 'package:shop/widgets/my_cart_items.dart';

class CartScreen extends StatelessWidget {
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
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .subtitle1!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text("Order Now"),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.cartitems.values.toList(),
                  widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      textColor: Theme.of(context).colorScheme.primary,
    );
  }
}
