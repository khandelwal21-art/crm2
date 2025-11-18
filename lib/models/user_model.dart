class UserModel{
  final int id;
  final String username;
  final String name;
  final String email;
  final String? profileImage;
  final bool isAdmin;
  final bool isTeamLeader;
  final bool isStaffNew;
  final bool isFreelancer;
  final String token;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.profileImage,
    required this.isAdmin,
    required this.isTeamLeader,
    required this.isStaffNew,
    required this.isFreelancer,
    required this.token,}
      );


  factory UserModel.fromJson(Map<String,dynamic> json ){
    return UserModel(
      id:json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profile_image'],
      isAdmin: json['is_admin'],
      isTeamLeader: json['is_team_leader'],
      isStaffNew: json['is_staff_new'],
      isFreelancer: json['is_freelancer'],
      token: json['token_detail'],
    );
  }
  String get primaryRole{
    if (isAdmin) return 'admin';
    if (isTeamLeader) return 'team_leader';
    if (isStaffNew) return 'staff';
    if (isFreelancer) return 'freelancer';
    return 'guest';
  }
}