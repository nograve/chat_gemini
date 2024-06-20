
class UserData {
  UserData({
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
