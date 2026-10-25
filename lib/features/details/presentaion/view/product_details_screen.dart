import 'package:ecommerce_app_huma_volve/core/constants/product_options.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/view_model/cart_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/repository/product_details_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/use_cases/get_product_details_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view_model/wishlist_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/product_details_cubit.dart';
import '../view_model/product_details_states.dart';
import 'widgets/color_selector.dart';
import 'widgets/share_product_button.dart';
import 'widgets/size_selector.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  final int? initialColorValue;
  final String? initialSize;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.initialColorValue,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(
        getProductDetailsUseCase: GetProductDetailsUseCase(
          ProductDetailsRepositoryImpl(
            ProductDetailsRemoteDataSourceImpl(ApiClient()),
          ),
        ),
      )..getProductDetails(productId),
      child: _ProductDetailsView(
        productId: productId,
        initialColorValue: initialColorValue,
        initialSize: initialSize,
      ),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final int productId;
  final int? initialColorValue;
  final String? initialSize;

  const _ProductDetailsView({
    required this.productId,
    this.initialColorValue,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
      builder: (context, state) {
        if (state is ProductDetailsSuccess) {
          return _ProductDetailsContent(
            product: state.product,
            productId: productId,
            initialColorValue: initialColorValue,
            initialSize: initialSize,
          );
        }
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.primary),
          ),
          body: Center(
            child: state is ProductDetailsError
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.errorMessage, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => context
                              .read<ProductDetailsCubit>()
                              .getProductDetails(productId),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final ProductDetailsEntity product;
  final int productId;
  final int? initialColorValue;
  final String? initialSize;

  const _ProductDetailsContent({
    required this.product,
    required this.productId,
    this.initialColorValue,
    this.initialSize,
  });

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  late Color _selectedColor;
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    final colorValue = widget.initialColorValue;
    _selectedColor = ProductOptions.colors.firstWhere(
      (color) => color.toARGB32() == colorValue,
      orElse: () => ProductOptions.colors.first,
    );
    final size = widget.initialSize;
    _selectedSize = size != null && ProductOptions.sizes.contains(size)
        ? size
        : ProductOptions.sizes[1];
  }

  ProductDetailsEntity get product => widget.product;
  String get _firstImage => product.images.isEmpty ? '' : product.images.first;

  void _addToCart() {
    context.read<CartCubit>().addToCart(
      CartItemEntity(
        productId: product.id,
        title: product.title,
        imageUrl: _firstImage,
        price: product.price,
        size: _selectedSize,
        colorValue: _selectedColor.toARGB32(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              ShareProductButton(productId: widget.productId.toString()),
              const SizedBox(width: 8),
              BlocBuilder<WishlistCubit, WishlistStates>(
                builder: (context, state) {
                  final isFavorite =
                      state is WishlistSuccess && state.contains(product.id);
                  return IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: AppTheme.primary,
                      ),
                    ),
                    onPressed: () =>
                        context.read<WishlistCubit>().toggleWishlist(
                          WishlistItemEntity(
                            id: product.id,
                            title: product.title,
                            price: product.price,
                            imageUrl: _firstImage,
                          ),
                        ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: product.images.isEmpty
                    ? _imagePlaceholder()
                    : Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _imagePlaceholder(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.6, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Color',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ColorSelector(
                      colors: ProductOptions.colors,
                      selectedColor: _selectedColor,
                      onColorSelected: (color) =>
                          setState(() => _selectedColor = color),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizeSelector(
                      sizes: ProductOptions.sizes,
                      selectedSize: _selectedSize,
                      onSizeSelected: (size) =>
                          setState(() => _selectedSize = size),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(text: 'Add to Cart', onPressed: _addToCart),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 60,
        color: Colors.grey.shade400,
      ),
    );
  }
}
