import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqllite/details.dart';
import 'package:sqllite/secondpage.dart';
import 'package:sqllite/service.dart';
import 'databasehelper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Student> _students = [];          
  List<Student> _filteredStudents = []; 
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchStudents() async {
    _students = await DataBaseHelper.instance.getAllStudents();
    _filteredStudents = List.from(_students);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
  final query = _searchController.text.toLowerCase();

  setState(() {
    _filteredStudents = _students.where((student) {
      final name = student.name.toLowerCase();
      final roll = student.roll.toLowerCase();
      return name.contains(query) || roll.contains(query);
    }).toList();
  });
}

  void _deleteStudent(int id) async {
    await DataBaseHelper.instance.deleteStudent(id);
    fetchStudents();
  }

  void _deleteAllStudents() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete All"),
        content: const Text("Are you sure you want to delete all students?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await DataBaseHelper.instance.deleteAllStudents();
              Navigator.pop(context);
              fetchStudents();
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text("Delete All"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Student student) {
    if (student.webImage != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: MemoryImage(student.webImage!),
      );
    } else if (student.imagePath != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: FileImage(File(student.imagePath!)),
      );
    } else {
      return const CircleAvatar(
        radius: 24,
        child: Icon(Icons.person),
      );
    }
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _buildAvatar(student),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("Class: ${student.studentClass}"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(student: student)),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentsDetailState(
                    existingStudent: student,
                  ),
                ),
              );
              fetchStudents();
            } else if (value == 'delete') {
              _deleteStudent(student.id!);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MySchool",style:TextStyle(color: Colors.white,  fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: _deleteAllStudents,
            icon: const Icon(Icons.delete_forever,color:Colors.white,),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name or roll number",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      "No students",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) =>
                        _buildStudentCard(_filteredStudents[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentsDetailState()),
          );
          fetchStudents();
        },
        label: const Text("Add Student",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
