import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCacheHelper {
  static Future<String> downloadAndSaveImage(String url, String id) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = p.join(directory.path, 'img_$id.jpg');
        final file = await File(filePath).create();
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (_) {}

    return url;
  }
}
