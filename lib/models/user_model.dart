class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final DateTime? birthDate;
  final String? skillLevel;
  final bool isAdmin;
  UserModel(
      {this.id,
      this.email,
      this.name,
      this.birthDate,
      this.skillLevel,
      this.isAdmin = false});
}
