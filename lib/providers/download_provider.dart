import 'package:flutter/material.dart';
import 'package:mydealer/dataBaseHelper/dbh_customer.dart';
import 'package:mydealer/dataBaseHelper/dbh_pedidos.dart';
import 'package:mydealer/widgets/download/download_item.dart';

class DownloadProvider with ChangeNotifier {
  List<DownloadItem> items = [
    DownloadItem(category: "Descargar Todo"),
    DownloadItem(category: "Todos los Clientes"),
    DownloadItem(category: "Clientes por Rutas"),
    DownloadItem(category: "Todos los Pedidos"),
    DownloadItem(category: "Pedidos Pendientes"),
    DownloadItem(category: "Cobros"),
    DownloadItem(category: "Cobros Pendientes"),
    DownloadItem(category: "Agendas"),
  ];

  List<DownloadItem> get allItems => items;

  void downloadData(BuildContext context, int index) async {
    final item = items[index];
    item.startDownload(); // Marca el ítem como en descarga
    try {
      switch (item.category) {
        case "Descargar Todo":
          await downloadClients(context, index);
          await downloadAllClients(context, index);
          await downloadOrders(context, index);
          break;
        case "Todos los Clientes":
          await downloadAllClients(context, index);
          break;
        case "Clientes por Rutas":
          await downloadClients(context, index);
          break;
        case "Todos los Pedidos":
          await downloadOrders(context, index);
          break;
        default:
          // Simula la descarga para otras categorías
          await Future.delayed(const Duration(seconds: 2));
          updateItem(context, index, true);
          break;
      }
    } catch (e) {
      updateItem(context, index, false);
    }
  }

  Future<void> downloadClients(BuildContext context, int index) async {
    try {
      await DatabaseHelperCustomer().downloadClientes();
      updateItem(context, index, true);
    } catch (e) {
      updateItem(context, index, false);
    }
  }

  Future<void> downloadAllClients(BuildContext context, int index) async {
    try {
      await DatabaseHelperCustomer().downloadAllClientes();
      updateItem(context, index, true);
    } catch (e) {
      updateItem(context, index, false);
    }
  }

  Future<void> downloadOrders(BuildContext context, int index) async {
    try {
      await DatabaseHelperOrders().downloadOrders();
      updateItem(context, index, true);
    } catch (e) {
      updateItem(context, index, false);
    }
  }

  void updateItem(BuildContext context, int index, bool success) {
    items[index].completeDownload(success);
    notifyListeners();
    if (success) {
      showDownloadSuccess(
          context, '${items[index].category} descargados correctamente.');
    } else {
      showDownloadError(
          context, 'Falló la descarga de ${items[index].category}.');
    }
  }

  void showDownloadSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void showDownloadError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
