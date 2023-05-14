// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertest/layout/home_layout.dart';
import 'package:fluttertest/shared/components/componets.dart';
import 'package:fluttertest/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoarding extends StatefulWidget {
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  var boardController = PageController();
  bool isFinish = false;
  int _currentPage = 0;
  List<BoardingModel> boarding = [
    BoardingModel(
      image: "assets/images/6206973.jpg",
      title: "ON BOARD 1",
      body: "ON BOARD BODY",
    ),
    BoardingModel(
      image: "assets/images/2113097.jpg",
      title: "ON BOARD 2",
      body: "ON BOARD BODY",
    ),
    BoardingModel(
      image: "assets/images/Checklist.jpg",
      title: "ON BOARD 3",
      body: "ON BOARD BODY",
    ),
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      boardController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              navigateAndFinish(context, HomeLayout());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SKIP",
                style: TextStyle(color: defaultColor, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  controller: boardController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildOnBoarding(boarding[index]),
                  itemCount: 3,
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isFinish = true;
                      });
                    } else {
                      setState(() {
                        isFinish = false;
                      });
                      Future.delayed(Duration(seconds: 4), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeLayout()),
                        );
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      spacing: 6,
                      dotColor: Colors.black12,
                      activeDotColor: defaultColor,
                      expansionFactor: 4,
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                      onPressed: () {
                        if (isFinish) {
                          navigateAndFinish(context, HomeLayout());
                        }
                        boardController.nextPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      },
                      child: Icon(Icons.arrow_forward_ios))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOnBoarding(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          SizedBox(height: 30),
          Text(
            model.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 15),
          Text(
            model.body,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 30),
        ],
      );
}
