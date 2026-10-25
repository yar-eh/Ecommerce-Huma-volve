import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/data_source/wishlist_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/repository/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource wishlistLocalDataSource;
  WishlistRepositoryImpl(this.wishlistLocalDataSource);

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist() async {
    try {
      final items = await wishlistLocalDataSource.getWishlist();
      return Right(List<WishlistItemEntity>.from(items));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> toggleWishlist(
    WishlistItemEntity item,
  ) async {
    try {
      final items = List<WishlistItemEntity>.from(
        await wishlistLocalDataSource.getWishlist(),
      );
      final index = items.indexWhere((e) => e.id == item.id);
      if (index == -1) {
        items.insert(0, item);
      } else {
        items.removeAt(index);
      }
      await wishlistLocalDataSource.saveWishlist(
        items.map(WishlistItemModel.fromEntity).toList(),
      );
      return Right(items);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
