import 'dart:convert';

class AuthModel {
  final String email;
  final String fullname;
  final String nickname;
  final String profile;
  
  AuthModel({
    required this.email,
    required this.fullname,
    required this.nickname,
    required this.profile,
  });

  AuthModel copyWith({
    String? email,
    String? fullname,
    String? nickname,
    String? profile,
  }) {
    return AuthModel(
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      nickname: nickname ?? this.nickname,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullname': fullname,
      'nickname': nickname,
      'profile': profile,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      email: map['email'],
      fullname: map['fullname'],
      nickname: map['nickname'],
      profile: map['profile'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) => AuthModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthModel(email: $email, fullname: $fullname, nickname: $nickname, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AuthModel &&
      other.email == email &&
      other.fullname == fullname &&
      other.nickname == nickname &&
      other.profile == profile;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      fullname.hashCode ^
      nickname.hashCode ^
      profile.hashCode;
  }
}
