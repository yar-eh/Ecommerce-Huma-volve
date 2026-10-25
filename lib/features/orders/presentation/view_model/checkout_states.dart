import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';

abstract class CheckoutStates {}

class CheckoutInitial extends CheckoutStates {}

class CheckoutLoading extends CheckoutStates {}

class CheckoutSuccess extends CheckoutStates {
  final OrderEntity order;
  CheckoutSuccess(this.order);
}

class CheckoutError extends CheckoutStates {
  final String errorMessage;
  CheckoutError(this.errorMessage);
}
