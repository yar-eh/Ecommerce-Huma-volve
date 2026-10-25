import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/use_cases/place_order_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/checkout_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutStates> {
  final PlaceOrderUseCase placeOrderUseCase;
  CheckoutCubit({required this.placeOrderUseCase}) : super(CheckoutInitial());

  Future<void> placeOrder({
    required List<CartItemEntity> items,
    required double subtotal,
    required double tax,
    required double total,
    required String phone,
    required String address,
  }) async {
    if (state is CheckoutLoading) return; // ignore double taps
    emit(CheckoutLoading());
    final now = DateTime.now();
    final order = OrderEntity(
      id: now.millisecondsSinceEpoch.toString(),
      createdAt: now,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      phone: phone,
      address: address,
    );
    final result = await placeOrderUseCase.invoke(order);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CheckoutError(failure.failureMessage)),
      (placed) => emit(CheckoutSuccess(placed)),
    );
  }
}
