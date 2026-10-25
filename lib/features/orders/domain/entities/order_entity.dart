import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity {
  final String id;
  final DateTime createdAt;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double total;
  final String phone;
  final String address;
  final String status;

  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.phone,
    required this.address,
    this.status = 'Processing',
  });
}
