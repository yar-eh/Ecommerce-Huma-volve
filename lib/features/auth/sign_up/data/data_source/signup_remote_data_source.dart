import '../models/signup_model.dart';
import '../models/signup_request_model.dart';

abstract class SignupRemoteDataSource {
  Future<SignupModel> signUp(SignupRequestModel request);
}
