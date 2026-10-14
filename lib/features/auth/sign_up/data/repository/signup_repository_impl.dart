import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/data_source/signup_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/models/signup_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_request_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/repository/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final SignupRemoteDataSource signupRemoteDataSource;
  SignupRepositoryImpl(this.signupRemoteDataSource);

  @override
  Future<Either<Failure, SignupEntity>> signUp(
    SignupRequestEntity request,
  ) async {
    try {
      final user = await signupRemoteDataSource.signUp(
        SignupRequestModel.fromEntity(request),
      );
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
