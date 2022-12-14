import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-product';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final prodData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Products',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, prodData, _) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UserProductItem(
                                  prodData.items[i].id,
                                  prodData.items[i].title,
                                  prodData.items[i].imageUrl),
                              Divider(),
                            ],
                          ),
                          itemCount: prodData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
