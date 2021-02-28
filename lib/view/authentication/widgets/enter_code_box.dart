import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:onehub/app/Dio/response_handler.dart';
import 'package:onehub/common/bottom_sheet.dart';
import 'package:onehub/models/authentication/device_code_model.dart';
import 'package:onehub/models/popup/popup_type.dart';
import 'package:onehub/providers/authentication/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterCodeBox extends StatefulWidget {
  final DeviceCodeModel deviceCode;
  EnterCodeBox(this.deviceCode);
  @override
  _EnterCodeBoxState createState() => _EnterCodeBoxState();
}

class _EnterCodeBoxState extends State<EnterCodeBox> {
  int expiresIn;
  Timer _timer;
  bool statusCheck;
  AuthProvider authStatus;

  @override
  void initState() {
    authStatus = context.read<AuthProvider>();
    expiresIn = widget.deviceCode.expiresIn;
    statusCheck = true;
    decrementTimer();
    copyCode();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    statusCheck = false;
    super.dispose();
  }

  void decrementTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        expiresIn--;
      });
      if (expiresIn == 0) {
        _timer.cancel();
        authStatus.setStatusUnauthenticated();
        ResponseHandler.setErrorMessage(AppPopupData(title: 'Code Expired'));
      }
    });
  }

  void copyCode({bool pop = false}) async {
    Clipboard.setData(ClipboardData(text: widget.deviceCode.userCode));
    if (pop) {
      Navigator.pop(context);
    } else {
      await Future.delayed(Duration(milliseconds: 250));
    }
    ResponseHandler.setSuccessMessage(
        AppPopupData(title: 'Copied Code ${widget.deviceCode.userCode}'));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      width: 300,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Enter the following code'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    showBottomActionsMenu(context,
                        header: Text(
                          widget.deviceCode.userCode,
                          style: TextStyle(fontSize: 20),
                        ),
                        childWidget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              copyCode(pop: true);
                            },
                            title: Text("Copy to Clipboard"),
                            trailing: Icon(
                              LineIcons.copy,
                              color: Colors.white,
                            ),
                          ),
                        ));
                  },
                  child: Text(widget.deviceCode.userCode)),
            ),
            Text("Expires in ${(expiresIn ~/ 60)}:${expiresIn % 60}"),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text(
                    widget.deviceCode.verificationUri,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    showBottomActionsMenu(context,
                        header: Text(widget.deviceCode.verificationUri),
                        childWidget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              canLaunch(widget.deviceCode.verificationUri)
                                  .then((value) {
                                Navigator.pop(context);
                                if (value) {
                                  launch(widget.deviceCode.verificationUri);
                                } else {
                                  ResponseHandler.setErrorMessage(
                                      AppPopupData(title: 'Invalid URL'));
                                }
                              });
                            },
                            title: Text("Open"),
                            trailing: Icon(LineIcons.alternateFontAwesome),
                          ),
                        ));
                  },
                ),
              ),
            ),
            MaterialButton(
              child: Text('Back'),
              onPressed: () {
                setState(() {
                  auth.setStatusUnauthenticated();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
