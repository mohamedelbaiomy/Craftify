import 'package:flutter/foundation.dart';
import 'package:customers_app_google_play/providers/product_class.dart';
import 'package:customers_app_google_play/providers/sql_helper.dart';

class Wish extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addWishItem(Product products) async {
    await SQLHelper.insertWishItem(products)
        .whenComplete(() => _list.add(products));
    notifyListeners();
  }

  loadWishItemsProvider() async {
    List<Map> data = await SQLHelper.loadWishItems();
    _list = data.map((products) {
      return Product(
        documentId: products['documentId'],
        name: products['name'],
        price: products['price'],
        qty: products['qty'],
        qntty: products['qntty'],
        imagesUrl: products['imagesUrl'],
        suppId: products['suppId'],
      );
    }).toList();
    notifyListeners();
  }

  void removeItem(Product products) async {
    await SQLHelper.deleteWishItem(products.documentId)
        .whenComplete(() => _list.remove(products));
    notifyListeners();
  }

  void clearWishlist() async {
    await SQLHelper.deleteAllWishItems().whenComplete(() => _list.clear());
    notifyListeners();
  }

  void removeThis(String idw) {
    _list.removeWhere((element) => element.documentId == idw);
    notifyListeners();
  }
}
