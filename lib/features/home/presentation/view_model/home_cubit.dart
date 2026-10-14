import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());
  Future<void> loadHomeData() async {
    int categoryId = 0;
    emit(CategoriesLoading());
    final categories = await getCategoriesUseCase.invoke();
    categories.fold(
      (failure) {
        emit(CategoriesError(failure.failureMessage));
      },
      (categories) {
        categoryId = categories[0].id;
        emit(CategoriesSuccess(categories));
      },
    );
    final products = await getProductsUseCase.invoke(categoryId);
    products.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        emit(ProductsSuccess(products));
      },
    );
  }

  Future<void> getProductsByCategory(int id) async {
    emit(ProductsLoading());
    final products = await getProductsUseCase.invoke(id);
    products.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        emit(ProductsSuccess(products));
      },
    );
  }
}
