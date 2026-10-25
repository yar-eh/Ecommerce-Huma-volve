import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/core/storage/user_session.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/login_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/entities/login_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl(this.loginRemoteDataSource);

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginData = await loginRemoteDataSource.login(
        email: email,
        password: password,
      );
      await SecureStorage.saveAccessToken(loginData.accessToken);
      await SecureStorage.saveRefreshToken(loginData.refreshToken);
      await UserSession.setCurrentUser(email); // data is saved per user
      return Right(loginData);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
