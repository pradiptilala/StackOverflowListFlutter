import 'package:code_tasks/model/ItemModel.dart';
import 'package:code_tasks/services/HttpService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/**
 * This model class holds list of posts
 */
class PostsNotifier extends ChangeNotifier {
  List<Items> postList = [];

  getPosts(BuildContext context) async {
    final HttpService httpService = HttpService();
    postList = await httpService.getPosts();
    notifyListeners();
  }
}
