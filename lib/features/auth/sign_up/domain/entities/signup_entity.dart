class SignupEntity {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;
  final String creationAt;
  final String updatedAt;

  const SignupEntity({
    this.id = 0,
    this.email = '',
    this.name = '',
    this.role = '',
    this.avatar = '',
    this.creationAt = '',
    this.updatedAt = '',
  });
}
