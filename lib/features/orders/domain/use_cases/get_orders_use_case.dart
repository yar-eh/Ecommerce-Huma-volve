import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/repository/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository ordersRepository;
  GetOrdersUseCase(this.ordersRepository);

  Future<Either<Failure, List<OrderEntity>>> invoke() =>
      ordersRepository.getOrders();
}
