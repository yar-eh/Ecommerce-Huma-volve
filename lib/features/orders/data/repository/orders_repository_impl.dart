import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/data_source/orders_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/models/order_model.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/repository/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersLocalDataSource ordersLocalDataSource;
  OrdersRepositoryImpl(this.ordersLocalDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await ordersLocalDataSource.getOrders();
      return Right(List<OrderEntity>.from(orders));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order) async {
    try {
      final orders = List<OrderEntity>.from(
        await ordersLocalDataSource.getOrders(),
      );
      orders.insert(0, order); // newest first
      await ordersLocalDataSource.saveOrders(
        orders.map(OrderModel.fromEntity).toList(),
      );
      return Right(order);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
