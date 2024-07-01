import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // Datos simulados para la tabla
  final List<Map<String, String>> data = [
    {"category": "Productos", "updateDate": "2021-10-04", "status": "OK"},
    {
      "category": "Lista de Precios",
      "updateDate": "2021-10-04",
      "status": "OK"
    },
    {"category": "Estado Cuenta", "updateDate": "2021-10-04", "status": "OK"},
    {
      "category": "Cuentas Bancarias",
      "updateDate": "2021-10-04",
      "status": "OK"
    },
    {"category": "Stock", "updateDate": "2021-10-04", "status": "OK"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Descarga Manual"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(data[index]["category"]!),
              subtitle: Text(
                  "Fecha de Actualización: ${data[index]["updateDate"]} - Estado: ${data[index]["status"]}"),
              trailing: IconButton(
                icon: Icon(Icons.download_rounded),
                onPressed: () {
                  print('Descargando datos para ${data[index]["category"]}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
