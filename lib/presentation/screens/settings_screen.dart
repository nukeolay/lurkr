import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: GestureDetector(
                          child: IconButton(
                            tooltip: 'Back',
                            splashRadius: 22,
                            splashColor: Colors.purple,
                            highlightColor: Colors.deepPurple,
                            icon: const Icon(Icons.arrow_back_rounded, size: 25),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 48.0),
                          alignment: Alignment.center,
                          height: 30,
                          color: Colors.white,
                          child: Text(
                            'Settings',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text('Theme',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dark mode',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Switch.adaptive(value: false, onChanged: null),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Automatic refresh period',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('off',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 0, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('30 minutes',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 1, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1 hour',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 2, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('2 hour',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 3, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('6 hours',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 4, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('12 hours',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 5, groupValue: 1, onChanged: null),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('24 hours',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          Radio(value: 6, groupValue: 1, onChanged: null),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
