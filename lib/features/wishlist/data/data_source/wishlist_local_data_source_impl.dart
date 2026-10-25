import 'dart:convert';

import 'package:ecommerce_app_huma_volve/core/storage/user_session.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/data_source/wishlist_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  static const String _key = 'wishlist_items';

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(await UserSession.scopedKey(_key));
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveWishlist(List<WishlistItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      await UserSession.scopedKey(_key),
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}
