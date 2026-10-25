import 'package:ecommerce_app_huma_volve/features/home/presentation/view/widgets/category_chip.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view/widgets/product_card.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view/widgets/profile_avatar.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/top_gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final ScrollController scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeCubit>().loadHomeData();
    scrollController = ScrollController();
    scrollController.addListener(_onListen);
  }

  void _onListen() {
    final pixels = scrollController.position.pixels; //current user position
    final max = scrollController.position.maxScrollExtent; // end position
    int triggerDistance = 200;
    if (pixels >= max - triggerDistance) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: TopGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: AppTheme.primary,
                            ),
                          ),
                          BlocBuilder<ProfileCubit, ProfileStates>(
                            builder: (context, state) => Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: ProfileAvatar(
                                bytes: state is ProfileSuccess
                                    ? state.profile.avatarBytes
                                    : null,
                                radius: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Explore',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 36, color: AppTheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Best trendy collection!',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontSize: 18, color: AppTheme.primary),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search clothes...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: const Icon(
                              size: 30,
                              Icons.search,
                              color: AppTheme.primary,
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: AppTheme.background,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<HomeCubit, HomeStates>(
                        buildWhen: ((previous, current) {
                          if (current is ProductsLoading ||
                              current is ProductsSuccess ||
                              current is ProductsError ||
                              current is ProductsLoadingError ||
                              current is ProductsLoadingMore) {
                            return false;
                          }
                          return true;
                        }),
                        builder: (BuildContext context, state) {
                          if (state is CategoriesLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CategoriesError) {
                            return Center(child: Text(state.errorMessage));
                          } else if (state is CategoriesSuccess) {
                            final categories = state.categories;
                            return SizedBox(
                              height: 44,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return CategoryChip(
                                    label: category.name ?? "all",
                                    isSelected: _selectedCategoryIndex == index,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryIndex = index;
                                      });
                                      context
                                          .read<HomeCubit>()
                                          .getProductsByCategoryId(
                                            category.id!,
                                          );
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: ((previous, current) {
                  if (current is ProductsLoadingError ||
                      current is ProductsLoadingMore) {
                    return false;
                  }
                  return true;
                }),
                builder: (BuildContext context, state) {
                  if (state is ProductsLoading) {
                    return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ProductsError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.errorMessage)),
                    );
                  } else if (state is ProductsSuccess) {
                    final products = state.products;
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCard(productModel: products[index]);
                        }, childCount: products.length),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                },
              ),
              BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  if (state is ProductsLoadingMore) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox(height: 24));
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
