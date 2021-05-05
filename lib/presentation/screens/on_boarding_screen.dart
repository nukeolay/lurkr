import 'dart:io';

import 'package:lurkr/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:lurkr/presentation/models/slider.dart';
import 'package:lurkr/presentation/widgets/on_boarding/slide_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingScreen> {
  List<SlideModel> slides = [];
  int currentIndex = 0;
  PageController pageController = new PageController();

  Widget pageIndexIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 5.0 : 5.0,
      width: isCurrentPage ? 15.0 : 5.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.purple : Colors.purpleAccent,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    slides = getSlides(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.purple,
                Colors.orangeAccent,
                Colors.amber,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5.0),
                Image.asset(
                  'assets/on_boarding/on_boarding_logo.png',
                  height: 30,
                ),
                SizedBox(height: 5.0),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: slides.length,
                    onPageChanged: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SlideTile(
                        title: slides[index].title,
                        imagePath: slides[index].imagePath,
                        instruction: slides[index].instruction,
                        height: size.height,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          color: Colors.transparent,
          height: Platform.isIOS ? 70.0 : 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < slides.length; i++) currentIndex == i ? pageIndexIndicator(true) : pageIndexIndicator(false),
                ],
              ),
              currentIndex != slides.length - 1
                  ? GestureDetector(
                      child: Text(
                        'button_next'.tr(),
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 21.0),
                      ),
                      onTap: () {
                        pageController.animateToPage(currentIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                      })
                  : GestureDetector(
                      child: Text('button_start'.tr(),
                          textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 21.0)),
                      onTap: () {
                        BlocProvider.of<AccountListBloc>(context).add(AccountListEventInstructionOk());
                      }),
            ],
          ),
        ));
  }
}
