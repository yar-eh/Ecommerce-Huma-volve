import 'package:ecommerce_app_huma_volve/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/orders_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersStates> {
  final GetOrdersUseCase getOrdersUseCase;
  OrdersCubit({required this.getOrdersUseCase}) : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final result = await getOrdersUseCase.invoke();
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrdersError(failure.failureMessage)),
      (orders) => emit(OrdersSuccess(orders)),
    );
  }
}
