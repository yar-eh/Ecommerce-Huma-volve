import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repository/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../cart/presentation/view/cart_screen.dart';
import '../../home/presentation/view/home_screen.dart';
import '../../profile/presentation/view/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final ApiClient apiClient;
  late final HomeRemoteDataSource remoteDataSource;
  late final HomeRepository homeRepository;
  late final GetProductsUseCase getProductsUseCase;
  late final GetCategoriesUseCase getCategoriesUseCase;
  late final HomeCubit homeCubit;
  late final List<Widget> _screens;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    remoteDataSource = HomeRemoteDataSourceImpl(apiClient);
    homeRepository = HomeRepositoryImpl(remoteDataSource);
    getProductsUseCase = GetProductsUseCase(homeRepository);
    getCategoriesUseCase = GetCategoriesUseCase(homeRepository);
    homeCubit = HomeCubit(
      getProductsUseCase: getProductsUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
    );

    _screens = [
      BlocProvider.value(value: homeCubit, child: const HomeScreen()),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  static const double _height = 80;

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_filled),
    (icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart),
    (icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Center(
                      child: Icon(
                        i == currentIndex
                            ? _items[i].activeIcon
                            : _items[i].icon,
                        size: 32,
                        color: i == currentIndex
                            ? AppTheme.primary
                            : AppTheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
