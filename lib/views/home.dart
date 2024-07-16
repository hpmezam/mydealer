import 'package:flutter/material.dart';
import 'package:mydealer/services/navigation_provider.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  Future<Map<String, String?>> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString('nombre');
    String? login = prefs.getString('login');
    String? codruta = prefs.getString('codruta');
    return {'nombre': nombre, 'login': login, 'codruta': codruta};
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: <Widget>[
        FutureBuilder<Map<String, String?>>(
          future: loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeButton),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text(
                                snapshot.data!['nombre'] ?? 'No disponible'),
                            subtitle: Text("Usuario: " +
                                (snapshot.data!['login'] ?? 'No disponible') +
                                " Ruta: " +
                                (snapshot.data!['codruta'] ?? 'No disponible')),
                          ),
                        ],
                      )),
                );
              } else {
                return Text('Usuario no disponible!');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: (1 / .65),
          shrinkWrap: true,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: <Widget>[
            _buildStatCard(
                context, 'Pedidos', 1, '8', [Colors.blue, Colors.blue[300]!]),
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
