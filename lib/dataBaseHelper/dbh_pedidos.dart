import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mydealer/utils/app_constants.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelperOrders {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "myDealerDB.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
      CREATE TABLE Pedidos (
        srorden INTEGER PRIMARY KEY,
        pedido_renegociado TEXT,
        codsucursal INTEGER,
        entregapedido TEXT,
        tipopedido TEXT,
        codcliente TEXT,
        fecha TEXT,
        fechaweb TEXT,
        codformaenvio INTEGER,
        codformapago INTEGER,
        idorden TEXT,
        codvendedor INTEGER,
        coddireccionenvio TEXT,
        numordenerp TEXT,
        observaciones TEXT,
        loginusuario TEXT,
        referencia1 TEXT,
        referencia2 TEXT,
        subtotal REAL,
        descuento REAL,
        impuesto REAL,
        total REAL,
        estado TEXT,
        origen TEXT,
        errorws TEXT,
        fechamovil TEXT,
        fechaenvioerp TEXT,
        orden_estado TEXT,
        cliente_codcliente TEXT,
        cliente_nombre TEXT,
        cliente_email TEXT,
        cliente_pais TEXT,
        cliente_ciudad TEXT,
        cliente_estado TEXT,
        cliente_cedularuc TEXT,
        cliente_codlistaprecio TEXT,
        cliente_calificacion TEXT
      );""");
      await db.execute("""
      CREATE TABLE DetallePedidos (
        numlinea INTEGER,
        idorden TEXT,
        srorden INTEGER,
        codproducto TEXT,
        cantidad INTEGER,
        precio REAL,
        descuento REAL,
        subtotal REAL,
        orden TEXT,
        descuentoval REAL,
        impuesto REAL,
        total REAL,
        codunidadmedida INTEGER,
        descadicional REAL,
        porcdescuentoadic REAL,
        porcdescuentotal REAL,
        porcimpuesto TEXT,  
        nombre TEXT,
        umv INTEGER,
        estado TEXT,
        codtipoproducto TEXT,
        costo REAL,
        unidadmedida TEXT,
        codmarca TEXT,
        porcdescuento TEXT,
        imagen  TEXT,
        categoria TEXT
      );""");
    });
  }

  Future<void> downloadOrders() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? codVendedor = prefs.getString('codvendedor');
      final url = AppConstants.baseUrl +
          AppConstants.allOrdersByVendedor +
          codVendedor!;
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body)['datos'];
        for (var order in orders) {
          await insertOrUpdateOrder(order);
        }
      } else {
        throw Exception('Failed to download Orders');
      }
    } catch (e) {
      throw Exception('Error occurred while downloading orders: $e');
    }
  }

  Future<void> insertOrUpdateOrder(Map<String, dynamic> orderData) async {
    final Database db = await database;

    // Verifica si el pedido existe.
    List<Map> existingOrder = await db.query(
      'Pedidos',
      where: 'srorden = ?',
      whereArgs: [orderData['srorden']],
    );

    // Crea un mapa con la información del detalle para usar en insertar o actualizar.
    Map<String, dynamic> dataForPedidos = {
      'srorden': orderData['srorden'],
      'pedido_renegociado': orderData['pedido_renegociado'],
      'codsucursal': orderData['codsucursal'],
      'entregapedido': orderData['entregapedido'],
      'tipopedido': orderData['tipopedido'],
      'codcliente': orderData['codcliente'],
      'fecha': orderData['fecha'],
      'fechaweb': orderData['fechaweb'],
      'codformaenvio': orderData['codformaenvio'],
      'codformapago': orderData['codformapago'],
      'idorden': orderData['idorden'],
      'codvendedor': orderData['codvendedor'],
      'coddireccionenvio': orderData['coddireccionenvio'],
      'numordenerp': orderData['numordenerp'],
      'observaciones': orderData['observaciones'],
      'loginusuario': orderData['loginusuario'],
      'referencia1': orderData['referencia1'],
      'referencia2': orderData['referencia2'],
      'subtotal': orderData['subtotal'],
      'descuento': orderData['descuento'],
      'impuesto': orderData['impuesto'],
      'total': orderData['total'],
      'estado': orderData['estado'],
      'origen': orderData['origen'],
      'errorws': orderData['errorws'],
      'fechamovil': orderData['fechamovil'],
      'fechaenvioerp': orderData['fechaenvioerp'],
      'orden_estado': orderData['orden_estado'],
      'cliente_codcliente': orderData['cliente_codcliente'],
      'cliente_nombre': orderData['cliente_nombre'],
      'cliente_email': orderData['cliente_email'],
      'cliente_pais': orderData['cliente_pais'],
      'cliente_ciudad': orderData['cliente_ciudad'],
      'cliente_estado': orderData['cliente_estado'],
      'cliente_cedularuc': orderData['cliente_cedularuc'],
      'cliente_codlistaprecio': orderData['cliente_codlistaprecio'],
      'cliente_calificacion': orderData['cliente_calificacion'],
    };

    // Actualiza o inserta el pedido según corresponda.
    if (existingOrder.isNotEmpty) {
      await db.update(
        'Pedidos',
        dataForPedidos,
        where: 'srorden = ?',
        whereArgs: [orderData['srorden']],
      );
    } else {
      await db.insert('Pedidos', dataForPedidos);
    }

    // Procesa cada detalle del pedido.
    for (var detail in orderData['detalles']) {
      // Verifica si el detalle existe para el 'srorden' dado.
      List<Map> existingDetail = await db.query(
        'DetallePedidos',
        where: 'srorden = ? AND numlinea = ?',
        whereArgs: [detail['srorden'], detail['numlinea']],
      );

      Map<String, dynamic> detailData = {
        'numlinea': detail['numlinea'],
        'idorden': detail['idorden'],
        'srorden': detail['srorden'],
        'codproducto': detail['codproducto'],
        'cantidad': detail['cantidad'],
        'precio': detail['precio'],
        'descuento': detail['descuento'],
        'subtotal': detail['subtotal'],
        'orden': detail['orden'],
        'descuentoval': detail['descuentoval'],
        'impuesto': detail['impuesto'],
        'total': detail['total'],
        'codunidadmedida': detail['codunidadmedida'],
        'descadicional': detail['descadicional'],
        'porcdescuentoadic': detail['porcdescuentoadic'],
        'porcdescuentotal': detail['porcdescuentotal'],
        'porcimpuesto': detail['porcimpuesto'],
        'nombre': detail['nombre'],
        'umv': detail['umv'],
        'estado': detail['estado'],
        'codtipoproducto': detail['codtipoproducto'],
        'costo': detail['costo'],
        'unidadmedida': detail['unidadmedida'],
        'codmarca': detail['codmarca'],
        'porcdescuento': detail['porcdescuento'],
        'imagen': detail['imagen'],
        'categoria': detail['categoria']
      };

      // Actualiza o inserta el detalle según corresponda.
      if (existingDetail.isNotEmpty) {
        await db.update(
          'DetallePedidos',
          detailData,
          where: 'srorden = ? AND numlinea = ?',
          whereArgs: [detail['srorden'], detail['numlinea']],
        );
      } else {
        await db.insert('DetallePedidos', detailData);
      }
    }
  }
}
