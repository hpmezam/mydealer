import 'package:flutter/material.dart';
import 'package:mydealer/dataBaseHelper/dbh_customer.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final List<Map<String, String>> data = [
    {"category": "Descargar Todo", "updateDate": "2021-10-04", "status": "OK"},
    {"category": "Clientes", "updateDate": "2021-10-04", "status": "OK"},
    {"category": "Pedidos", "updateDate": "2021-10-04", "status": "OK"},
    {
      "category": "Cuentas Bancarias",
      "updateDate": "2021-10-04",
      "status": "OK"
    },
    {"category": "Stock", "updateDate": "2021-10-04", "status": "OK"},
  ];

  void downloadData(String category) {
    switch (category) {
      case "Clientes":
        downloadClients();
        break;
      default:
        print('Descargando datos para $category');
    }
  }

  void downloadClients() {
    print("Iniciando descarga de datos de clientes...");
    saveClients();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Datos de Clientes Descargados'),
       backgroundColor: Color.fromARGB(255, 30, 255, 0),
    ));
    print("Clientes Guardados ***************************************");
  }

  void saveClients() async {
    await DatabaseHelperCustomer().downloadClientes();
  }

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
                onPressed: () => downloadData(data[index]["category"]!),
              ),
            ),
          );
        },
      ),
    );
  }
}
