import 'package:flutter/material.dart';
import 'package:mydealer/localization/language_constrants.dart';
// import 'package:mydealer/models/home_model.dart';
import 'package:mydealer/services/navigation_provider.dart';
import 'package:mydealer/utils/app_constants.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mydealer/widgets/home/order_type_button_widget.dart';
import 'package:mydealer/widgets/home/order_type_button_head_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePayments {
  final int realizados;
  final int pendientes;

  HomePayments({required this.realizados, required this.pendientes});

  factory HomePayments.fromJson(Map<String, dynamic> json) {
    return HomePayments(
      realizados: json['datos']['realizados'] as int,
      pendientes: json['datos']['pendientes'] as int,
    );
  }
}

Future<HomePayments> fetchPayment() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? codvendedor = prefs.getString('codvendedor');
  String baseUrl =
      '${AppConstants.baseUrl}${AppConstants.numberOrders}/$codvendedor';

  try {
    final response = await http.get(Uri.parse(baseUrl));
    final data = json.decode(response.body) as Map<String, dynamic>;
    return HomePayments.fromJson(data);
  } catch (e) {
    print('Error fetching customers: $e');
    return HomePayments(
        realizados: 0, pendientes: 0); // Valor por defecto en caso de error
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<HomePayments> _futurePayments;
  late HomePayments _payments;

  @override
  void initState() {
    super.initState();
    _futurePayments = fetchPayment();
  }

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
                      ),
                    ),
                  );
                } else {
                  return Text('Usuario no disponible!');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          FutureBuilder<HomePayments>(
            future: _futurePayments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                _payments = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeSmall,
                      0,
                      Dimensions.paddingSizeSmall,
                      Dimensions.fontSizeSmall),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: (1 / .65),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      OrderTypeButtonHeadWidget(
                        color: ColorResources.mainCardOneColor(context),
                        text: getTranslated('orders', context),
                        index: 1,
                        subText: '',
                        numberOfOrder: _payments.realizados,
                      ),
                      OrderTypeButtonHeadWidget(
                        color: ColorResources.mainCardTwoColor(context),
                        text: getTranslated('orders_pending', context),
                        index: 2,
                        numberOfOrder: _payments.pendientes,
                        subText: '',
                      ),
                      OrderTypeButtonHeadWidget(
                        color: ColorResources.mainCardThreeColor(context),
                        text: getTranslated('charges', context),
                        index: 7,
                        subText: '',
                        numberOfOrder: _payments.realizados,
                      ),
                      OrderTypeButtonHeadWidget(
                        color: ColorResources.mainCardFourColor(context),
                        text: getTranslated('chargesPending', context),
                        index: 8,
                        subText: '',
                        numberOfOrder: _payments.pendientes,
                      ),
                    ],
                  ),
                );
              } else {
                return Text('No hay datos disponibles');
              }
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: ColorResources.getPrimary(context).withOpacity(.05),
                    spreadRadius: -3,
                    blurRadius: 12,
                    offset: Offset.fromDirection(0, 6))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeExtraSmall,
                      Dimensions.paddingSizeDefault,
                      0),
                  child: Text(
                    getTranslated('news', context)!,
                    style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OrderTypeButtonWidget(
                      color: ColorResources.mainCardThreeColor(context),
                      icon: Images.address,
                      text: getTranslated('routes', context),
                      index: 1,
                      numberOfOrder: 5,
                    ),
                    OrderTypeButtonWidget(
                      color: ColorResources.mainCardThreeColor(context),
                      icon: Images.orderSummery,
                      text: getTranslated('diary', context),
                      index: 2,
                      numberOfOrder: 3,
                    ),
                    OrderTypeButtonWidget(
                      color: ColorResources.mainCardThreeColor(context),
                      icon: Images.destinationMarker,
                      text: getTranslated('gps', context),
                      index: 2,
                      numberOfOrder: 8,
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
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

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
