import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/common_widget/step_detail_row.dart';
import 'package:workout_app/models/database_helper.dart'; // Importe o seu DatabaseHelper

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;

  const ExercisesStepDetails({Key? key, required this.eObj});

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Instancie seu DatabaseHelper aqui

  List<Map<String, String>> stepArr = [
    {
      "no": "01",
      "title": "Estenda os Braços",
      "detail":
          "Para tornar os gestos mais relaxados, estenda os braços ao começar este movimento. Sem dobrar as mãos."
    },
    {
      "no": "02",
      "title": "Descanso na Ponta dos Pés",
      "detail":
          "A base deste movimento é pular. Agora, o que precisa ser considerado é que você tem que usar as pontas dos seus pés."
    },
    {
      "no": "03",
      "title": "Ajuste do Movimento dos Pés",
      "detail":
          "Jumping Jack não é apenas um salto comum. Mas, você também precisa prestar atenção aos movimentos das pernas."
    },
    {
      "no": "04",
      "title": "Bater Palmas",
      "detail":
          "Isso não pode ser levado de ânimo leve. Você vê, sem perceber, bater palmas ajuda você a manter o ritmo enquanto faz o Jumping Jack."
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.asset(
                      "assets/img/video_temp.png",
                      width: media.width,
                      height: media.width * 0.43,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        color: TColor.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/img/Play.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.eObj["title"].toString(),
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Fácil | 390 Calorias Queimadas",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Descrições",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              ReadMoreText(
                'O jumping jack, também conhecido como star jump e chamado de side-straddle hop nas forças armadas dos EUA, é um exercício físico realizado pulando para uma posição com as pernas abertas. O jumping jack, também conhecido como star jump e chamado de side-straddle hop nas forças armadas dos EUA, é um exercício físico realizado pulando para uma posição com as pernas abertas.',
                trimLines: 4,
                colorClickableText: TColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Leia Mais ...',
                trimExpandedText: ' Leia Menos',
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
                moreStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Como Fazer",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${stepArr.length} Séries",
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  )
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stepArr.length,
                itemBuilder: ((context, index) {
                  var sObj = stepArr[index] as Map<String, String>? ?? {};

                  return StepDetailRow(
                    sObj: sObj,
                    isLast: stepArr.last == sObj,
                  );
                }),
              ),
              Text(
                "Repetições Personalizadas",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: TColor.gray.withOpacity(0.2), width: 1),
                        bottom: BorderSide(
                            color: TColor.gray.withOpacity(0.2), width: 1),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/burn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          " ${(index + 1) * 15} Calorias Queimadas",
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " vezes",
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        )
                      ],
                    );
                  },
                ),
              ),
              RoundButton(
                  title: "Salvar",
                  elevation: 0,
                  onPressed: () {
                    saveExerciseDetails();
                  }),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveExerciseDetails() async {
    Map<String, dynamic> exerciseDetails = {
      'title': widget.eObj["title"].toString(),
      // Adicione outras propriedades que você deseja salvar
    };

    int result = await dbHelper.insertExerciseDetails(exerciseDetails);

    if (result != -1) {
      // Os detalhes do exercício foram salvos com sucesso.
      Navigator.pop(context);
    } else {
      // Ocorreu um erro ao salvar os detalhes do exercício.
      print('Erro ao salvar os detalhes do exercício');
    }
  }
}
