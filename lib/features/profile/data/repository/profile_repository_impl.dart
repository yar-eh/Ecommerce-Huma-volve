import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/profile_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/models/profile_model.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/profile_entity.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource profileLocalDataSource;
  ProfileRepositoryImpl(this.profileLocalDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profile = await profileLocalDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> saveProfile(
    ProfileEntity profile,
  ) async {
    try {
      await profileLocalDataSource.saveProfile(ProfileModel.fromEntity(profile));
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
