import 'package:flutter/material.dart';
import 'package:mydealer/providers/download_provider.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descarga Manual"),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.allItems.length,
            itemBuilder: (context, index) {
              final item = provider.allItems[index];
              return Card(
                child: ListTile(
                  title: Text(item.category),
                  subtitle: Text(
                      "Última descarga: ${item.updateDate} - Estado: ${item.status}"),
                  trailing: item.isDownloading
                      ? const Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 10),
                            Icon(Icons.download_rounded)
                          ],
                        )
                      : IconButton(
                          icon: const Icon(Icons.download_rounded),
                          onPressed: () =>
                              provider.downloadData(context, index),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
