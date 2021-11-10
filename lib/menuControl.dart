import 'dart:convert';
import 'dart:ui';

import 'package:aplikasi_penyiram_jamur/menuHarian.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scroll_bottom_navigation_bar/scroll_bottom_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';

class ControllMenu extends StatefulWidget {
  const ControllMenu({Key? key}) : super(key: key);

  @override
  _ControllMenuState createState() => _ControllMenuState();
}

class _ControllMenuState extends State<ControllMenu> {
  int _currentIndex = 0;

  void ontapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _childern = [
    KontroldanMonitor(),
    HarianMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: null,
      // AppBar(
      //   backgroundColor: HexColor('#3bc051'),
      //   elevation: 0,
      //   title: Text("Kontrol $alat"),
      //   actions: <Widget>[
      //     PopupMenuButton(
      //         onSelected: handleClick,
      //         itemBuilder: (BuildContext context) {
      //           return {'Alat 1', 'Alat 2'}.map((String choice) {
      //             return PopupMenuItem<String>(
      //               child: Text(choice),
      //               value: choice,
      //             );
      //           }).toList();
      //         })
      //   ],
      // ),

      bottomNavigationBar: ScrollBottomNavigationBar(
        controller: ScrollController(),
        // fixedColor: Colors.grey.shade50,
        // selectedItemColor: Colors.grey.shade50,
        // unselectedItemColor: Colors.black,
        onTap: ontapped,
        elevation: 20,
        backgroundColor: HexColor('#3bc051'),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dock),
            label: "Harian",
          ),
        ],
      ),
      body: _childern[_currentIndex],
      backgroundColor: HexColor('#3bc051'),
    );
  }
}

class KontroldanMonitor extends StatefulWidget {
  const KontroldanMonitor({
    Key? key,
  }) : super(key: key);

  // final String alatStatus;

  @override
  _KontroldanMonitorState createState() => _KontroldanMonitorState();
}

class _KontroldanMonitorState extends State<KontroldanMonitor> {
  List<Color> gradientBlue = [
    // Color(0xa4e459),
    // Color(0x3bc051),
    // Color(0x047029),
    Colors.blue.shade400,
    Colors.blue.shade500,
    Colors.blue.shade700,
    Colors.blue.shade900,
  ];

  final minSuhuController = TextEditingController();
  final maxSuhuController = TextEditingController();
  final minKelembabanController = TextEditingController();
  final maxKelembabanController = TextEditingController();
  bool _kondisi = false;
  bool _saklar = false;

  static String alat = "Alat 1";
  static String alatStatus = "alat1";
  void handleClick(String value) {
    print('niali :$value');
    switch (value) {
      case 'Alat 1':
        print("alat1");
        setState(() {
          alat = 'Alat 1';
          alatStatus = 'alat1';
        });
        break;

      case 'Alat 2':
        print("alat2");
        setState(() {
          alat = 'Alat 2';
          alatStatus = 'alat2';
        });

        break;
    }
  }

  void updateMinSuhu() {
    var _minSuhu;
    setState(() {
      // _minSuhu = minSuhuController.text;
      print(minSuhuController.text);
    });
    FirebaseDatabase.instance
        .reference()
        .child('$alatStatus')
        .update({'minSuhu': _minSuhu});
  }

  void ledOn() {
    FirebaseDatabase.instance
        .reference()
        .child('$alatStatus')
        .update({'saklar': 'on'});
  }

  void ledOff() async {
    await FirebaseDatabase.instance
        .reference()
        .child('$alatStatus')
        .update({'saklar': 'off'});
  }

  // void _handleSaklar(bool saklarStts) async {
  //   if (saklarStts) {
  //     await ledOn;
  //   } else {
  //     await ledOff;
  //   }
  // }

  void getStatus() async {
    String newValue = (await FirebaseDatabase.instance
            .reference()
            .child('alat/$alatStatus/saklar')
            .once())
        .value;
    setState(() {
      if (newValue == 'on') {
        _saklar = true;
      } else {
        _saklar = false;
      }
    });
  }

  void getBatas() async {
    var minSuhuValue = (await FirebaseDatabase.instance
            .reference()
            .child('/')
            // .orderByChild('alat')
            .once())
        .value;

    // var dataItem = [];
    // for (var item in minSuhuValue.value) {
    // dataItem.add(item);
    // }
    // minSuhuValue.dsa

    print('panjang data : ${minSuhuValue['alat']}');
    // print('panjang d: ${json.decode(minSuhuValue['alat'].toString())}');

    // setState(() {
    //   minSuhuController.text = minSuhuValue.toString();
    // });
  }

  mapingData(var nilai, var min, var up, var tomin, var toup) {
    var hasil = tomin + ((toup - tomin) / (up - min)) * (nilai - 0);

    return hasil;
  }

  @override
  void initState() {
    // TODO: implement initState
    // minSuhuController.addListener(updateMinSuhu);
    getBatas();
    getStatus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // minSuhuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Event>(
          stream: FirebaseDatabase.instance
              .reference()
              .child('alat/$alatStatus')
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (event.hasData) {
              print("data ${event.data!.snapshot.value}");
              var dt = event.data!.snapshot.value;
              var panjang = dt.toString().length;
              print("panjang $panjang");
              print("nilai ${event.data!.snapshot.value['alat1']}");
              print("lo $alat");
            } else {
              print("error");
              return CircularProgressIndicator();
            }
            // maxSuhuController.clear();
            print('anu $alatStatus');
            minSuhuController.text =
                event.data!.snapshot.value['minSuhu'].toString();
            maxSuhuController.text =
                event.data!.snapshot.value['maxSuhu'].toString();
            minKelembabanController.text =
                event.data!.snapshot.value['minKelembaban'].toString();
            maxKelembabanController.text =
                event.data!.snapshot.value['maxKelembaban'].toString();
            var data = event.data!.snapshot.value;
            print('hemm : ${event.data!.snapshot.value['maxKelembaban']}');
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      // topLeft: Radius.elliptical(110, 80),
                      ),
                  color: HexColor('#adc0a9'),
                ),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                                EdgeInsets.only(top: 5, left: 10, right: 10),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                color: Colors.blueGrey.shade200,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 30),
                                          child: Text(
                                            "Kontrol $alat",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      PopupMenuButton(
                                          onSelected: handleClick,
                                          itemBuilder: (BuildContext context) {
                                            return {'Alat 1', 'Alat 2'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                child: Text(choice),
                                                value: choice,
                                              );
                                            }).toList();
                                          })
                                    ],
                                  ),
                                )))),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 10, right: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          color: Colors.blueGrey.shade100,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Suhu Ruangan:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data['suhu'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "\u2103",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: new CircularPercentIndicator(
                                      radius: 120,
                                      lineWidth: 20,
                                      percent:
                                          mapingData(data['suhu'], 0, 40, 0, 1),
                                      rotateLinearGradient: true,
                                      linearGradient:
                                          LinearGradient(colors: gradientBlue),
                                      startAngle: 185,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          elevation: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 10, right: 10, bottom: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          // color: HexColor('#a4e459'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              // gradient: LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: [
                              //     HexColor('#047029'),
                              //     HexColor('#3bc051'),
                              //     HexColor('#047029'),

                              //     // Colors.green.shade600
                              //   ],
                              // )
                              color: Colors.green.shade100,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Kelembaban:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data['kelembaban'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "%",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: new CircularPercentIndicator(
                                      radius: 120,
                                      lineWidth: 20,
                                      percent: mapingData(
                                          data['kelembaban'], 0, 100, 0, 1),
                                      rotateLinearGradient: true,
                                      linearGradient:
                                          LinearGradient(colors: gradientBlue),
                                      startAngle: 185,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          elevation: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: HexColor('#3bc051'),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(70, 50),
                                topRight: Radius.elliptical(70, 50),
                              )),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Kontrol Penyiram",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    _kondisi == true
                                                        ? "Mode Otomatis "
                                                        : "Mode Manual",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: _kondisi,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _kondisi = value;
                                                        print(_kondisi);
                                                      });
                                                    },
                                                    activeColor:
                                                        Colors.amberAccent,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // height:
                                            //     MediaQuery.of(context).size.height / 10,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.elliptical(70, 50),
                                                topRight:
                                                    Radius.elliptical(70, 50),
                                              ),
                                              color: Colors.white12,
                                            ),
                                            child: _kondisi == true
                                                ? _otomatis()
                                                : _manual(
                                                    event.data!.snapshot.value),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _manual(var data) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.shade500,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (_saklar) {
                    await FirebaseDatabase.instance
                        .reference()
                        .child('alat1')
                        .update({'saklar': 'on'});
                  } else {
                    await FirebaseDatabase.instance
                        .reference()
                        .child('alat1')
                        .update({'saklar': 'off'});
                  }

                  setState(() {
                    _saklar = !_saklar;
                  });
                  // print("data: $data");
                },
                icon: Icon(Icons.power_settings_new_rounded),
                alignment: Alignment.center,
                iconSize: 80,
                color: _saklar == true ? Colors.amber : Colors.greenAccent,
                splashColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otomatis() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Batas Suhu : ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 50,
                  // padding: EdgeInsets.all(5),
                  // alignment: Alignment.center,
                  child: NumberInputWithIncrementDecrement(
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                    // scaleHeight: 2,
                    widgetContainerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    numberFieldDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 20, left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                    ),
                    controller: minSuhuController,
                  ),
                ),
                // TextField(),
                Text(
                  "\u2103",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "sampai",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  height: 50,
                  // padding: EdgeInsets.all(5),
                  // alignment: Alignment.center,
                  child: NumberInputWithIncrementDecrement(
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                    // scaleHeight: 2,
                    widgetContainerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    numberFieldDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 20, left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                    ),
                    controller: maxSuhuController,
                  ),
                ),
                Text(
                  "\u2103",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Batas Kelembaban : ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 50,
                  // padding: EdgeInsets.all(5),
                  // alignment: Alignment.center,
                  child: NumberInputWithIncrementDecrement(
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                    // scaleHeight: 2,
                    widgetContainerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    numberFieldDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 20, left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                    ),
                    controller: minKelembabanController,
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "sampai",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 80,
                  height: 50,
                  // padding: EdgeInsets.all(5),
                  // alignment: Alignment.center,
                  child: NumberInputWithIncrementDecrement(
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                    // scaleHeight: 2,
                    widgetContainerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                    numberFieldDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 20, left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 3,
                        ),
                      ),
                    ),
                    controller: maxKelembabanController,
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green.shade800),
                ),
                onPressed: () async {
                  await FirebaseDatabase.instance
                      .reference()
                      .child('alat1')
                      .update({
                    'minSuhu': '${minSuhuController.text}',
                    'maxSuhu': '${maxSuhuController.text}',
                    'minKelembaban': '${minKelembabanController.text}',
                    'maxKelembaban': '${maxKelembabanController.text}',
                  });
                },
                child: Text('Update'),
              ),
            )
            // FloatingActionButton(
            //   onPressed: () {},
            //   child: Text('Update'),
            // ),
          ],
        ),
      ),
    );
  }
}
