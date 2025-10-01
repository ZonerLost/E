class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, id) {
    return ProfileModel(
      id: id,
      username: json['displayName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['photoURL'] ?? '',
    );
  }
}