import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';

abstract class ProductDetailsStates {}

class ProductDetailsInitial extends ProductDetailsStates {}

class ProductDetailsLoading extends ProductDetailsStates {}

class ProductDetailsSuccess extends ProductDetailsStates {
  final ProductDetailsEntity product;
  ProductDetailsSuccess(this.product);
}

class ProductDetailsError extends ProductDetailsStates {
  final String errorMessage;
  ProductDetailsError(this.errorMessage);
}
