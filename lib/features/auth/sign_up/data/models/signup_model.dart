import 'package:ecommerce_app_huma_volve/features/auth/sign_up/domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  const SignupModel({
    super.id,
    super.email,
    super.name,
    super.role,
    super.avatar,
    super.creationAt,
    super.updatedAt,
  });

  SignupModel.fromJson(Map<String, dynamic> json)
    : super(
        id: json['id'] ?? 0,
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        role: json['role'] ?? '',
        avatar: json['avatar'] ?? '',
        creationAt: json['creationAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );
}
