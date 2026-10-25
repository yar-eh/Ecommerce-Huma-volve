import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentaion/view/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view/widgets/wishlist_item_card.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: BlocBuilder<WishlistCubit, WishlistStates>(
        builder: (context, state) {
          if (state is WishlistError) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is! WishlistSuccess) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppTheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return WishlistItemCard(
                item: item,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(productId: item.id),
                  ),
                ),
                onRemove: () =>
                    context.read<WishlistCubit>().toggleWishlist(item),
              );
            },
          );
        },
      ),
    );
  }
}
