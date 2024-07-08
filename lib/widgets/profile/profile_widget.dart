import 'package:flutter/material.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/utils/app_constants.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:mydealer/widgets/menu/custom_image_widget.dart';
import 'package:mydealer/widgets/profile/theme_changer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
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
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white24,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall),
                    child: Stack(
                      children: [
                        FutureBuilder<Map<String, String?>>(
                          future: loadUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.paddingSizeMedium,
                                      left: Dimensions.paddingSizeExtraSmall,
                                      right: Dimensions.paddingSizeExtraSmall),
                                  child: Container(
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: ColorResources.getPrimary(context),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.paddingSizeSmall)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeSmall),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                Dimensions.paddingSizeSmall,
                                                0,
                                                Dimensions.paddingSizeSmall,
                                                0),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).highlightColor,
                                                border: Border.all(
                                                    color: Colors.white, width: 3),
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(50)),
                                                child: CustomImageWidget(
                                                  width: 60,
                                                  height: 60,
                                                  image: AppConstants.addDeliveryMan,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                Dimensions.paddingSizeSmall,
                                                0,
                                                Dimensions.paddingSizeSmall,
                                                Dimensions.paddingSizeSmall),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!['nombre'] ?? 'No disponible',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: robotoBold.copyWith(
                                                      color: ColorResources
                                                          .getProfileTextColor(context),
                                                      fontSize: Dimensions
                                                          .fontSizeExtraLarge),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text('Usuario: ' + (snapshot.data!['login'] ?? 'No disponible'),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: titilliumRegular.copyWith(
                                                        color: ColorResources
                                                            .getProfileTextColor(context),
                                                        fontSize:
                                                            Dimensions.fontSizeSmall)),
                                                Text('Ruta: ' + (snapshot.data!['codruta'] ?? 'No disponible'),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: titilliumRegular.copyWith(
                                                        color: ColorResources
                                                            .getProfileTextColor(context),
                                                        fontSize:
                                                            Dimensions.fontSizeSmall)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
            child: ThemeChangerWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeExtraLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTranslated('app_version', context)!),
                const Padding(
                  padding: EdgeInsets.only(left: Dimensions.fontSizeExtraSmall),
                  child: Text(AppConstants.appVersion),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
