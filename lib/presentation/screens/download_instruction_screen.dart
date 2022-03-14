import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:lurkr/presentation/widgets/account_list/custom_scroll_behavoir.dart';

class DownloadInstructionScreen extends StatelessWidget {
  const DownloadInstructionScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('instruction_download_1'.tr(),
                        style: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('instruction_download_img_1'.tr(), fit: BoxFit.cover),
                    ),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600, width: 2.0), borderRadius: BorderRadius.circular(10.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 5.0, right: 5.0),
                    child: Text('instruction_download_2'.tr(),
                        style: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('instruction_download_img_2'.tr()),
                    ),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade600, width: 2.0), borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10.0)),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text('button_close'.tr(),
                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
