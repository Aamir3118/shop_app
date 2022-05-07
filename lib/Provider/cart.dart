import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartitems = {};
  Map<String, CartItem> get cartitems {
    return {..._cartitems};
  }

  int get itemCount {
    return _cartitems == null ? 0 : _cartitems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartitems.forEach((key, itemValue) {
      total += itemValue.price * itemValue.quantity;
    });
    return total;
  }

  void addItem(String prodId, double price, String title) {
    if (_cartitems.containsKey(prodId)) {
      _cartitems.update(
          prodId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price));
    } else {
      _cartitems.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

//addOrRemoveQuantity(String proId, bool operators) {
//  if (_cartitems.containsKey(proId)) {
//   _cartitems.update(
//          proId,
//          (existItem) => CartItem(
//              id: existItem.id,
//              title: existItem.title,
//              quantity:
//                  operators ? existItem.quantity + 1 : existItem.quantity - 1,
//              price: existItem.price));
//   }
//    notifyListeners();
//  }

  void removeItem(String prodId) {
    _cartitems.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_cartitems.containsKey(prodId)) {
      return;
    }
    if (_cartitems[prodId]!.quantity > 1) {
      _cartitems.update(
          prodId,
          (existingcartItem) => CartItem(
              id: existingcartItem.id,
              title: existingcartItem.title,
              quantity: existingcartItem.quantity - 1,
              price: existingcartItem.price));
    } else {
      _cartitems.remove(prodId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartitems = {};
    notifyListeners();
  }
}
