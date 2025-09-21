import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqllite/service.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._init();
  static Database? _database;

  DataBaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('student.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE student (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        roll TEXT NOT NULL,
        class TEXT NOT NULL,
        address TEXT NOT NULL,
        imagePath TEXT,
        webImage BLOB
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await instance.database;
    return await db.insert('student', student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await instance.database;
    final result = await db.query('student');
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete('student', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllStudents() async {
    final db = await instance.database;
    return await db.delete('student');
  }
  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return await db.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}
