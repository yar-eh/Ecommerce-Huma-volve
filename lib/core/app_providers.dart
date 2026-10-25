import 'package:ecommerce_app_huma_volve/features/cart/data/data_source/cart_local_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/repository/cart_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/clear_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/get_cart_items_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/remove_from_cart_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/profile_local_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/repository/profile_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/save_profile_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/data_source/wishlist_local_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/repository/wishlist_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/use_cases/get_wishlist_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/use_cases/toggle_wishlist_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubits that several screens share (cart, wishlist, profile).
/// They live above MaterialApp so pushed pages (details, checkout...) can reach them too.
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  /// Call after login: the new user's cart, wishlist and profile replace
  /// the ones of the previous user.
  static void reloadUserData(BuildContext context) {
    context.read<CartCubit>().loadCart();
    context.read<WishlistCubit>().loadWishlist();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) {
            final repository = CartRepositoryImpl(CartLocalDataSourceImpl());
            return CartCubit(
              getCartItemsUseCase: GetCartItemsUseCase(repository),
              addToCartUseCase: AddToCartUseCase(repository),
              updateCartQuantityUseCase: UpdateCartQuantityUseCase(repository),
              removeFromCartUseCase: RemoveFromCartUseCase(repository),
              clearCartUseCase: ClearCartUseCase(repository),
            )..loadCart();
          },
        ),
        BlocProvider(
          lazy: false,
          create: (_) {
            final repository = WishlistRepositoryImpl(
              WishlistLocalDataSourceImpl(),
            );
            return WishlistCubit(
              getWishlistUseCase: GetWishlistUseCase(repository),
              toggleWishlistUseCase: ToggleWishlistUseCase(repository),
            )..loadWishlist();
          },
        ),
        BlocProvider(
          lazy: false,
          create: (_) {
            final repository = ProfileRepositoryImpl(
              ProfileLocalDataSourceImpl(),
            );
            return ProfileCubit(
              getProfileUseCase: GetProfileUseCase(repository),
              saveProfileUseCase: SaveProfileUseCase(repository),
            )..loadProfile();
          },
        ),
      ],
      child: child,
    );
  }
}
