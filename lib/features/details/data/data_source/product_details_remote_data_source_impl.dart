import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/models/product_details_model.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ApiClient apiClient;
  ProductDetailsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProductDetailsModel> getProductDetails(int productId) async {
    final response = await apiClient.dio.get(
      "${ApiEndpoints.productsEndpoint}/$productId",
    );
    return ProductDetailsModel.fromJson(response.data);
  }
}
