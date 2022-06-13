import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/Provider/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Products with ChangeNotifier {
  //final String? authToken;
  //Products(this.authToken, this._items);
  List<Product> _items = [
    /*  Product(
      id: 'p1',
      title: 'Red Shirt ',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers ',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf ',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  final String? authToken;
  final String? userId;
  Products(this.authToken, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
        '/products.json', {'auth': '$authToken'});
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: jsonDecode(response.body)['name'],
      );
      _items.add(newProduct);

      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prods) => prods.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
          '/products/$id.json', {'auth': '$authToken'});
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    //final filterString =
    //  filterByUser ? {'orderBy': '"creatorId"', 'equalTo': '"$userId"'} : '';
    var param = {'auth': authToken};
    if (filterByUser) {
      param = {
        'auth': authToken,
        'orderBy': jsonEncode("creatorId"),
        'equalTo': jsonEncode(userId)
      };
    }

    var url = Uri.https(
        'shop-app-9408c-default-rtdb.firebaseio.com', '/products.json', param);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return print('You have no product');
      }
      url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
          '/userFavourites/$userId.json', {'auth': '$authToken'});
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach(((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
        ));
      }));
      _items = loadedProduct;
      notifyListeners();
      print(jsonDecode(response.body));
    } catch (error) {
      //throw error;
      print(error);
    }
  }

  Future<void> deleteProducts(String id) async {
    final url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': '$authToken'});
    final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    //print(response.statusCode);

    existingProd = null;
  }
}
