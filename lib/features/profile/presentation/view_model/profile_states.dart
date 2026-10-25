import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileSuccess extends ProfileStates {
  final ProfileEntity profile;
  ProfileSuccess(this.profile);
}

class ProfileError extends ProfileStates {
  final String errorMessage;
  ProfileError(this.errorMessage);
}
