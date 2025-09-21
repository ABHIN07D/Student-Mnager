import 'dart:typed_data';

class Student {
  final int? id;
  final String name;
  final String roll;
  final String studentClass;
  final String address;
  final String? imagePath;       
  final Uint8List? webImage;

  Student({
    this.id,
    required this.name,
    required this.roll,
    required this.studentClass,
    required this.address,
    this.imagePath,
    this.webImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll': roll,
      'class': studentClass,
      'address': address,
      'imagePath': imagePath,
      'webImage': webImage,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      roll: map['roll'],
      studentClass: map['class'],
      address: map['address'],
      imagePath: map['imagePath'],
      webImage: map['webImage'], 
    );
  }
}
