import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/Provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
        '/orders/$userId.json', {'auth': '$authToken'});
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return print('you have no orders now');
    }
    print(extractedData);

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId.toString(),
        amount: orderData['amount'] as double,
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((items) => CartItem(
                  id: items['id'].toString(),
                  price: items['price'] as double,
                  quantity: items['quantity'] as int,
                  title: items['title'].toString(),
                ))
            .toList(),
      ));
    });
    //print(json.decode(response.body));
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https('shop-app-9408c-default-rtdb.firebaseio.com',
        '/orders/$userId.json', {'auth': '$authToken'});
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
