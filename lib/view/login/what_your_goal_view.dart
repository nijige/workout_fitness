import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:workout_app/view/login/welcome_view.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({Key? key}) : super(key: key);

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  CarouselController buttonCarouselController = CarouselController();

  List<Map<String, String>> goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "Melhorar a Forma",
      "subtitle":
          "Tenho uma baixa quantidade de gordura corporal e preciso/desejo construir mais músculos",
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Magro e Tonificado",
      "subtitle":
          "'Magro gordo'. Pareço magro, mas não tenho forma. Quero adicionar músculo magro da maneira certa",
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Perder Gordura",
      "subtitle":
          "Tenho mais de 20 lbs para perder. Quero perder toda essa gordura e ganhar massa muscular",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: CarouselSlider(
                items: goalArr
                    .map((gObj) => _buildCarouselItem(gObj, media))
                    .toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 0.74,
                  initialPage: 0,
                ),
              ),
            ),
            _buildButtonContainer(context, media),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(Map<String, String> gObj, Size media) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      padding:
          EdgeInsets.symmetric(vertical: media.width * 0.1, horizontal: 25),
      alignment: Alignment.center,
      child: FittedBox(
        child: Column(
          children: [
            Image.asset(
              gObj["image"].toString(),
              width: media.width * 0.5,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: media.width * 0.1),
            Text(
              gObj["title"].toString(),
              style: TextStyle(
                  color: TColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: media.width * 0.1,
              height: 1,
              color: TColor.white,
            ),
            SizedBox(height: media.width * 0.02),
            Text(
              gObj["subtitle"].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: TColor.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContainer(BuildContext context, Size media) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: media.width,
      child: Column(
        children: [
          _buildRoundButton(context),
        ],
      ),
    );
  }
}

Widget _buildRoundButton(BuildContext context) {
  return RoundButton(
    title: "Confirmar",
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeView(),
        ),
      );
    },
  );
}
