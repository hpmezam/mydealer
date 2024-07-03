import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User("
          "codvendedor TEXT PRIMARY KEY,"
          "nombre TEXT,"
          "email TEXT,"
          "login TEXT,"
          "estado TEXT,"
          "mac_pend_asignacion TEXT,"
          "fecha_requerimiento TEXT,"
          "estado_autorizacion TEXT,"
          "fecha_autorizacion TEXT,"
          "mac TEXT,"
          "codruta TEXT"
          ")");
    });
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;
    // Primero, intentar actualizar el usuario existente.
    int count = await db.update(
      "User",
      userData,
      where: 'codvendedor = ?',
      whereArgs: [userData['codvendedor']],
    );
    // Si no se actualiza ningún registro, significa que el usuario no existe.
    if (count == 0) {
      // Entonces, insertamos el nuevo usuario.
      await db.insert("User", userData);
    }
  }

  Future<dynamic> getUser() async {
    final db = await database;
    var res = await db.query("User");
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String login) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      "User",
      where: 'login = ?',
      whereArgs: [login],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
