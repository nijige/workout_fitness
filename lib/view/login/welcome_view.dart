import 'package:flutter/material.dart';
import 'package:workout_app/common/colo_extension.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/models/auth_service.dart';
import '../main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: media.width * 0.1),
              Image.asset(
                "assets/img/welcome.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: media.width * 0.1),
              FutureBuilder<String?>(
                future: _getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Erro: ${snapshot.error}");
                  } else {
                    var userName = snapshot.data ?? "Usuário";
                    return Column(
                      children: [
                        Text(
                          "Bem-vinda, $userName",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Você está pronta agora, vamos alcançar seus\nobjetivos juntas conosco",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                        ),
                      ],
                    );
                  }
                },
              ),
              const Spacer(),
              _buildRoundButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getUserName() async {
    var user = _authService.getLoggedInUser();
    return user?.displayName;
  }

  Widget _buildRoundButton(BuildContext context) {
    return RoundButton(
      title: "Ir para a Página Inicial",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainTabView(),
          ),
        );
      },
    );
  }
}
