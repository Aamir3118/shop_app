import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/cart.dart';
import 'package:shop/Provider/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myproducts = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: myproducts.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Image.network(
              myproducts.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: SingleChildScrollView(
          child: GridTileBar(
            backgroundColor: Colors.black87.withOpacity(0.4),
            leading: Consumer<Product>(
              builder: (ctx, prods, child) => SizedBox(
                width: 40,
                child: IconButton(
                  icon: Icon(myproducts.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    myproducts.toggleFavoriteStatus();
                  },
                ),
              ),
            ),
            title: SizedBox(
              child: Text(
                myproducts.title,
                //textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(myproducts.id, myproducts.price, myproducts.title);
                // ignore: deprecated_member_use
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Added item to cart!',
                    style: TextStyle(color: Colors.white),
                    //textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.black,
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(myproducts.id);
                      }),
                  duration: Duration(seconds: 2),
                ));
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
