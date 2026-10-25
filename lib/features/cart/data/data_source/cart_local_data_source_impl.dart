import 'dart:convert';

import 'package:ecommerce_app_huma_volve/core/storage/user_session.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/data_source/cart_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _key = 'cart_items';

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(await UserSession.scopedKey(_key));
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      await UserSession.scopedKey(_key),
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}
