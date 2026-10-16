import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
    int productId,
  );
}
