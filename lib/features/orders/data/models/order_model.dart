import 'package:ecommerce_app_huma_volve/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.createdAt,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    required super.phone,
    required super.address,
    super.status,
  });

  factory OrderModel.fromEntity(OrderEntity order) => OrderModel(
    id: order.id,
    createdAt: order.createdAt,
    items: order.items,
    subtotal: order.subtotal,
    tax: order.tax,
    total: order.total,
    phone: order.phone,
    address: order.address,
    status: order.status,
  );

  OrderModel.fromJson(Map<String, dynamic> json)
    : super(
        id: json['id'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        items: (json['items'] as List? ?? const [])
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        tax: (json['tax'] as num?)?.toDouble() ?? 0,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        status: json['status'] ?? 'Processing',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((e) => CartItemModel.fromEntity(e).toJson()).toList(),
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
    'phone': phone,
    'address': address,
    'status': status,
  };
}
