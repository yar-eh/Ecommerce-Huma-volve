import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.imageUrl,
    required super.price,
    required super.size,
    required super.colorValue,
    super.quantity,
  });

  factory CartItemModel.fromEntity(CartItemEntity item) => CartItemModel(
    productId: item.productId,
    title: item.title,
    imageUrl: item.imageUrl,
    price: item.price,
    size: item.size,
    colorValue: item.colorValue,
    quantity: item.quantity,
  );

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    productId: json['productId'] ?? 0,
    title: json['title'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0,
    size: json['size'] ?? '',
    colorValue: json['colorValue'] ?? 0,
    quantity: json['quantity'] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'title': title,
    'imageUrl': imageUrl,
    'price': price,
    'size': size,
    'colorValue': colorValue,
    'quantity': quantity,
  };
}
