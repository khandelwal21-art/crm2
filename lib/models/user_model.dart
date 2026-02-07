class UserModel {
  final int id;
  final String username;
  final String? name;
  final String email;
  final String? mobile;
  final String? profileImage;
  final bool isSuperUser;
  final bool isAdmin;
  final bool isTeamLeader;
  final bool isStaffNew;
  final bool isFreelancer;
  final bool isItStaff;
  final String role;
  final DateTime? loginTime;
  final DateTime? logoutTime;
  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.mobile,
    this.profileImage,
    required this.isSuperUser,
    required this.isAdmin,
    required this.isTeamLeader,
    required this.isStaffNew,
    required this.isFreelancer,
    required this.isItStaff,
    required this.role,
    required this.loginTime,
    required this.logoutTime,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      profileImage: json['profile_image'],
      isSuperUser: json['is_superuser'],
      isAdmin: json['is_admin'],
      isTeamLeader: json['is_team_leader'],
      isStaffNew: json['is_staff_new'],
      isFreelancer: json['is_freelancer'],
      isItStaff: json['is_it_staff'],
      role: json['role'],
      loginTime: json['login_time'] != null ? DateTime.parse(json['login_time']) : null,
      logoutTime: json['logout_time'] != null ? DateTime.parse(json['logout_time']) : null,
      token: json['token_detail'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'mobile': mobile,
      'profile_image': profileImage,
      'is_superuser': isSuperUser,
      'is_admin': isAdmin,
      'is_team_leader': isTeamLeader,
      'is_staff_new': isStaffNew,
      'is_freelancer': isFreelancer,
      'is_it_staff': isItStaff,
      'role': role,
      'login_time': loginTime?.toIso8601String(),
      'logout_time': logoutTime?.toIso8601String(),
      'token_detail': token,
    };
  }

  String get primaryRole => role;
}
