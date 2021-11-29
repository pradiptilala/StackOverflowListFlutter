import 'dart:collection';

import 'package:code_tasks/model/ItemModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../PostsNotifier.dart';
import '../utils/AppConstants.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    Provider.of<PostsNotifier>(context, listen: false).getPosts(context);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(APP_NAME),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Consumer<PostsNotifier>(builder: (context, prov2, child) {
          if (prov2.postList.length > 0) {
            return _buildPosts(context, prov2.postList);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        })));
  }

  // build list view for posts
  ListView _buildPosts(BuildContext context, List<Items> posts) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: posts.length,
      padding: EdgeInsets.all(4),
      itemBuilder: (context, index) {
        return MediaQuery.of(context).orientation == Orientation.portrait
            ? _buildVerticalLayout(context, posts[index])
            : _buildHorizontalLayout(context, posts[index]);
      },
    );
  }

  // build vertical layout
  _buildVerticalLayout(BuildContext context, Items item) {
    return Card(
        elevation: 4,
        child: Container(
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SizedBox(
                          height: 65,
                          child: _buildVotes(context, item),
                        ),
                      ),
                      Text(
                        item.title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor(BLUE_COLOR_CODE)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SizedBox(
                          height: 40,
                          child: _buildTags(
                              context, item.tags != null ? item.tags! : []),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                          child: Text(
                            getDateString(item),
                            style: TextStyle(
                              color: HexColor(GRAY_COLOR_CODE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // build horizontal layout
  _buildHorizontalLayout(BuildContext context, Items item) {
    return Card(
        elevation: 4,
        child: Container(
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: SizedBox(
                              height: 65,
                              child: _buildVotes(context, item),
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      item.title.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: HexColor(BLUE_COLOR_CODE)),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: _buildTags(context,
                                        item.tags != null ? item.tags! : []),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                          child: Text(
                            getDateString(item),
                            style: TextStyle(
                              color: HexColor(GRAY_COLOR_CODE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  // build votes layout
  ListView _buildVotes(BuildContext context, Items items) {
    HashMap<String, int> hashmap = HashMap.from({
      VOTES: items.score,
      ANSWERS: items.answerCount,
      VIEWS: items.viewCount
    });

    List<String> myList = [VOTES, ANSWERS, VIEWS];

    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
      itemBuilder: (context, index) {
        if (index == 1 && hashmap[myList[index]]! > 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border:
                      Border.all(color: HexColor(GREEN_COLOR_CODE), width: 1)),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(hashmap[myList[index]].toString(),
                            style: TextStyle(
                              color: HexColor(GREEN_COLOR_CODE),
                              fontSize: 14,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(myList[index].toString(),
                            style: TextStyle(
                              color: HexColor(GREEN_COLOR_CODE),
                              fontSize: 16,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Wrap(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(hashmap[myList[index]].toString(),
                            style: TextStyle(
                              color: HexColor(GRAY_COLOR_CODE),
                              fontSize: 14,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(myList[index].toString(),
                            style: TextStyle(
                              color: HexColor(GRAY_COLOR_CODE),
                              fontSize: 16,
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ]);
        }
      },
    );
  }

  // build tags layout
  ListView _buildTags(BuildContext context, List<String> tags) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
          child: Wrap(children: [
            Container(
                decoration: BoxDecoration(
                    color: HexColor(LIGHT_BLUE_COLOR_CODE),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tags[index].toString(),
                      style: TextStyle(
                        color: HexColor(BLUE_COLOR_CODE),
                        fontSize: 16,
                      )),
                ))
          ]),
        );
      },
    );
  }

  // get date string for the post item
  String getDateString(Items items) {
    int? askedMillis = items.creationDate;
    int? editedMillis = items.lastEditDate;

    int? lastMillis = askedMillis;
    String actionString = ASKED;

    if (editedMillis != null) {
      lastMillis = editedMillis;
      actionString = MODIFIED;
    } else if (items.answerCount != null && items.answerCount! > 0) {
      actionString = ANSWERED;
    }

    if (lastMillis != null) {
      DateTime dateTimeNow = DateTime.now();
      DateTime dateTimeLast =
          DateTime.fromMillisecondsSinceEpoch(lastMillis * 1000, isUtc: false);
      Duration diffrence = dateTimeNow.difference(dateTimeLast);

      if (diffrence.inMilliseconds < 1000) {
        return actionString + "1" + " " + SEC + " " + AGO;
      } else if (diffrence.inSeconds < 60) {
        return actionString +
            " " +
            diffrence.inSeconds.toString() +
            " " +
            (diffrence.inSeconds > 1 ? SEC + "s" : SEC) +
            " " +
            AGO;
      } else if (diffrence.inMinutes < 60) {
        return actionString +
            " " +
            diffrence.inMinutes.toString() +
            " " +
            (diffrence.inMinutes > 1 ? MIN + "s" : MIN) +
            " " +
            AGO;
      } else if (diffrence.inHours <= 24) {
        return actionString +
            " " +
            diffrence.inHours.toString() +
            " " +
            (diffrence.inHours > 1 ? HOUR + "s" : HOUR) +
            " " +
            AGO;
      } else {
        DateTime now = DateTime.fromMillisecondsSinceEpoch(lastMillis * 1000,
            isUtc: false);
        String formattedDate = DateFormat(DATE_FORMAT_PATTERN).format(now);
        String formattedTime = DateFormat(TIME_FORMAT_PATTERN).format(now);
        return actionString + " " + formattedDate + " at " + formattedTime;
      }
    } else {
      return "";
    }
  }
}
