import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SlideModel {
  final String title;
  final String imagePath;
  final List<Widget> instruction;

  SlideModel({required this.title, required this.imagePath, required this.instruction});
}

List<SlideModel> getSlides(BuildContext context) {
  final double height = MediaQuery.of(context).size.height; //TODO если не будет переводдить, то в конструктор добавить BuildContext context
  List<SlideModel> slides = [];

  SlideModel slideModel1 = new SlideModel(
    imagePath: 'onb_img1'.tr(),
    title: 'onb_title1'.tr(),
    instruction: [Text('onb_text1'.tr(), style: TextStyle(color: Colors.grey.shade700, fontSize: height * 0.02))],
  );
  slides.add(slideModel1);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel2 = new SlideModel(
    imagePath: 'onb_img2'.tr(),
    title: 'onb_title2'.tr(),
    instruction: [Text('onb_text2'.tr(), style: TextStyle(color: Colors.grey.shade700, fontSize: height * 0.02))],
  );
  slides.add(slideModel2);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel3 = new SlideModel(
    imagePath: 'onb_img3'.tr(),
    title: 'onb_title3'.tr(),
    instruction: [Text('onb_text3'.tr(), style: TextStyle(color: Colors.grey.shade700, fontSize: height * 0.02))],
  );
  slides.add(slideModel3);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel4 = new SlideModel(
    imagePath: 'onb_img4'.tr(),
    title: 'onb_title4'.tr(),
    instruction: [
      Text('onb_text4'.tr(), style: TextStyle(color: Colors.grey.shade700, fontSize: height * 0.02)),
      Container(
        height: height * 0.06,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: height * 0.015),
        decoration: BoxDecoration(color: Colors.green.shade400, borderRadius: BorderRadius.circular(10.0)),
        child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: height * 0.06,
              alignment: Alignment.center,
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.check_box_rounded, size: height * 0.03, color: Colors.white),
                    SizedBox(width: height * 0.03),
                    Text('button_battery_optimization'.tr(),
                        style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: height * 0.02, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            onPressed: () {
              Permission.ignoreBatteryOptimizations.request();
            }),
      ),
    ],
  );
  slides.add(slideModel4);
  return slides;
}
