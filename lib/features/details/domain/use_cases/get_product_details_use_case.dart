import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repository/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository productDetailsRepository;
  GetProductDetailsUseCase(this.productDetailsRepository);

  Future<Either<Failure, ProductDetailsEntity>> invoke(int productId) =>
      productDetailsRepository.getProductDetails(productId);
}
