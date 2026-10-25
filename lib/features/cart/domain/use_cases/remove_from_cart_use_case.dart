import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository cartRepository;
  RemoveFromCartUseCase(this.cartRepository);

  Future<Either<Failure, List<CartItemEntity>>> invoke(String itemKey) =>
      cartRepository.removeFromCart(itemKey);
}
