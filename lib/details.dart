import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqllite/service.dart';
import 'databasehelper.dart';

class StudentsDetailState extends StatefulWidget {
  final Student? existingStudent;
  const StudentsDetailState({super.key, this.existingStudent});

  @override
  State<StudentsDetailState> createState() => _StudentsDetailStateState();
}

class _StudentsDetailStateState extends State<StudentsDetailState> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _classController = TextEditingController();
  final _addressController = TextEditingController();
  Uint8List? _webImage;
  String? _imagePath;


  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      final s = widget.existingStudent!;
      _nameController.text = s.name;
      _rollController.text = s.roll;
      _classController.text = s.studentClass;
      _addressController.text = s.address;
      _webImage = s.webImage;
      _imagePath = s.imagePath;
    }
  }
   Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _imagePath = picked.path;
        });
      }
    }
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.existingStudent?.id, 
        name: _nameController.text.trim(),
        roll: _rollController.text.trim(),
        studentClass: _classController.text.trim(),
        address: _addressController.text.trim(),
        webImage: _webImage,
        imagePath: _imagePath,
      );

      if (widget.existingStudent == null) {
        await DataBaseHelper.instance.insertStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student Added")),
        );
      } else {
        await DataBaseHelper.instance.updateStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student Updated")),
        );
      }

      Navigator.pop(context, true); 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _classController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon,color: Colors.teal,),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    );
  }
  Widget _buildImageAvatar() {
    if (_webImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(_webImage!),
      );
    } else if (_imagePath != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(File(_imagePath!)),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        child: Icon(Icons.person, size: 50,color: Colors.teal,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingStudent != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Student" : "Add Student",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    _buildImageAvatar(),
                    const SizedBox(height: 8),
                    Text(
                      "Tap to Add photo",
                      style: TextStyle(color: Colors.teal.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration("Name", Icons.person),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rollController,
                decoration:
                    _buildInputDecoration("Roll No", Icons.numbers_rounded),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Enter roll number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _classController,
                decoration: _buildInputDecoration("Class", Icons.class_),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Enter class' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: _buildInputDecoration("Address", Icons.home),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isEdit ? Icons.update : Icons.save),
                  label: Text(isEdit ? "Update Student" : "Save Student"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _saveStudent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
