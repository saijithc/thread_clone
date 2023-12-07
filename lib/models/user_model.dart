class UserModel {
  final String? uid;
  final String? email;
  final String? username;
  final String? bio;
  final String? profilePic;
  final List? followers;
  final List? following;

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.bio,
    this.profilePic,
    this.followers,
    this.following,
  });
  //this method will convert the userdata into a json object
  //while storing the data
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': username,
      'bio': bio,
      'profilePic': profilePic,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(
      bio: json['bio'],
      email: json['email'],
      followers: json['followers'],
      following: json['following'],
      profilePic: json['profilePic'],
      uid: json['uid'],
      username: json['userName'],
    );
  }
}
