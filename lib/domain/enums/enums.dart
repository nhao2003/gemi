import 'package:json_annotation/json_annotation.dart';

enum Breakpoint {
  mobile,
  tablet,
  desktop;

  static Breakpoint fromWidth(double width) {
    if (width < 600) {
      return Breakpoint.mobile;
    } else if (width < 900) {
      return Breakpoint.tablet;
    } else {
      return Breakpoint.desktop;
    }
  }
}
