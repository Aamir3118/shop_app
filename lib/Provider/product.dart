import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavouriteValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'shop-app-9408c-default-rtdb.firebaseio.com', '/products/$id.json');
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavourite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFavouriteValue(oldStatus);
      }
    } catch (error) {
      _setFavouriteValue(oldStatus);
    }
  }
}
