import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/view/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/orders/presentation/view/orders_screen.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view/edit_profile_screen.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view/widgets/profile_avatar.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view/widgets/profile_menu_item.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_states.dart';
import 'package:ecommerce_app_huma_volve/features/wishlist/presentation/view/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/storage/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAvatar(BuildContext context) async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!context.mounted) return;
    context.read<ProfileCubit>().updateAvatar(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileError) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is! ProfileSuccess) {
              return const Center(child: CircularProgressIndicator());
            }
            final profile = state.profile;
            final avatar = profile.avatarBytes;
            return Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => _pickAvatar(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ProfileAvatar(bytes: avatar, radius: 56),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: AppTheme.background,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name.isEmpty ? 'Guest' : profile.name,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (profile.email.isNotEmpty)
                  Text(
                    profile.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      ProfileMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrdersScreen(),
                          ),
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WishlistScreen(),
                          ),
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        isDestructive: true,
                        onTap: () async {
                          await UserSession.clear();
                          SecureStorage.deleteTokens();
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => const LoginScreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
