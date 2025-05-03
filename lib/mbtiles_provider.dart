import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MbTilesProvider {
  static late String _dbPath;

  static String get dbPath => _dbPath;

  static Future<void> initDb() async {
    try {
      final data = await rootBundle.load("assets/vietnam.mbtiles");

      final appDir = await getApplicationSupportDirectory();

      _dbPath = join(appDir.path, "data.db");

      if (await File(_dbPath).exists()) {
        print('File đã tồn tại ở: $_dbPath');
        return;
      }

      final file = File(_dbPath);
      await file.writeAsBytes(data.buffer.asUint8List());
    } catch (e) {
      print(e.toString());

      rethrow;
    }
  }
}
