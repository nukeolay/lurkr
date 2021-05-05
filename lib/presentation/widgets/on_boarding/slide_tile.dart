import 'package:flutter/material.dart';

class SlideTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<Widget> instruction;
  final double height;

  SlideTile({
    required this.title,
    required this.imagePath,
    required this.instruction,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.03, horizontal: height * 0.03),
            child: Image.asset(imagePath),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: height * 0.015),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.035, horizontal: height * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  //Text(
                  Column(
                    children: instruction,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
