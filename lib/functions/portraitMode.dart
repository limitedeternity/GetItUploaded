import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

mixin PortraitModeStatelessMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

mixin PortraitModeStatefulMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
  }
}
