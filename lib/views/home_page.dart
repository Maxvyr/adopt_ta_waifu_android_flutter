import 'package:adopt_ta_waifu/controller/constant/strings.dart';
import 'package:adopt_ta_waifu/controller/utils/navigation.dart';
import 'package:adopt_ta_waifu/models/waifu.dart';
import 'package:adopt_ta_waifu/repository/call_api.dart';
import 'package:adopt_ta_waifu/views/show_card_page.dart';
import 'package:adopt_ta_waifu/views/coming_soon.dart';

import '../controller/constant/colors.dart';
import '../controller/constant/images.dart';
import '../../widget/my_materials.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Waifu>> _waifus;

  @override
  void initState() {
    super.initState();
    _waifus = _initList();
  }

  Future<List<Waifu>> _initList() async {
    List<Waifu> list = [];
    list = await CallApi().getWaifus();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var heightTotal = MediaQuery.of(context).size.height;
    var widthTotal = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _waifus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return LoadingPage();
          case ConnectionState.done:
            List<Waifu> waifus = snapshot.data;

            return Scaffold(
              body: _body(
                heightTotal,
                widthTotal,
                waifus,
              ),
            );
          case ConnectionState.none:
            return LoadingPage();
          case ConnectionState.waiting:
            return LoadingPage();
          default:
            return LoadingPageError();
        }
      },
    );
  }

  Widget _body(
    double heightTotal,
    double widthTotal,
    List<Waifu> waifus,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _topPage(heightTotal, widthTotal),
        spacingH(height: heightTotal * 0.1),
        _buttonsNext(waifus),
      ],
    );
  }

  Widget _topPage(double heightTotal, double widthTotal) {
    double radiusImg = widthTotal * 0.1;
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightnessValue == Brightness.dark;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Image.asset(
              zeroTwoTop,
              height: heightTotal * 0.5,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: radiusImg,
            )
          ],
        ),
        ClipOval(
          child: Container(
            color: isDarkMode ? dark : white,
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(logoApp),
              radius: radiusImg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonsNext(List<Waifu> waifus) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyButtonElevated(
          txtBt: strWaifu,
          callback: () => animationPage(
            context,
            ShowCardPage(
              strWaifu,
              waifus,
            ),
          ),
        ),
        MyButtonElevated(
          txtBt: strHusbando,
          callback: () => animationPage(
            context,
            ComingSoon(strHusbando),
          ),
        ),
      ],
    );
  }
}