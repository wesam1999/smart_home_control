import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_home_control/Alert.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_control/AlertAll.dart';
import 'package:smart_home_control/AllDevice.dart';
import 'package:smart_home_control/Device.dart';
import 'package:smart_home_control/NewsAll.dart';
import 'package:smart_home_control/news.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart home controller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Alert> alert1 = List<Alert>.empty(growable: true);
  bool isLoaded = false;
  bool showLightBox = false;
  int indexalert = 0;
  Future<List<Alert>> APICall() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/AlertFlutter.php"));

    // var alerts=List<Alert>();
    var alertlist = List<Alert>.empty(growable: true);

    if (response.statusCode == 200) {
      // Corrected initialization
      var responsebodys = jsonDecode(response.body);

      for (var responsebody in responsebodys) {
        alertlist.add(Alert.fromJson(responsebody));
        print(Alert.fromJson(responsebody).time);
      }
    } else {
      throw Exception('Failed to load data');
    }

    return alertlist;
  }

  void showligthBoxFun(index) {
    // print("object");
    setState(() {
      indexalert = index;
      showLightBox = !showLightBox;
    });
  }

  void ShowLigthBox() {
    print("object");
    setState(() {
      showLightBox = !showLightBox;
    });
  }

  List<News> news = List<News>.empty(growable: true);
  Future<List<News>> APICAllnews() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/NewFlutter.php"));

    var newslist = List<News>.empty(growable: true);
    if (response.statusCode == 200) {
      var responsebodys = jsonDecode(response.body);
      for (var responsebody in responsebodys) {
        newslist.add(News.fromJson(responsebody));
      }
    } else {
      throw Exception("failed to load data");
    }

    return newslist;
  }

  List<device> Device = List<device>.empty(growable: true);
  Future<List<device>> APICAllDevice() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/DeviceGetFlutter.php"));

    var Devicelist = List<device>.empty(growable: true);
    if (response.statusCode == 200) {
      var responsebodys = jsonDecode(response.body);
      for (var responsebody in responsebodys) {
        Devicelist.add(device.fromJson(responsebody));
      }
    } else {
      throw Exception("failed to load data");
    }

    return Devicelist;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      APICall().then((data) {
        setState(() {
          alert1.addAll(data);

          isLoaded = true;
        });
      });
    }
    if (!isLoaded) {
      APICAllnews().then((data) {
        setState(() {
          news.addAll(data);

          isLoaded = true;
        });
      });
    }
    if (!isLoaded) {
      APICAllDevice().then((data) {
        setState(() {
          Device.addAll(data);

          isLoaded = true;
        });
      });
    }

    Widget getBoxLight(index) {
      return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: const Row(
            children: [Text("data")],
          ));
    }

    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
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
                            child: Text('Alerts'),
                          ),

                          //card for one alert
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  showligthBoxFun(index);
                                },
                                child: SizedBox(
                                  width: 300,
                                  child: Card(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: ClipOval(
                                                child: Image.asset(
                                              'images/logo.jpg',
                                              width: 50,
                                              height: 50,
                                            )),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          children: [
                                            Text(
                                              alert1[index].notificraion,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              alert1[index].description,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  alert1[index].name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  alert1[index].time,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: alert1.length < 3 ? alert1.length : 3,
                          ),
                        ],
                      )),
                ),
                Center(
                  child: InkWell(
                    child: const Text(
                      "see more ->",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const allAlert()),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: ListView(children: [
                      const Center(
                        child: Text("News"),
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/swimming.jpg',
                                  width: 100,
                                  height: 100,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(width: 150),
                                    Text(news[index].title),
                                    Text(news[index].shortDescription),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: news.length < 5 ? news.length : 5,
                      ),
                    ]),
                  ),
                ),
                Center(
                  child: InkWell(
                    child: const Text(
                      "see more ->",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const allNews()),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: ListView(children: [
                      const Center(
                        child: Text("Control"),
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/idea.png',
                                  width: 100,
                                  height: 100,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(width: 150),
                                    Text(Device[index].diviceName),
                                    Text(Device[index].maker),
                                    Text(Device[index].type),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Device.length < 5 ? Device.length : 5,
                      ),
                    ]),
                  ),
                ),
                Center(
                  child: InkWell(
                    child: const Text(
                      "see more ->",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const allNews()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.yellow,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/logo.jpg',
                          width: 100,
                          height: 100,
                        ),
                        const Text("Samrt Home"),
                      ],
                    )),
                const Text(
                  "PAGES",
                  style: TextStyle(fontSize: 25),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(' main Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(' Alert'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const allAlert()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('News'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const allNews()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(' Device '),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const allDevice()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text(' Libary '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "SCHEDULE",
                  style: TextStyle(fontSize: 25),
                ),
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text(' 80:00.09:00AM'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text(' 80:00.09:00AM'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text(' 80:00.09:00AM'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Text(
                    "IN Door:  32c  \nOut Door: 32c",
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        // if (showLightBox)
        //   Positioned(
        //     child: Scaffold(
        //       backgroundColor: Color.fromRGBO(25, 25, 25, 0.61),
        //       body: Center(
        //         child: Container(
        //           width: double.infinity,
        //           height: double.infinity,
        //         ),
        //       ),
        //     ),
        //     width: size.width,
        //     height: size.height,
        //   ),
        if (showLightBox)
          Positioned(
            width: size.width, // Use the provided size from `size`
            height: size.height,
            child: Container(
              color: const Color.fromRGBO(
                  25, 25, 25, 0.61), // Use Container instead of Scaffold
              child: Center(
                child: Container(
                  width: size.width * 0.8, // Adjusted size
                  height: size.height * 0.8, // Adjusted size
                  color: Colors.white, // You can style this as needed
                ),
              ),
            ),
          ),
        if (showLightBox)
          MaterialApp(
            home: Positioned(
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Image.asset(
                        'images/logo.jpg',
                        width: 50,
                        height: 50,
                      ),
                      Column(
                        children: [
                          Text(
                            "title: " + alert1[indexalert].notificraion,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "description: " + alert1[indexalert].description,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Name: " + alert1[indexalert].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Date and time: " + alert1[indexalert].time,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),
                          TextButton(
                              onPressed: () {
                                ShowLigthBox();
                              },
                              child: Text("close")),
                          TextButton(
                              onPressed: () {}, child: Text("Take Action")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
