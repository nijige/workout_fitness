import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/models/database_helper.dart';
import 'package:workout_app/view/login/complete_profile_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger;
  late BuildContext myContext;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Builder(
              builder: (BuildContext context) {
                myContext = context; // Store the context

                scaffoldMessenger = ScaffoldMessenger.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Olá,",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    Text(
                      "Bem-vindo de volta",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: Image.asset("assets/img/email.png")),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        prefixIcon: Image.asset("assets/img/lock.png"),
                        suffixIcon: TextButton(
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "assets/img/show_password.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: TColor.gray,
                            ),
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 10,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    const Spacer(),
                    RoundButton(
                      title: "Login",
                      onPressed: () async {
                        String email = emailController.text.trim();
                        String password = passwordController.text;

                        if (email.isEmpty || password.isEmpty) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Por favor, preencha todos os campos.'),
                            ),
                          );
                          return;
                        }

                        try {
                          print(
                              "Verificando credenciais para E-mail: $email, Senha: $password");

                          bool? result =
                              await dbHelper.checkLogin(email, password);

                          if (result != null && result) {
                            print(
                                "Login bem-sucedido para E-mail: $email, Senha: $password");

                            int userId =
                                await dbHelper.getUserId(email, password);

                            await _saveUserId(userId);

                            try {
                              Navigator.pushReplacement(
                                myContext,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompleteProfileView(),
                                ),
                              );
                            } catch (e) {
                              print(
                                  "Erro durante a navegação para CompleteProfileView: $e");
                            }
                          } else {
                            print(
                                "Login falhou para E-mail: $email, Senha: $password");

                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Credenciais inválidas.'),
                              ),
                            );
                          }
                        } catch (e) {
                          print("Erro durante o login: $e");
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: const Text('Erro durante o login.'),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: TColor.gray.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          "  Ou  ",
                          style: TextStyle(color: TColor.black, fontSize: 12),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: TColor.gray.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: TColor.white,
                              border: Border.all(
                                width: 1,
                                color: TColor.gray.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              "assets/img/google.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: media.width * 0.04,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: TColor.white,
                              border: Border.all(
                                width: 1,
                                color: TColor.gray.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              "assets/img/facebook.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Ainda não tem uma conta? ",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Registrar",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserId(int userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_id', userId);
    } catch (e) {
      print("Erro ao salvar o ID do usuário nas SharedPreferences: $e");
    }
  }
}
