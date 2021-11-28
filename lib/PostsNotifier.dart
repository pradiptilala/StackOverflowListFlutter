import 'package:code_tasks/model/ItemModel.dart';
import 'package:code_tasks/services/HttpService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PostsNotifier extends ChangeNotifier {
  List<Items> _postList = [];

  getPosts(BuildContext context) async {
    final HttpService httpService = HttpService();
    // final List<Items>
    _postList = await httpService.getPosts();
    notifyListeners();
          // final ResponseData responseData = snapshot.data;
          // _postList = snapshot.data!;
  }
  }

  // addPostToList(Post post){
  //   _postList.add(post);
  //   notifyListeners();
  // }
  //
  // List<Post> getPostList() {
  //   return _postList;
  // }
  //
  // Future<bool> uploadPost(Post post) async{
  //   return await ApiService.addPost(post, this);
  // }
// }