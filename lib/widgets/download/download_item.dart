import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DownloadItem with ChangeNotifier {
  String category;
  String updateDate;
  String status;
  bool isDownloading;

  DownloadItem({
    required this.category,
    this.updateDate = "",
    this.status = "",
    this.isDownloading = false,
  });

  void startDownload() {
    isDownloading = true;
    notifyListeners();
  }

  void completeDownload(bool success) {
    updateDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    status = success ? "OK" : "Failed";
    isDownloading = false;
    notifyListeners();
  }
}
