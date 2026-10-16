import 'package:ecommerce_app_huma_volve/features/details/domain/use_cases/get_product_details_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentaion/view_model/product_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  ProductDetailsCubit({required this.getProductDetailsUseCase})
    : super(ProductDetailsInitial());

  Future<void> getProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase.invoke(productId);
    // the user may have left the page before the response arrived
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProductDetailsError(failure.failureMessage)),
      (product) => emit(ProductDetailsSuccess(product)),
    );
  }
}
