class User {
  int id;
  String image;
  String name;
  String email;
  String phone;
  String aboutMeDescription;
  bool isVerified;
  String type;
  bool isDarkMode;

  User({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.aboutMeDescription,
    required this.isVerified,
    required this.type,
    required this.isDarkMode,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        id: int.parse(json['id']),
        image: json['image'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        aboutMeDescription: json['about'],
        isVerified: json['isVerified'] == 'true',
        type: json['type'],
        isDarkMode: json['isDarkMode'] == 'true',
      );

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'image': image,
        'name': name,
        'email': email,
        'about': aboutMeDescription,
        'phone': phone,
        'isVerified': isVerified.toString(),
        'type': type,
        'isDarkMode': isDarkMode.toString(),
      };
}
