import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repository/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource productDetailsRemoteDataSource;
  ProductDetailsRepositoryImpl(this.productDetailsRemoteDataSource);

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
    int productId,
  ) async {
    try {
      final product = await productDetailsRemoteDataSource.getProductDetails(
        productId,
      );
      return Right(product);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
