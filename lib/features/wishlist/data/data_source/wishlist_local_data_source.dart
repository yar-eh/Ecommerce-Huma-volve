import '../models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<void> saveWishlist(List<WishlistItemModel> items);
}
