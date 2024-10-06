import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_home_control/Alert.dart';

class allAlert extends StatefulWidget {
  const allAlert({super.key});

  @override
  State<allAlert> createState() => _allAlertState();
}

class _allAlertState extends State<allAlert> {
  List<Alert> alert1 = List<Alert>.empty(growable: true);
  bool isLoaded = false;
  bool showLightBox = false;
  int indexalert = 0;
  int singleAlertIndex = -1;
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

  Widget getSingleAlert() {
    return Center(
      child: SizedBox(
        child: Column(
          children: [
            Image.asset(
              'images/logo.jpg',
              width: 50,
              height: 50,
            ),
            Text(
              alert1[singleAlertIndex].notificraion,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              alert1[singleAlertIndex].description,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              alert1[singleAlertIndex].name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              alert1[singleAlertIndex].time,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              alert1[singleAlertIndex].shortDescription,
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
          alert1.addAll(data);

          isLoaded = true;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Alert"),
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
                              setState(() {
                                singleAlertIndex = index;
                              });
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
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          alert1[index].description,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              alert1[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              alert1[index].time,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
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
                        itemCount: alert1.length,
                      ),
                    ],
                  )),
            ),
            singleAlertIndex == -1
                ? Center(
                    child: Text("no Alert select"),
                  )
                : getSingleAlert()
          ],
        ),
      ),
    );
  }
}
