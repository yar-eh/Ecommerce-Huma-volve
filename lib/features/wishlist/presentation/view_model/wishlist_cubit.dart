import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/use_cases/get_wishlist_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/use_cases/toggle_wishlist_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistCubit extends Cubit<WishlistStates> {
  final GetWishlistUseCase getWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;

  WishlistCubit({
    required this.getWishlistUseCase,
    required this.toggleWishlistUseCase,
  }) : super(WishlistInitial());

  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    final result = await getWishlistUseCase.invoke();
    if (isClosed) return;
    result.fold(
      (failure) => emit(WishlistError(failure.failureMessage)),
      (items) => emit(WishlistSuccess(items)),
    );
  }

  Future<void> toggleWishlist(WishlistItemEntity item) async {
    final result = await toggleWishlistUseCase.invoke(item);
    if (isClosed) return;
    result.fold(
      (failure) => emit(WishlistError(failure.failureMessage)),
      (items) => emit(WishlistSuccess(items)),
    );
  }
}
