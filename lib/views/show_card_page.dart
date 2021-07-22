import 'package:adopt_ta_waifu/controller/constant/colors.dart';
import 'package:adopt_ta_waifu/controller/constant/icons.dart';
import 'package:adopt_ta_waifu/controller/constant/strings.dart';
import 'package:adopt_ta_waifu/controller/utils/share_img.dart';
import 'package:adopt_ta_waifu/controller/utils/custom_animation.dart';
import 'package:adopt_ta_waifu/controller/utils/ui_utils.dart';
import 'package:adopt_ta_waifu/models/Waifu.dart';
import 'package:adopt_ta_waifu/widget/my_cached_image_network.dart';
import 'package:adopt_ta_waifu/widget/my_materials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowCardPage extends StatefulWidget {
  final String title;
  final List<Waifu> waifus;
  ShowCardPage(this.title, this.waifus);

  @override
  _ShowCardPageState createState() => _ShowCardPageState();
}

class _ShowCardPageState extends State<ShowCardPage> {
  //variable
  late bool isDarkMode;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _configLoadingWhenShare();
  }

  @override
  Widget build(BuildContext context) {
    var heightTotal = MediaQuery.of(context).size.height;
    var widthTotal = MediaQuery.of(context).size.width;
    isDarkMode = isInDarkMode(context);

    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
        context: context,
        isDarkMode: isDarkMode,
      ),
      body: _body(
        heightTotal,
        widthTotal,
      ),
    );
  }

  Widget _body(double heightTotal, double widthTotal) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _imgCard(
            heightTotal,
            widthTotal,
          ),
          _rowButton(),
        ],
      ),
    );
  }

  Widget _imgCard(double heightTotal, double widthTotal) {
    String imgLink = widget.waifus[index].sample ?? "";
    double borderRadius = 25.0;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 15.0,
      shadowColor: isDarkMode ? white : blueMain,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: myCacheImageNetwork(
          imgLink,
          widthTotal,
          heightTotal,
        ),
      ),
    );
  }

  Widget _rowButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButtonCustom(
          isLike: true,
          callback: () => _shareImg(),
        ),
        _iconButtonCustom(
          isLike: false,
          callback: () => _nextPage(),
        ),
      ],
    );
  }

  Widget _iconButtonCustom(
      {required bool isLike, required VoidCallback callback}) {
    return IconButton(
      onPressed: callback,
      icon: isLike ? Icon(likeIcon) : Icon(dislikeIcon),
      iconSize: 70.0,
      color: isDarkMode ? white : blueMain,
    );
  }

  void _shareImg() async {
    Waifu waifuLiked = widget.waifus[index];
    shareImg(waifuLiked);
    _animationLoading();
  }

  void _nextPage() {
    if (index < (widget.waifus.length - 1)) {
      ++index;
      setState(() {});
    } else {
      // TODO if all img show!
      index = 0;
    }
  }

  void _configLoadingWhenShare() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingGrid
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = white
      ..backgroundColor = green
      ..indicatorColor = lime
      ..textColor = yellow
      ..maskColor = blueMain.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = true
      ..customAnimation = CustomAnimation();
  }

  void _animationLoading() async {
    EasyLoading.show(
      status: strLoading,
      maskType: EasyLoadingMaskType.black,
    );
  }
}
