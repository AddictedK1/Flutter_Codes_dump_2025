class UserProfile {
  String name;
  String email;
  String bio;
  String phoneNumber;

  UserProfile({
    this.name = '',
    this.email = '',
    this.bio = '',
    this.phoneNumber = '',
  });

  bool get isComplete {
    return name.isNotEmpty && email.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
