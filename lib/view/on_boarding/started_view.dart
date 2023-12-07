import 'package:flutter/material.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/view/on_boarding/on_boarding_view.dart';

class StartedView extends StatefulWidget {
  const StartedView({Key? key}) : super(key: key);

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  bool isChangeColor = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        width: media.width,
        decoration: BoxDecoration(
          gradient: isChangeColor
              ? LinearGradient(
                  colors: TColor.primaryG,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2), // Ajuste de espaço com flexibilidade
            Text(
              "Workout App",
              style: TextStyle(
                color: TColor.black,
                fontSize:
                    media.width * 0.1, // Ajuste de tamanho de fonte responsivo
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Todos Podem Treinar",
              style: TextStyle(
                color: TColor.gray,
                fontSize:
                    media.width * 0.04, // Ajuste de tamanho de fonte responsivo
              ),
            ),
            const Spacer(flex: 2), // Ajuste de espaço com flexibilidade
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.05, // Ajuste de espaço responsivo
                ),
                child: RoundButton(
                  title: "Iniciar",
                  type: isChangeColor
                      ? RoundButtonType.textGradient
                      : RoundButtonType.bgGradient,
                  onPressed: () {
                    if (isChangeColor) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnBoardingView(),
                        ),
                      );
                    } else {
                      setState(() {
                        isChangeColor = true;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
