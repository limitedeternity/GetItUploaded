/*
*  main.dart
*  GetItUploaded
*
*  Created by Marise Hayashi.
*  Copyright © 2018 limitedeternity. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:get_it_uploaded/functions/portraitMode.dart';
import 'package:get_it_uploaded/uploader_widget/uploader_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget with PortraitModeStatelessMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      title: "GetItUploaded",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: UploaderWidget(),
    );
  }
}
