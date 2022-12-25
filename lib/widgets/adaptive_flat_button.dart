import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
      child: Text(text),
      onPressed: handler,
    )
        : TextButton(
      child: Text(text),
      onPressed: handler,
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 20),
        ),
        minimumSize: MaterialStateProperty.all(
            const Size(100, 40)
        ),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.lightBlue,
            width: 1,
          ),
        ),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            )
        ),

      ),
    );
  }


}
