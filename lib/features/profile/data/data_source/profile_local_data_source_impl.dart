import 'dart:convert';

import 'package:ecommerce_app_huma_volve/core/storage/user_session.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/profile_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _key = 'profile';

  @override
  Future<ProfileModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = await UserSession.getCurrentUser();
    final raw = prefs.getString(_keyFor(email));
    if (raw != null) {
      return ProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    // first time for this user: only the email is known (the name starts as
    // the part before the @ and can be changed in Edit Profile)
    if (email == null) return const ProfileModel();
    return ProfileModel(name: email.split('@').first, email: email);
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final email = UserSession.normalize(profile.email);
    await prefs.setString(_keyFor(email), jsonEncode(profile.toJson()));
  }

  String _keyFor(String? email) =>
      (email == null || email.isEmpty) ? _key : '${_key}_$email';
}
