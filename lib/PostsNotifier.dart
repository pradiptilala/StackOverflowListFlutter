import 'package:code_tasks/model/ItemModel.dart';
import 'package:code_tasks/services/HttpService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PostsNotifier with ChangeNotifier {
  List<Items> _postList = [];

  getPosts(BuildContext context) {
    final HttpService httpService = HttpService();
    FutureBuilder<List<Items>>(
      future: httpService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          // final ResponseData responseData = snapshot.data;
          final List<Items> posts = snapshot.data!;
          _postList = snapshot.data!;
        } else {
          _postList = [];
        }
      },
    );
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
}