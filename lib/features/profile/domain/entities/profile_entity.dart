import 'dart:typed_data';

class ProfileEntity {
  final String name;
  final String email;
  final String phone;
  final String address;

  /// null until the user picks a picture (the UI shows a default avatar).
  final Uint8List? avatarBytes;

  const ProfileEntity({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.avatarBytes,
  });

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    Uint8List? avatarBytes,
  }) => ProfileEntity(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    avatarBytes: avatarBytes ?? this.avatarBytes,
  );
}
