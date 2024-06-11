import 'package:flutter/material.dart';
import 'package:mydealer/services/navigation_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenido!'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('ALIAGA ORDONEZ SAUL IVAN'),
                      subtitle: Text('Usuario: V157  Ruta: RV158'),
                    ),
                  ],
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: const EdgeInsets.all(4),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: <Widget>[
                _buildStatCard(context, 'Pedidos', 1, '8',
                    [Colors.blue, Colors.blue[300]!]),
                _buildStatCard(context, 'Pedidos Pendientes', 2, '0',
                    [Colors.blueAccent, Colors.blueAccent[100]!]),
                _buildStatCard(context, 'Cobros', 3, '2',
                    [Colors.green, Colors.greenAccent[100]!]),
                _buildStatCard(context, 'Cobros Pendientes', 3, '1',
                    [Colors.redAccent, Colors.red]),
              ],
            ),
            _buildStatCardFlat('Gestiones', '2', Colors.teal),
            _buildStatCardFlat('Gestiones Pendientes', '0', Colors.grey),
            _buildStatCardFlat('Toma de GPS', '1', Colors.orange),
            _buildStatCardFlat('Ubicacion GPS', '0', Colors.red),
          ]),
        ));
  }

  Widget _buildStatCard(BuildContext context, String title, int index,
      String count, List<Color> colors) {
    return InkWell(
      onTap: () {
        Provider.of<NavigationProvider>(context, listen: false).currentIndex =
            index;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCardFlat(String title, String count, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color),
        title: Text(title, style: TextStyle(color: Colors.black)),
        trailing:
            Text(count, style: TextStyle(color: Colors.black, fontSize: 20.0)),
      ),
    );
  }
}
