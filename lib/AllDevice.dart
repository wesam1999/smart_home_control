import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smart_home_control/Device.dart';

class allDevice extends StatefulWidget {
  const allDevice({super.key});

  @override
  State<allDevice> createState() => _allDeviceState();
}

final myController = TextEditingController();
@override
void dispose() {
  // Clean up the controller when the widget is disposed.
  myController.dispose();
}

final myController1 = TextEditingController();
@override
void dispose1() {
  // Clean up the controller when the widget is disposed.
  myController1.dispose();
}

final myController2 = TextEditingController();
@override
void dispose2() {
  // Clean up the controller when the widget is disposed.
  myController2.dispose();
}

const List<String> list = <String>[
  'Camera',
  'Wishing Machine',
  'Light Room',
  'AC',
  'Personal Camera'
];
String dropdownValue = list.first;
addDevice() async {
  var response = await http.post(
    Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/createDeviceFlutter.php"),
    body: jsonEncode(<String, String>{
      'devicename': myController.value.toString(),
      'Maker': myController1.value.toString(),
      'locationInHouse': myController2.value.toString(),
      'type': dropdownValue.toString(),
    }),
  );
  if (response.statusCode == 200) {
    print("Device add successfully!");
  }
}

class _allDeviceState extends State<allDevice> {
  List<device> Device = List<device>.empty(growable: true);
  bool isLoaded = false;
  bool showLightBox = false;
  int indexalert = 0;
  int singleAlertIndex = -1;
  Future<List<device>> APICall() async {
    var response = await http.get(Uri.parse(
        "http://10.0.2.2:80/final%20project/Smart-Home-conrtol-website/DeviceGetFlutter.php"));

    // var alerts=List<Alert>();
    var devicelist = List<device>.empty(growable: true);

    if (response.statusCode == 200) {
      // Corrected initialization
      var responsebodys = jsonDecode(response.body);

      for (var responsebody in responsebodys) {
        devicelist.add(device.fromJson(responsebody));
      }
    } else {
      throw Exception('Failed to load data');
    }

    return devicelist;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      APICall().then((data) {
        setState(() {
          Device.addAll(data);

          isLoaded = true;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Device"),
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
                        child: Text('Device'),
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
                                          'images/idea.png',
                                          width: 50,
                                          height: 50,
                                        )),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: [
                                        Text(
                                          Device[index].diviceName,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          Device[index].maker,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              Device[index].type,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              Device[index].controlDeviceId,
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
                        itemCount: Device.length,
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: 300,
              height: 600,
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      "Device",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Text(
                    "Device Name",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Device Name',
                    ),
                    controller: myController,
                  ),
                  Text(
                    "Make",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Make',
                    ),
                    controller: myController1,
                  ),
                  Text(
                    "Location In House",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Location In House',
                    ),
                    controller: myController2,
                  ),
                  Row(
                    children: [
                      DropdownMenu<String>(
                        initialSelection: list.first,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries:
                            list.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                      TextButton(onPressed: () {}, child: Text("Custom"))
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        addDevice();
                      },
                      child: Text("Add device"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
