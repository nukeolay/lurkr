import 'package:flutter/material.dart';
import 'custom_scroll_behavoir.dart';

class SlideTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<Widget> instruction;

  SlideTile({
    required this.title,
    required this.imagePath,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Image.asset(imagePath, height: 280.0),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
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
