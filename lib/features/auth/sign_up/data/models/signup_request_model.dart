import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_request_entity.dart';

class SignupRequestModel extends SignupRequestEntity {
  static const String defaultAvatar = "https://i.imgur.com/LDOO4Qs.jpg";

  const SignupRequestModel({
    required super.email,
    required super.name,
    required super.password,
  });

  factory SignupRequestModel.fromEntity(SignupRequestEntity entity) =>
      SignupRequestModel(
        email: entity.email,
        name: entity.name,
        password: entity.password,
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
    "password": password,
    "avatar": defaultAvatar,
  };
}
