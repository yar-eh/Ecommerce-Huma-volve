import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';

abstract class OrdersStates {}

class OrdersInitial extends OrdersStates {}

class OrdersLoading extends OrdersStates {}

class OrdersSuccess extends OrdersStates {
  final List<OrderEntity> orders;
  OrdersSuccess(this.orders);
}

class OrdersError extends OrdersStates {
  final String errorMessage;
  OrdersError(this.errorMessage);
}
