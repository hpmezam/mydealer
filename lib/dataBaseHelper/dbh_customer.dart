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
    String path = join(documentsDirectory.path, "myDealerDB2.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE Clientes(
          codrutadet INTEGER PRIMARY KEY,
          codcliente TEXT,
          coddireccionenvio TEXT,
          cedularuc TEXT,
          cliente_nombre TEXT,
          direccion TEXT,
          latitud REAL,
          longitud REAL,
          limitecredito REAL,
          saldopendiente REAL,
          vencido INTEGER
          );""");
      await db.execute("""
      CREATE TABLE AllClientes(
        codcliente TEXT,
        codtipocliente TEXT,
        nombre TEXT,
        email TEXT,
        password TEXT,
        pais TEXT,
        provincia TEXT,
        ciudad TEXT,
        codvendedor TEXT,
        codformapago TEXT,
        estado TEXT,
        limitecredito REAL, 
        saldopendiente REAL,
        vencido REAL,
        cedularuc TEXT, 
        codlistaprecio TEXT,
        calificacion TEXT,
        nombrecomercial TEXT,
        login TEXT
      );""");
    });
  }

  Future<void> insertCliente(Map<String, dynamic> clienteData) async {
    final db = await database;
    var existingClient = await db.query(
      'Clientes',
      where: 'codrutadet = ?',
      whereArgs: [clienteData['codrutadet']],
    );
    if (existingClient.isNotEmpty) {
      await db.update(
        'Clientes',
        clienteData,
        where: 'codrutadet = ?',
        whereArgs: [clienteData['codrutadet']],
      );
    } else {
      await db.insert('Clientes', clienteData);
    }
  }

  Future<void> insertAllCliente(Map<String, dynamic> clienteData) async {
    final db = await database;
    var existingClient = await db.query(
      'AllClientes',
      where: 'codcliente = ?',
      whereArgs: [clienteData['codcliente']],
    );
    if (existingClient.isNotEmpty) {
      await db.update(
        'AllClientes',
        clienteData,
        where: 'codcliente = ?',
        whereArgs: [clienteData['codcliente']],
      );
    } else {
      await db.insert('AllClientes', clienteData);
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
    String? codRuta = prefs.getString('codruta');
    final url = AppConstants.baseUrl +
        AppConstants.curtomerUri +
        codVendedor! +
        codRuta!;
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

  Future<void> downloadAllClientes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codVendedor = prefs.getString('codvendedor');
    final url = AppConstants.baseUrl + AppConstants.curtomerUri + codVendedor!;
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> allClientes = jsonDecode(response.body)['datos'];
      for (var cliente in allClientes) {
        await insertAllCliente(cliente);
      }
      print("Todos los Clientes descargados y guardados localmente.");
    } else {
      throw Exception('Failed to download clients');
    }
  }
}
