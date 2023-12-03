import 'package:workout_app/common_widget/on_boarding_page.dart';
import 'package:workout_app/view/login/signup_view.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;

      setState(() {});
    });
  }

  List<Map<String, String>> pageArr = [
    {
      "title": "Acompanhe Seu Objetivo",
      "subtitle":
          "Não se preocupe se tiver dificuldade em determinar seus objetivos. Podemos ajudar a determinar e acompanhar seus objetivos.",
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Queime Calorias",
      "subtitle":
          "Vamos continuar queimando para alcançar seus objetivos. A dor é apenas temporária. Se desistir agora, sentirá dor para sempre.",
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Alimente-se Bem",
      "subtitle":
          "Vamos começar um estilo de vida saudável. Podemos determinar sua dieta diariamente. Comer saudável é divertido.",
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Melhore a Qualidade do Sono",
      "subtitle":
          "Melhore a qualidade do seu sono conosco. Um sono de boa qualidade pode trazer um bom humor pela manhã.",
      "image": "assets/img/on_4.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index];
                return OnBoardingPage(pObj: pObj);
              },
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: SizedBox(
                width: 80,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        color: TColor.primaryColor1,
                        value: (selectPage + 1) / 4,
                        strokeWidth: 2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: TColor.primaryColor1,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.navigate_next,
                          color: TColor.white,
                        ),
                        onPressed: () {
                          if (selectPage < 3) {
                            selectPage = selectPage + 1;

                            controller.animateToPage(selectPage,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.bounceInOut);

                            setState(() {});
                          } else {
                            print("Abrir Tela de Boas-Vindas");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpView(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
