import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common/common.dart';
import 'package:workout_app/common_widget/icon_title_next_row.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/models/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class AddScheduleView extends StatefulWidget {
  final DateTime date;

  const AddScheduleView({Key? key, required this.date}) : super(key: key);

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String selectedWorkout = "";
  String selectedDifficulty = "";
  String selectedTime = DateFormat('HH:mm').format(DateTime.now());
  String selectedRepetitions = "";
  String selectedWeights = "";
  TextEditingController controller = TextEditingController();

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
        title: Text(
          "Adicionar Agenda",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/img/date.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
                  style: TextStyle(color: TColor.gray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Hora",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                onDateTimeChanged: (newDate) {
                  setState(() {
                    selectedTime = DateFormat('HH:mm').format(newDate);
                  });
                },
                initialDateTime: DateTime.now(),
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Detalhes do Treino",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            IconTitleNextRow(
                icon: "assets/img/choose_workout.png",
                title: "Escolher Treino",
                time: selectedWorkout.isEmpty
                    ? "Selecione um treino"
                    : selectedWorkout,
                color: TColor.lightGray,
                onPressed: () async {
                  final selected = await selectWorkout(context);
                  if (selected != null) {
                    setState(() {
                      selectedWorkout = selected;
                    });
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/difficulity.png",
                title: "Dificuldade",
                time: selectedDifficulty.isEmpty
                    ? "Selecione a dificuldade"
                    : selectedDifficulty,
                color: TColor.lightGray,
                onPressed: () async {
                  final selected = await selectDifficulty(context);
                  if (selected != null) {
                    setState(() {
                      selectedDifficulty = selected;
                    });
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/repetitions.png",
                title: "Repetições Personalizadas",
                time: selectedRepetitions.isEmpty
                    ? "Selecione as repetições"
                    : selectedRepetitions,
                color: TColor.lightGray,
                onPressed: () async {
                  final selected = await customizeRepetitions(context);
                  if (selected != null) {
                    setState(() {
                      selectedRepetitions = selected;
                    });
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/repetitions.png",
                title: "Pesos Personalizados",
                time: selectedWeights.isEmpty
                    ? "Selecione os pesos"
                    : selectedWeights,
                color: TColor.lightGray,
                onPressed: () async {
                  final selected = await customizeWeights(context);
                  if (selected != null) {
                    setState(() {
                      selectedWeights = selected;
                    });
                  }
                }),
            Spacer(),
            RoundButton(
                title: "Salvar",
                onPressed: () {
                  userSchedule(context);
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> selectWorkout(BuildContext context) async {
    List<String> workouts = ["Treino 1", "Treino 2", "Treino 3"];
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Selecione um treino'),
          children: workouts
              .map((workout) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, workout);
                    },
                    child: Text(workout),
                  ))
              .toList(),
        );
      },
    );
  }

  Future<String?> selectDifficulty(BuildContext context) async {
    List<String> difficulties = ["Fácil", "Médio", "Difícil"];
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Selecione a dificuldade'),
          children: difficulties
              .map((difficulty) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, difficulty);
                    },
                    child: Text(difficulty),
                  ))
              .toList(),
        );
      },
    );
  }

  Future<String?> customizeRepetitions(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Repetições Personalizadas'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Digite as repetições'),
            onChanged: (value) {
              // Pode usar o valor digitado conforme necessário.
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Repetições: ${controller.text}');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> customizeWeights(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesos Personalizados'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Digite os pesos'),
            onChanged: (value) {
              // Pode usar o valor digitado conforme necessário.
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Pesos: ${controller.text}');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void userSchedule(BuildContext context) async {
    try {
      if (selectedTime.isEmpty ||
          selectedWorkout.isEmpty ||
          selectedDifficulty.isEmpty) {
        print("Preencha todos os campos obrigatórios.");
        return;
      }

      Map<String, dynamic> schedule = {
        'date': dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
        'time': selectedTime,
        'workout': selectedWorkout,
        'difficulty': selectedDifficulty,
        'repetitions': selectedRepetitions,
        'weights': selectedWeights,
      };

      int result = await dbHelper.insertSchedule(schedule);

      print('Resultado da inserção: $result');

      if (result != -1) {
        print('Agendamento salvo com sucesso.');
        Navigator.pop(context);
      } else {
        print('Erro ao salvar o agendamento.');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }
}
