import 'dart:convert';

import 'package:code_tasks/model/ItemModel.dart';
import 'package:code_tasks/model/ResponseDataModel.dart';
import 'package:http/http.dart';

// This class is used to call the API service
class HttpService {
  final Uri uri = Uri.https("api.stackexchange.com", "/2.3/search/advanced", {
    'order': 'desc',
    'sort': 'activity',
    'site': 'stackoverflow',
  });

  /**
   * This method is used to get list of posts
   */
  Future<List<Items>> getPosts() async {
    Response res = await get(uri);

    if (res.statusCode == 200) {
      dynamic respDatabody = jsonDecode(res.body);

      ResponseData responseData = ResponseData.fromJson(respDatabody);

      if (responseData.items != null) {
        return responseData.items!;
      } else {
        return [];
      }
    } else {
      throw "Unable to retrieve results.";
    }
  }
}
