import 'package:flutter/material.dart';
import 'package:mydealer/controllers/custom_app_bar_widget.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/providers/download_provider.dart';
import 'package:provider/provider.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/styles.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isBackButtonExist: true,
        title: getTranslated('download', context),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.allItems.length,
            itemBuilder: (context, index) {
              final item = provider.allItems[index];
              return DownloadItemCard(
                category: item.category,
                updateDate: item.updateDate,
                status: item.status,
                isDownloading: item.isDownloading,
                onDownloadPressed: () => provider.downloadData(context, index),
              );
            },
          );
        },
      ),
    );
  }
}

class DownloadItemCard extends StatelessWidget {
  final String category;
  final String updateDate;
  final String status;
  final bool isDownloading;
  final VoidCallback onDownloadPressed;

  const DownloadItemCard({
    Key? key,
    required this.category,
    required this.updateDate,
    required this.status,
    required this.isDownloading,
    required this.onDownloadPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: ThemeShadow.getShadow(context),
      ),
      height: Dimensions.profileCardHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: Dimensions.iconSizeDefault,
              height: Dimensions.iconSizeDefault,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeSmall,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: robotoRegular.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text.rich(
                    TextSpan(
                      text: "Última D: ",
                      style: robotoRegular.copyWith(
                        color: Colors.blue,
                      ),
                      children: [
                        TextSpan(
                          text: "$updateDate",
                          style: robotoRegular.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " - Estado: ",
                          style: robotoRegular.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: "$status",
                          style: robotoRegular.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            isDownloading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      const SizedBox(width: 10),
                      Icon(Icons.download_rounded,
                          color: Theme.of(context).primaryColor),
                    ],
                  )
                : IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      color: Theme.of(context).primaryColor,
                      size: Dimensions.iconSizeDefault,
                    ),
                    onPressed: onDownloadPressed,
                  ),
          ],
        ),
      ),
    );
  }
}
