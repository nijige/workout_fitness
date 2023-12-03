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
                time: "Upperbody",
                color: TColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/difficulity.png",
                title: "Dificuldade",
                time: "Iniciante",
                color: TColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/repetitions.png",
                title: "Repetições Personalizadas",
                time: "",
                color: TColor.lightGray,
                onPressed: () {}),
            const SizedBox(
              height: 10,
            ),
            IconTitleNextRow(
                icon: "assets/img/repetitions.png",
                title: "Pesos Personalizados",
                time: "",
                color: TColor.lightGray,
                onPressed: () {}),
            Spacer(),
            RoundButton(
                title: "Salvar",
                onPressed: () {
                  userSchedule();
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void userSchedule() async {
    if (selectedTime.isEmpty ||
        selectedWorkout.isEmpty ||
        selectedDifficulty.isEmpty) {
      // Certifique-se de que todos os campos obrigatórios estão preenchidos.
      print("Preencha todos os campos obrigatórios.");
      return;
    }

    Map<String, dynamic> schedule = {
      'date': dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
      'time': selectedTime,
      'workout': selectedWorkout,
      'difficulty': selectedDifficulty,
      'repetitions': '', // Adicione a lógica para obter as repetições.
      'weights': '', // Adicione a lógica para obter os pesos.
    };

    int result = await dbHelper.insertSchedule(schedule);
    if (result != -1) {
      // O agendamento foi salvo com sucesso.
      //Navigator.pop(context);
    } else {
      // Ocorreu um erro ao salvar o agendamento.
      print('Erro ao salvar o agendamento');
    }
  }
}
