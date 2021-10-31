import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ControllMenu extends StatefulWidget {
  const ControllMenu({Key? key}) : super(key: key);

  @override
  _ControllMenuState createState() => _ControllMenuState();
}

class _ControllMenuState extends State<ControllMenu> {
  List<Color> gradientBlue = [
    // Color(0xa4e459),
    // Color(0x3bc051),
    // Color(0x047029),
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade700,
    Colors.green.shade900,
  ];
  bool _kondisi = false;

  final minSuhuController = TextEditingController();
  final maxSuhuController = TextEditingController();
  final minKelembabanController = TextEditingController();
  final maxKelembabanController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: HexColor('#3bc051'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(110, 80),
            ),
            color: HexColor('#adc0a9'),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    color: Colors.blueGrey.shade100,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Text("monitor suhu")),
                    elevation: 10,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
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
                        child: Text("monitor kelembaban")),
                    elevation: 10,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    width: MediaQuery.of(context).size.width,
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
                                top: 15.0, left: 10, right: 10),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Kontrol Penyiram",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
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
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
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
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
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
                                              activeColor: Colors.amberAccent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      // height:
                                      //     MediaQuery.of(context).size.height / 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(70, 50),
                                          topRight: Radius.elliptical(70, 50),
                                        ),
                                        color: Colors.white12,
                                      ),
                                      child: _kondisi == true
                                          ? _otomatis()
                                          : _manual(),
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
      ),
      backgroundColor: HexColor('#3bc051'),
    );
  }

  Widget _manual() {
    return Padding(
        padding: const EdgeInsets.only(
      top: 30,
      left: 20,
      right: 20,
    ));
  }

  Widget _otomatis() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Batas Suhu : ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 55,
                child: NumberInputWithIncrementDecrement(
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  widgetContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  numberFieldDecoration: InputDecoration(
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
              Text(
                "\u2103",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "< suhu >",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 100,
                height: 55,
                child: NumberInputWithIncrementDecrement(
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  widgetContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  numberFieldDecoration: InputDecoration(
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
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Batas Kelembaban : ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 55,
                child: NumberInputWithIncrementDecrement(
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  widgetContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  numberFieldDecoration: InputDecoration(
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
                  fontSize: 40,
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
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 100,
                height: 55,
                child: NumberInputWithIncrementDecrement(
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  widgetContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                  numberFieldDecoration: InputDecoration(
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
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
