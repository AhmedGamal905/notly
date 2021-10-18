import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double width;
  final Color color;
  const CustomButton({
    @required this.text,
    @required this.onTap,
    this.width,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: "SFProText",
                fontStyle: FontStyle.normal,
                fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}
