import '../models/product_details_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetails(int productId);
}
