import 'dart:collection';

import 'package:code_tasks/PostsNotifier.dart';
import 'package:code_tasks/services/HttpService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'AppConstants.dart';
import 'model/ItemModel.dart';

void main() {
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     builder: (context) => MyApp(),
  //     enabled: !kReleaseMode,
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PostsNotifier(),
        ),
      ],
      child: MaterialApp(
        // locale: DevicePreview.locale(context),
        // // <--- Add the locale
        // builder: DevicePreview.appBuilder,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
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

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();

  // build list view & manage states
  FutureBuilder<List<Items>> _buildBody(BuildContext context) {
    final HttpService httpService = HttpService();
    return FutureBuilder<List<Items>>(
      future: httpService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          // final ResponseData responseData = snapshot.data;
          final List<Items> posts = snapshot.data!;
          // final List<Items> posts = responseData.items;
          return _buildPosts(context, posts);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // build list view & its tile
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
                          // color: Colors.grey,
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
                            color: HexColor("#0074CC")),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey,
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
                              color: HexColor("#838C95"),
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
        )
        // ListTile(
        //   title: Text(
        //     posts[index].title.toString(),
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: Text("Text(posts[index].completed.toString())"),
        // ),
        );
  }

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
                              // color: Colors.grey,
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
                                          color: HexColor("#0074CC")),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.grey,
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
                              color: HexColor("#838C95"),
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
        )
        // ListTile(
        //   title: Text(
        //     posts[index].title.toString(),
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: Text("Text(posts[index].completed.toString())"),
        // ),
        );
  }

  // build list view & its tile
  ListView _buildVotes(BuildContext context, Items items) {
    HashMap<String, int> hashmap = HashMap.from({
      VOTES: items.score,
      ANSWERS: items.answerCount,
      VIEWS: items.viewCount
    });

    List<String> myList = [VOTES, ANSWERS, VIEWS];

    // HashMap<String,int>();
    // items.answerCount
    // items.viewCount

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
                  border: Border.all(color: HexColor("#47A868"), width: 1)),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(hashmap[myList[index]].toString(),
                            style: TextStyle(
                              color: HexColor("#47A868"),
                              fontSize: 14,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(myList[index].toString(),
                            style: TextStyle(
                              color: HexColor("#47A868"),
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
                              color: HexColor("#838C95"),
                              fontSize: 14,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(myList[index].toString(),
                            style: TextStyle(
                              color: HexColor("#838C95"),
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

  // E1ECF4
  // 0074CC

  // build list view & its tile
  ListView _buildTags(BuildContext context, List<String> tags) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      // physics: ClampingScrollPhysics(),
      itemCount: tags.length,
      // padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
          child: Wrap(children: [
            Container(
                decoration: BoxDecoration(
                    color: HexColor("#E1ECF4"),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tags[index].toString(),
                      style: TextStyle(
                        color: HexColor("#0074CC"),
                        fontSize: 16,
                      )),
                ))
          ]),
        );
      },
    );
  }

  String getDateString(Items items) {
    int? askedMillis = items.lastActivityDate;
    int? editedMillis = items.lastEditDate;

    int? lastMillis = askedMillis;
    String actionString = ASKED;

    if (editedMillis != null) {
      lastMillis = editedMillis;
      actionString = MODIFIED;
    }

    if (items.answerCount != null && items.answerCount! > 0) {
      actionString = ANSWERED;
    }

    if (lastMillis != null) {
      DateTime dateTimeNow = DateTime.now();
      DateTime dateTimeLast =
          DateTime.fromMillisecondsSinceEpoch(lastMillis, isUtc: false);
      Duration diffrence = dateTimeNow.difference(dateTimeLast);

      if (diffrence.inSeconds < 60) {
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
      } else if (diffrence.inHours < 24) {
        return actionString +
            " " +
            diffrence.inHours.toString() +
            " " +
            (diffrence.inHours > 1 ? HOUR + "s" : HOUR) +
            " " +
            AGO;
      } else {
        DateTime now = DateTime.now();
        // String formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
        String formattedDate = DateFormat("MMM dd yyyy").format(now);
        String formattedTime = DateFormat("HH:mm").format(now);
        // answered Jul 19 '19 at 6:42
        return actionString + " " + formattedDate + " at " + formattedTime;
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // title: Text(widget.title),
          ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: _buildBody(context)),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
// }
