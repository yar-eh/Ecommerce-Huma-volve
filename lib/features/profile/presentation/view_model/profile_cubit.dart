import 'dart:typed_data';

import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/profile_entity.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/save_profile_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/view_model/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final GetProfileUseCase getProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.saveProfileUseCase,
  }) : super(ProfileInitial());

  ProfileEntity? get _currentProfile {
    final current = state;
    return current is ProfileSuccess ? current.profile : null;
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase.invoke();
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfileError(failure.failureMessage)),
      (profile) => emit(ProfileSuccess(profile)),
    );
  }

  /// Sign up: a new account starts with a fresh profile built from
  /// the name and email typed at sign up.
  Future<void> startProfile({
    required String name,
    required String email,
  }) async {
    await _save(ProfileEntity(name: name, email: email));
  }

  /// Returns true when the profile was saved.
  Future<bool> updateDetails({
    required String name,
    required String phone,
    required String address,
  }) async {
    final current = _currentProfile;
    if (current == null) return false;
    return _save(current.copyWith(name: name, phone: phone, address: address));
  }

  Future<void> updateAvatar(Uint8List bytes) async {
    final current = _currentProfile;
    if (current == null) return;
    await _save(current.copyWith(avatarBytes: bytes));
  }

  Future<bool> _save(ProfileEntity profile) async {
    final result = await saveProfileUseCase.invoke(profile);
    if (isClosed) return false;
    return result.fold(
      (failure) => false, // keep showing the current profile
      (saved) {
        emit(ProfileSuccess(saved));
        return true;
      },
    );
  }
}
