class MechanicRegisterAuthModel {
  final String uid;
  final String name;
  final String mobile;
  final String email;
  final String profileUrl;
  final String location;

  MechanicRegisterAuthModel({
    required this.uid,
    required this.name,
    required this.mobile,
    required this.email,
    required this.profileUrl,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'profileUrl': profileUrl,
      'location': location
    };
  }

  factory MechanicRegisterAuthModel.fromMap(Map<String, dynamic> map) {
    return MechanicRegisterAuthModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      location: map['location'] ?? '',
    );
  }
}
