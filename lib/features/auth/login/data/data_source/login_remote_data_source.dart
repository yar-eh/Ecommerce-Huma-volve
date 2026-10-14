import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel> login({required String email, required String password});
}
