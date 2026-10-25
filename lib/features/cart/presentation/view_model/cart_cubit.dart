import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/get_cart_items_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/view_model/cart_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartStates> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    _emitResult(await getCartItemsUseCase.invoke());
  }

  Future<void> addToCart(CartItemEntity item) async {
    _emitResult(await addToCartUseCase.invoke(item));
  }

  Future<void> increaseQuantity(CartItemEntity item) async {
    _emitResult(
      await updateCartQuantityUseCase.invoke(item.key, item.quantity + 1),
    );
  }

  Future<void> decreaseQuantity(CartItemEntity item) async {
    if (item.quantity <= 1) return; // use delete to remove an item
    _emitResult(
      await updateCartQuantityUseCase.invoke(item.key, item.quantity - 1),
    );
  }

  Future<void> removeItem(CartItemEntity item) async {
    _emitResult(await removeFromCartUseCase.invoke(item.key));
  }

  Future<void> clearCart() async {
    _emitResult(await clearCartUseCase.invoke());
  }

  void _emitResult(Either<Failure, List<CartItemEntity>> result) {
    if (isClosed) return;
    result.fold(
      (failure) => emit(CartError(failure.failureMessage)),
      (items) => emit(CartSuccess(items)),
    );
  }
}
