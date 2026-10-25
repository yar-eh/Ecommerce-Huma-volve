import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/custom_text_field.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final String _email;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    final profile = state is ProfileSuccess ? state.profile : null;
    _email = profile?.email ?? '';
    nameController = TextEditingController(text: profile?.name ?? '');
    // empty the first time, so the hint text is shown
    phoneController = TextEditingController(text: profile?.phone ?? '');
    addressController = TextEditingController(text: profile?.address ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final saved = await context.read<ProfileCubit>().updateDetails(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? 'Profile updated!' : 'Could not save your profile',
        ),
        backgroundColor: saved ? Colors.green : AppTheme.primary,
      ),
    );
    if (saved) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: AppTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _ReadOnlyField(icon: Icons.email_outlined, text: _email),
              const SizedBox(height: 20),
              CustomTextField(
                controller: phoneController,
                hintText: 'Enter your phone number here',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final phone = value?.trim() ?? '';
                  if (phone.isNotEmpty &&
                      !RegExp(r'^[0-9+\s-]{7,15}$').hasMatch(phone)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: addressController,
                hintText: 'Enter your address here',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'Save Changes',
                isLoading: _isSaving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a value the user cannot edit (the email used to sign in).
class _ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReadOnlyField({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
