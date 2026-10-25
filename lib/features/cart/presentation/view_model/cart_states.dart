import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartStates {}

class CartInitial extends CartStates {}

class CartLoading extends CartStates {}

class CartSuccess extends CartStates {
  static const double taxRate = 0.1;

  final List<CartItemEntity> items;
  CartSuccess(this.items);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.lineTotal);
  double get tax => subtotal * taxRate;
  double get total => subtotal + tax;
}

class CartError extends CartStates {
  final String errorMessage;
  CartError(this.errorMessage);
}
