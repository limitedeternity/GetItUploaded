/*
*  uploader_widget.dart
*  GetItUploaded
*
*  Created by Marise Hayashi.
*  Copyright © 2018 limitedeternity. All rights reserved.
    */

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it_uploaded/values/values.dart';
import 'package:get_it_uploaded/functions/queryPermissions.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class UploaderWidget extends StatefulWidget {
  @override
  UploaderWidgetState createState() => UploaderWidgetState();
}

class UploaderWidgetState extends State<UploaderWidget> {
  bool permissionsGranted = false;

  File pickedFile;
  CancelToken cancelToken;
  int totalBytes = -1;
  int sentBytes = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _platform = MethodChannel("com.limitedeternity.methodChannel");

  @override
  void initState() {
    super.initState();

    queryPermissions().then((void _) {
      setState(() {
        permissionsGranted = true;
      });
    }).then((void _) async {
      String sharedFilePath = await _platform.invokeMethod("getSharedFile");
      if (sharedFilePath != null) {
        runUpload(File(sharedFilePath));
      }
    });
  }

  void pickFileAndUpload() {
    FilePicker.getFile().then((File file) {
      runUpload(file);
    });
  }

  Future<void> runUpload(File file) async {
    int size = await file.length();

    setState(() {
      pickedFile = file;
      cancelToken = CancelToken();
      totalBytes = size;
    });

    try {
      Response response = await Dio().post(
        "https://file.io",
        cancelToken: cancelToken,
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: file.path.split("/").last,
          ),
        }),
        options: Options(
          headers: {
            Headers.contentLengthHeader: size,
          },
          responseType: ResponseType.json,
        ),
        onSendProgress: (int sent, int _) {
          setState(() {
            sentBytes = sent;
          });
        },
      );

      if (response.data["link"] != null) {
        Share.share(
          "https://bdb64.herokuapp.com/?decode=" +
              base64.encode(utf8.encode(response.data["link"])),
          subject: file.path.split("/").last,
        );
      }
    } on DioError catch (e) {
      if (!CancelToken.isCancel(e)) {
        if (e.response != null) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Service unavailable",
              ),
            ),
          );
        } else {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Unable to reach the server",
              ),
            ),
          );
        }
      }
    } finally {
      setState(() {
        pickedFile = null;
        cancelToken = null;
        totalBytes = -1;
        sentBytes = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 48, 53, 62),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(127, 0, 0, 0),
              offset: Offset(0, 8),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                boxShadow: [
                  Shadows.primaryShadow,
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 14, top: 78, right: 112),
                    child: Text(
                      "GetItUploaded",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "SF Pro Display",
                        fontWeight: FontWeight.w700,
                        fontSize: 34,
                        letterSpacing: 0.41,
                        height: 1.20588,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 288,
                height: 98,
                margin: EdgeInsets.only(top: 166),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 288,
                        height: 98,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 0.7,
                        child: pickedFile != null
                            ? SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  value: sentBytes / totalBytes,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryBackground,
                                  ),
                                  backgroundColor:
                                      AppColors.secondaryBackground,
                                ),
                              )
                            : Text(
                                "Waiting for upload…",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "SF Pro Text",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.3125,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  if (!permissionsGranted) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          "I need that storage permission yesterday.",
                        ),
                      ),
                    );

                    Future.delayed(
                        Duration(milliseconds: 800), openAppSettings);
                    return;
                  }

                  if (pickedFile != null) {
                    cancelToken?.cancel("cancelled");
                    return;
                  }

                  pickFileAndUpload();
                },
                customBorder: CircleBorder(),
                child: Container(
                  width: 62,
                  height: 62,
                  margin: EdgeInsets.only(bottom: 45),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                            borderRadius: Radii.k32pxRadius,
                          ),
                          child: Container(),
                        ),
                      ),
                      Icon(
                        pickedFile != null ? Icons.close : Icons.file_upload,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
