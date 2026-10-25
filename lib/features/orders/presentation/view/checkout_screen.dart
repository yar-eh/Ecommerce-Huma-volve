import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/app_network_image.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/custom_text_field.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/view_model/cart_states.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/data_source/orders_local_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/orders/data/repository/orders_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/orders/domain/use_cases/place_order_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view/orders_screen.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view/widgets/open_product_details.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/checkout_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view_model/checkout_states.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutCubit(
        placeOrderUseCase: PlaceOrderUseCase(
          OrdersRepositoryImpl(OrdersLocalDataSourceImpl()),
        ),
      ),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController phoneController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    // pre-fill from the saved profile (empty the first time)
    final profileState = context.read<ProfileCubit>().state;
    final profile = profileState is ProfileSuccess
        ? profileState.profile
        : null;
    phoneController = TextEditingController(text: profile?.phone ?? '');
    addressController = TextEditingController(text: profile?.address ?? '');
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _placeOrder(CartSuccess cart) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<CheckoutCubit>().placeOrder(
      items: cart.items,
      subtotal: cart.subtotal,
      tax: cart.tax,
      total: cart.total,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutStates>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state is CheckoutSuccess) {
          final cartCubit = context.read<CartCubit>();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen()),
          );
          cartCubit.clearCart();
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is CheckoutError) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppTheme.primary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
          backgroundColor: AppTheme.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.primary),
        ),
        body: BlocBuilder<CartCubit, CartStates>(
          builder: (context, cartState) {
            if (cartState is! CartSuccess || cartState.items.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle('Shipping details'),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Enter your phone number here',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: addressController,
                      hintText: 'Enter your address here',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    _sectionTitle('Payment'),
                    const SizedBox(height: 12),
                    _infoTile(Icons.payments_outlined, 'Cash on delivery'),
                    const SizedBox(height: 28),
                    _sectionTitle('Order summary (${cartState.items.length})'),
                    const SizedBox(height: 12),
                    Container(
                      height: 190, // fixed height, the list scrolls inside it
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => openProductDetails(context, item),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AppNetworkImage(
                                      url: item.imageUrl,
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${item.title}\nSize ${item.size}  \u00b7  Qty ${item.quantity}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$${item.lineTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 32),
                    _totalRow('Subtotal', cartState.subtotal),
                    const SizedBox(height: 8),
                    _totalRow('Tax (10%)', cartState.tax),
                    const SizedBox(height: 8),
                    _totalRow('Total', cartState.total, bold: true),
                    const SizedBox(height: 32),
                    BlocBuilder<CheckoutCubit, CheckoutStates>(
                      builder: (context, state) => PrimaryButton(
                        text: 'Place Order',
                        isLoading: state is CheckoutLoading,
                        onPressed: () => _placeOrder(cartState),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  Widget _infoTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 20 : 16,
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      color: bold ? AppTheme.primary : null,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
