import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/data_source/signup_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/models/signup_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/models/signup_request_model.dart';

class SignupRemoteDataSourceImpl implements SignupRemoteDataSource {
  final ApiClient apiClient;
  SignupRemoteDataSourceImpl(this.apiClient);

  @override
  Future<SignupModel> signUp(SignupRequestModel request) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signUpEndpoint,
      data: request.toJson(),
    );
    return SignupModel.fromJson(response.data);
  }
}
