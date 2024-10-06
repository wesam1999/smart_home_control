import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_home_control/Alert.dart';
import 'package:smart_home_control/news.dart';

class allNews extends StatefulWidget {
  const allNews({super.key});

  @override
  State<allNews> createState() => _allNewsState();
}

class _allNewsState extends State<allNews> {
  List<News> news = List<News>.empty(growable: true);
  bool isLoaded = false;
  int indexalert = 0;
  int singlenewsIndex = -1;
  Future<List<News>> APICall() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/NewFlutter.php"));

    // var alerts=List<Alert>();
    var newslist = List<News>.empty(growable: true);

    if (response.statusCode == 200) {
      // Corrected initialization
      var responsebodys = jsonDecode(response.body);

      for (var responsebody in responsebodys) {
        newslist.add(News.fromJson(responsebody));
        print(Alert.fromJson(responsebody).time);
      }
    } else {
      throw Exception('Failed to load data');
    }

    return newslist;
  }

  Widget getSingleNews() {
    return Center(
      child: SizedBox(
        child: Column(
          children: [
            Image.asset(
              'images/swimming.jpg',
              width: 50,
              height: 50,
            ),
            Text(
              news[singlenewsIndex].title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              news[singlenewsIndex].shortDescription,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              news[singlenewsIndex].name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              news[singlenewsIndex].time,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              news[singlenewsIndex].description,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      APICall().then((data) {
        setState(() {
          news.addAll(data);

          isLoaded = true;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("news"),
      ),
      body: Center(
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                  width: 300,
                  height: 200,
                  child: ListView(
                    children: [
                      const Center(
                        child: Text('news'),
                      ),

                      //card for one alert
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                singlenewsIndex = index;
                              });
                            },
                            child: SizedBox(
                              width: 300,
                              child: Card(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/swimming.jpg',
                                      width: 100,
                                      height: 100,
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: [
                                        Text(
                                          news[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          news[index].shortDescription,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              news[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              news[index].time,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: news.length,
                      ),
                    ],
                  )),
            ),
            singlenewsIndex == -1
                ? Center(
                    child: Text("no news select"),
                  )
                : getSingleNews()
          ],
        ),
      ),
    );
  }
}
