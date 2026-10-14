import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_request_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/repository/signup_repository.dart';

class SignupUseCase {
  final SignupRepository signupRepository;
  SignupUseCase(this.signupRepository);

  Future<Either<Failure, SignupEntity>> invoke(SignupRequestEntity request) =>
      signupRepository.signUp(request);
}
