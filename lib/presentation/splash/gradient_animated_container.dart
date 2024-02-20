import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GradientAnimatedContainer extends StatefulWidget {
  final Widget child;
  const GradientAnimatedContainer({super.key, required this.child});

  @override
  State<GradientAnimatedContainer> createState() =>
      _GradientAnimatedContainerState();
}

class _GradientAnimatedContainerState extends State<GradientAnimatedContainer> {
  List<Color> darkColorList = const [
    Color(0xff171B70),
    Color(0xff410D75),
    Color(0xff032340),
    Color(0xff050340),
    Color(0xff2C0340),
  ];
  Color bottomDarkColor = const Color(0xff092646);
  Color topDarkColor = const Color(0xff410D75);
  List<Color> lightColorList = const [
    Color(0xffF2F2F2), // Màu nền sáng
    Color(0xffEDE7F6), // Màu nền cho phần trên của ứng dụng
    Color(0xff9575CD), // Màu nền cho phần dưới của ứng dụng
    Color(0xffBA68C8), // Màu nền cho nút hoặc biểu tượng chính
    Color(0xffAB47BC), // Màu nền cho các nút hoặc biểu tượng phụ
  ];
  Color bottomLightColor =
      const Color(0xff512DA8); // Màu nền cho phần dưới của ứng dụng
  Color topLightColor =
      const Color(0xff7E57C2); // Màu nền cho phần trên của ứng dụng

  List<Alignment> alignmentList = [Alignment.topCenter, Alignment.bottomCenter];
  int index = 0;
  Alignment begin = Alignment.bottomCenter;
  Alignment end = Alignment.topCenter;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(microseconds: 0),
      () {
        setState(
          () {
            // bottomDarkColor = Color(0xff33267C);
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              bottomDarkColor = darkColorList[index % darkColorList.length];
              topDarkColor = darkColorList[(index + 1) % darkColorList.length];
            } else {
              bottomLightColor = lightColorList[index % lightColorList.length];
              topLightColor =
                  lightColorList[(index + 1) % lightColorList.length];
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      onEnd: () {
        setState(
          () {
            index = index + 1;
            if (isDarkMode) {
              bottomDarkColor = darkColorList[index % darkColorList.length];
              topDarkColor = darkColorList[(index + 1) % darkColorList.length];
            } else {
              bottomLightColor = lightColorList[index % lightColorList.length];
              topLightColor =
                  lightColorList[(index + 1) % lightColorList.length];
            }
          },
        );
      },
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: isDarkMode
              ? [bottomDarkColor, topDarkColor]
              : [bottomLightColor, topLightColor],
        ),
      ),
      child: widget.child,
    );
  }
}
