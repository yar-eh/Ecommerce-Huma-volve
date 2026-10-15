import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final int limit = 10;
  int offset = 0;
  bool isLoadingMore = false;
  bool hasMore = true;
  int? selectedCategory;
  int _requestId = 0;
  final List<HomeProductEntity> _products = [];

  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());
    final categoriesResult = await getCategoriesUseCase.invoke();

    if (categoriesResult.isLeft()) {
      categoriesResult.fold(
        (failure) => emit(CategoriesError(failure.failureMessage)),
        (_) {},
      );
      return;
    }
    final categories = categoriesResult.getOrElse(() => []);
    if (categories.isEmpty) return;

    emit(CategoriesSuccess(categories));
    await getProductsByCategoryId(categories.first.id);
  }

  Future<void> getProductsByCategoryId(int id) async {
    final requestId = ++_requestId;
    selectedCategory = id;
    _products.clear();
    offset = 0;
    hasMore = true;
    isLoadingMore = false;
    emit(ProductsLoading());

    final result = await getProductsUseCase.invoke(
      id,
      limit: limit,
      offset: offset,
    );
    if (requestId != _requestId) return;

    result.fold((failure) => emit(ProductsError(failure.failureMessage)), (
      products,
    ) {
      _products.addAll(products);
      offset = products.length;
      if (products.length < limit) hasMore = false;
      emit(ProductsSuccess(List.from(_products)));
    });
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;
    if (state is ProductsLoading || state is ProductsError) return;

    final requestId = _requestId;
    isLoadingMore = true;
    emit(ProductsLoadingMore());

    final result = await getProductsUseCase.invoke(
      selectedCategory,
      limit: limit,
      offset: offset,
    );
    if (requestId != _requestId) return;

    isLoadingMore = false;
    result.fold(
      (failure) => emit(ProductsLoadingError(failure.failureMessage)),
      (newProducts) {
        _products.addAll(newProducts);
        offset += newProducts.length;
        if (newProducts.length < limit) hasMore = false;
        emit(ProductsSuccess(List.from(_products)));
      },
    );
  }
}
