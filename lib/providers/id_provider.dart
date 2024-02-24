import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static String _customerId = "";
  /*late Future<String> documentId;*/
  late String docId;
  String get getData {
    return _customerId;
  }

  setCustomerId(User user) async {
    final SharedPreferences pref = await _prefs;
    pref
        .setString('customerid', user.uid)
        .whenComplete(() => _customerId = user.uid);
    notifyListeners();
  }

  clearCustomerId() async {
    final SharedPreferences pref = await _prefs;
    pref.setString('customerid', '').whenComplete(() => _customerId = '');
    notifyListeners();
  }

  Future<String> getDocumentId() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString('customerid') ?? '';
    });
  }

  getDocId() async {
    await getDocumentId().then((value) => _customerId = value);
    notifyListeners();
  }
}
