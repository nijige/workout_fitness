import 'package:flutter/material.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/common_widget/round_textfield.dart';
import 'package:workout_app/models/database_helper.dart';
import 'package:workout_app/view/login/what_your_goal_view.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  _CompleteProfileViewState createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String? selectedGender;

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Vamos completar seu perfil",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Isso nos ajudará a saber mais sobre você!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(height: media.width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      _buildGenderDropdown(media),
                      SizedBox(height: media.width * 0.04),
                      _buildRoundTextField(
                        controller: txtDate,
                        hitText: "Data de Nascimento",
                        icon: "assets/img/date.png",
                      ),
                      SizedBox(height: media.width * 0.04),
                      _buildWeightHeightRow(media),
                      SizedBox(height: media.width * 0.04),
                      _buildHeightRow(media),
                      SizedBox(height: media.width * 0.07),
                      _buildRoundButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(Size media) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              "assets/img/gender.png",
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: TColor.gray,
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: selectedGender,
                items: ["Masculino", "Feminino"]
                    .map(
                      (name) => DropdownMenuItem(
                        value: name,
                        child: Text(
                          name,
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value as String?;
                  });
                },
                isExpanded: true,
                hint: Text(
                  "Escolha o Gênero",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRoundTextField({
    required TextEditingController controller,
    required String hitText,
    required String icon,
  }) {
    return RoundTextField(
      controller: controller,
      hitText: hitText,
      icon: icon,
    );
  }

  Widget _buildWeightHeightRow(Size media) {
    return Row(
      children: [
        Expanded(
          child: _buildRoundTextField(
            controller: txtWeight,
            hitText: "Seu Peso",
            icon: "assets/img/weight.png",
          ),
        ),
        const SizedBox(width: 8),
        _buildUnitContainer("KG"),
      ],
    );
  }

  Widget _buildHeightRow(Size media) {
    return Row(
      children: [
        Expanded(
          child: _buildRoundTextField(
            controller: txtHeight,
            hitText: "Sua Altura",
            icon: "assets/img/hight.png",
          ),
        ),
        const SizedBox(width: 8),
        _buildUnitContainer("CM"),
      ],
    );
  }

  Widget _buildUnitContainer(String unit) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.secondaryG,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        unit,
        style: TextStyle(color: TColor.white, fontSize: 12),
      ),
    );
  }

  Widget _buildRoundButton() {
    return RoundButton(
      title: "Próximo >",
      onPressed: () async {
        try {
          // Verificar se todos os campos foram preenchidos
          if (selectedGender == null ||
              txtDate.text.isEmpty ||
              txtWeight.text.isEmpty ||
              txtHeight.text.isEmpty) {
            // Exibir mensagem de erro se algum campo estiver vazio
            _showErrorDialog(context, "Por favor, preencha todos os campos.");
            return;
          }

          // Verificar se os campos numéricos foram preenchidos corretamente
          double? weight = double.tryParse(txtWeight.text);
          double? height = double.tryParse(txtHeight.text);

          if (weight == null || height == null) {
            // Exibir mensagem de erro se peso ou altura não forem números válidos
            _showErrorDialog(
              context,
              "Por favor, insira valores numéricos válidos para peso e altura.",
            );
            return;
          }

          // Salvar perfil no banco de dados
          await dbHelper.saveUserProfile(
            selectedGender!,
            txtDate.text,
            weight,
            height,
          );

          // Navegar para a próxima tela
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WhatYourGoalView(),
            ),
          );
        } catch (e) {
          print("Erro ao prosseguir: $e");
        }
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
