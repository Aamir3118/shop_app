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
    print("rebuild");
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
          child: Image.network(
            myproducts.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: SingleChildScrollView(
          child: GridTileBar(
            backgroundColor: Colors.black87,
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
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
