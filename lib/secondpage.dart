import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqllite/service.dart';

class DetailPage extends StatelessWidget {
  final Student student;
  const DetailPage({super.key, required this.student});
  Widget _buildAvatar(Student student) {
    if (student.webImage != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: MemoryImage(student.webImage!),
      );
    } else if (student.imagePath != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(student.imagePath!)),
      );
    } else {
      return const CircleAvatar(
        radius: 40,
        child: Icon(Icons.person,color: Colors.teal,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _buildAvatar(student),
                ),
                const SizedBox(height: 24),
                _buildDetailTile(Icons.person, "Name", student.name),
                const Divider(),
                 _buildDetailTile(Icons.school, "Class", student.studentClass),
                const Divider(),
                _buildDetailTile(Icons.book, "Roll No", student.roll),
                const Divider(),
                _buildDetailTile(Icons.location_on, "Address", student.address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
