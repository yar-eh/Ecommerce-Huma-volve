import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';

abstract class OrdersRepository {
  /// Newest first.
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order);
}
