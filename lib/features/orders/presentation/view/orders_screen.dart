import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/data_source/orders_local_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/repository/orders_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view/widgets/order_card.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/orders_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/orders_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(
        getOrdersUseCase: GetOrdersUseCase(
          OrdersRepositoryImpl(OrdersLocalDataSourceImpl()),
        ),
      )..loadOrders(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('My Orders'),
          centerTitle: true,
          backgroundColor: AppTheme.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.primary),
        ),
        body: BlocBuilder<OrdersCubit, OrdersStates>(
          builder: (context, state) {
            if (state is OrdersError) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is! OrdersSuccess) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: AppTheme.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) =>
                  OrderCard(order: state.orders[index]),
            );
          },
        ),
      ),
    );
  }
}
