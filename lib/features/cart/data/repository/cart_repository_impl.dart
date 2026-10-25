import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/data_source/cart_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource cartLocalDataSource;
  CartRepositoryImpl(this.cartLocalDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await cartLocalDataSource.getCartItems();
      return Right(List<CartItemEntity>.from(items));
    } catch (e) {
      print('CART ERROR: $e');
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> addToCart(CartItemEntity item) {
    return _modify((items) {
      final index = items.indexWhere((e) => e.key == item.key);
      if (index == -1) return [...items, item];
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
      return items;
    });
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(
    String itemKey,
    int quantity,
  ) {
    return _modify((items) {
      final index = items.indexWhere((e) => e.key == itemKey);
      if (index != -1) items[index] = items[index].copyWith(quantity: quantity);
      return items;
    });
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(String itemKey) {
    return _modify((items) => items.where((e) => e.key != itemKey).toList());
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> clearCart() {
    return _modify((items) => []);
  }

  /// Loads the cart, applies [change], saves it and returns the new cart.
  Future<Either<Failure, List<CartItemEntity>>> _modify(
    List<CartItemEntity> Function(List<CartItemEntity> items) change,
  ) async {
    try {
      final current = List<CartItemEntity>.from(
        await cartLocalDataSource.getCartItems(),
      );
      final updated = change(current);
      await cartLocalDataSource.saveCartItems(
        updated.map(CartItemModel.fromEntity).toList(),
      );
      return Right(updated);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
