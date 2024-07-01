import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/utils/app_constants.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelperCustomer {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ClientDB.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Clientes("
          "codrutadet INTEGER PRIMARY KEY,"
          "codcliente TEXT,"
          "coddireccionenvio TEXT,"
          "cedularuc TEXT,"
          "cliente_nombre TEXT,"
          "direccion TEXT,"
          "latitud REAL,"
          "longitud REAL,"
          "limitecredito REAL,"
          "saldopendiente REAL"
          ")");
    });
  }

  Future<void> insertCliente(Map<String, dynamic> clienteData) async {
    final db = await database;
    // Suponiendo que 'codcliente' es la clave por la que quieres buscar.
    var existingClient = await db.query(
      'Clientes',
      where: 'codrutadet = ?',
      whereArgs: [clienteData['codrutadet']],
    );

    if (existingClient.isNotEmpty) {
      // Cliente existe, actualizamos sus datos.
      await db.update(
        'Clientes',
        clienteData,
        where: 'codrutadet = ?',
        whereArgs: [clienteData['codrutadet']],
      );
    } else {
      // Cliente no existe, insertamos un nuevo registro.
      await db.insert('Clientes', clienteData);
    }
  }

  Future<List<Customer>> getCustomers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Clientes');

    return List.generate(maps.length, (i) {
      return Customer.fromJson(maps[i]);
    });
  }

  Future<void> downloadClientes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codVendedor = prefs.getString('codvendedor');
    final url = AppConstants.baseUrl + AppConstants.curtomerUri + codVendedor!;
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> clientes = jsonDecode(response.body)['datos'];
      for (var cliente in clientes) {
        await insertCliente(cliente);
      }
      print("Clientes descargados y guardados localmente.");
    } else {
      throw Exception('Failed to download clients');
    }
  }
}
