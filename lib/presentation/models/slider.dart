import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SlideModel {
  String title;
  String imagePath;
  List<Widget> instruction;

  SlideModel({required this.title, required this.imagePath, required this.instruction});
}

List<SlideModel> getSlides() {
  // todo если не будет переводдить, то в конструктор добавить BuildContext context
  List<SlideModel> slides = [];

  SlideModel slideModel1 = new SlideModel(
    imagePath: 'onb_img1'.tr(),
    title: 'onb_title1'.tr(),
    instruction: [Text('onb_text1'.tr(), style: TextStyle(color: Colors.grey.shade600))],
  );
  slides.add(slideModel1);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel2 = new SlideModel(
    imagePath: 'onb_img2'.tr(),
    title: 'onb_title2'.tr(),
    instruction: [Text('onb_text2'.tr(), style: TextStyle(color: Colors.grey.shade600))],
  );
  slides.add(slideModel2);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel3 = new SlideModel(
    imagePath: 'onb_img3'.tr(),
    title: 'onb_title3'.tr(),
    instruction: [Text('onb_text3'.tr(), style: TextStyle(color: Colors.grey.shade600))],
  );
  slides.add(slideModel3);
  //-----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------
  SlideModel slideModel4 = new SlideModel(
    imagePath: 'onb_img4'.tr(),
    title: 'onb_title4'.tr(),
    instruction: [
      Text('onb_text4'.tr(), style: TextStyle(color: Colors.grey.shade600)),
      Container(
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10.0)),
        child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.battery_charging_full_rounded, size: 30.0, color: Colors.white),
                    SizedBox(width: 20.0),
                    Text('button_battery_optimization'.tr(),
                        style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
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
