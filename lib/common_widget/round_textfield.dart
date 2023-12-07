import 'package:flutter/material.dart';
import '../common/colo_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hitText;
  final dynamic icon; // Modifique o tipo aqui para aceitar String ou IconData
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;

  const RoundTextField({
    super.key,
    required this.hitText,
    this.controller,
    this.margin,
    this.keyboardType,
    required this.icon, // Modifique o tipo aqui para aceitar String ou IconData
    this.obscureText = false,
    this.rigtIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    // Verifique se o ícone é uma String ou IconData
    if (icon is String) {
      iconWidget = Container(
        alignment: Alignment.center,
        width: 20,
        height: 20,
        child: Image.asset(
          icon,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          color: TColor.gray,
        ),
      );
    } else if (icon is IconData) {
      iconWidget = Icon(
        icon,
        size: 20,
        color: TColor.gray,
      );
    } else {
      throw ArgumentError('O ícone deve ser uma String ou IconData.');
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hitText,
          suffixIcon: rigtIcon,
          prefixIcon: iconWidget, // Use o widget criado para o ícone
          hintStyle: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      ),
    );
  }
}
