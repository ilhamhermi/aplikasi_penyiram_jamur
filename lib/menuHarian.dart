import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HarianMenu extends StatefulWidget {
  const HarianMenu({Key? key}) : super(key: key);

  @override
  _HarianMenuState createState() => _HarianMenuState();
}

class _HarianMenuState extends State<HarianMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(color: HexColor('#adc0a9'));
  }
}
