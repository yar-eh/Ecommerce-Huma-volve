import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';

/// Every method returns the updated cart.
abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, List<CartItemEntity>>> addToCart(CartItemEntity item);
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(
    String itemKey,
    int quantity,
  );
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(String itemKey);
  Future<Either<Failure, List<CartItemEntity>>> clearCart();
}
