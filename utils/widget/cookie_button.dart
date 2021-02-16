import 'package:flutter/material.dart';

class CookieButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  CookieButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      height: 64,
      width: MediaQuery.of(context).size.width * .4,
      child: RaisedButton(
          child: FittedBox(
              child: Text(text,
                  style: TextStyle(color: Colors.white, fontSize: 18))),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.deepPurple,
          onPressed: onPressed));
}
