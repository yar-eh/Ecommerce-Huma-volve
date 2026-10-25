import 'dart:convert';

import 'package:ecommerce_app_huma_volve/core/storage/user_session.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/data_source/orders_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  static const String _key = 'orders';

  @override
  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(await UserSession.scopedKey(_key));
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      await UserSession.scopedKey(_key),
      jsonEncode(orders.map((e) => e.toJson()).toList()),
    );
  }
}
