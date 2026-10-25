import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/profile_entity.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repository/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository profileRepository;
  SaveProfileUseCase(this.profileRepository);

  Future<Either<Failure, ProfileEntity>> invoke(ProfileEntity profile) =>
      profileRepository.saveProfile(profile);
}
