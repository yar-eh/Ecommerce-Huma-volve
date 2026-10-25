import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/repository/wishlist_repository.dart';

class ToggleWishlistUseCase {
  final WishlistRepository wishlistRepository;
  ToggleWishlistUseCase(this.wishlistRepository);

  Future<Either<Failure, List<WishlistItemEntity>>> invoke(
    WishlistItemEntity item,
  ) => wishlistRepository.toggleWishlist(item);
}
