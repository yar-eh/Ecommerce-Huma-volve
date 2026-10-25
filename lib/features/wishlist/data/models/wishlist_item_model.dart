import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';

class WishlistItemModel extends WishlistItemEntity {
  const WishlistItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
  });

  factory WishlistItemModel.fromEntity(WishlistItemEntity item) =>
      WishlistItemModel(
        id: item.id,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
      );

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      WishlistItemModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        imageUrl: json['imageUrl'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'imageUrl': imageUrl,
  };
}
