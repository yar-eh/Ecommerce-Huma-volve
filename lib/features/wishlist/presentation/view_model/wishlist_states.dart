import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';

abstract class WishlistStates {}

class WishlistInitial extends WishlistStates {}

class WishlistLoading extends WishlistStates {}

class WishlistSuccess extends WishlistStates {
  final List<WishlistItemEntity> items;
  WishlistSuccess(this.items);

  bool contains(int productId) => items.any((e) => e.id == productId);
}

class WishlistError extends WishlistStates {
  final String errorMessage;
  WishlistError(this.errorMessage);
}
