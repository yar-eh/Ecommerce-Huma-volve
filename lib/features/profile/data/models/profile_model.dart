import 'dart:convert';

import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.name,
    super.email,
    super.phone,
    super.address,
    super.avatarBytes,
  });

  factory ProfileModel.fromEntity(ProfileEntity profile) => ProfileModel(
    name: profile.name,
    email: profile.email,
    phone: profile.phone,
    address: profile.address,
    avatarBytes: profile.avatarBytes,
  );

  ProfileModel.fromJson(Map<String, dynamic> json)
    : super(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        avatarBytes: json['avatar'] != null ? base64Decode(json['avatar']) : null,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'avatar': avatarBytes == null ? null : base64Encode(avatarBytes!),
  };
}
