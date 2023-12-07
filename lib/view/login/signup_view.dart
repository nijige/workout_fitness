import 'package:flutter/material.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:path/path.dart';
import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/common_widget/round_textfield.dart';
import 'package:workout_app/view/login/complete_profile_view.dart';
import 'package:workout_app/view/login/login_view.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'workout_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, nome TEXT, sobrenome TEXT, email TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<bool> isUserRegistered(String email) async {
    await initializeDatabase();
    final result = await _database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    await initializeDatabase();
    await _database.insert('users', user);
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  final nome = TextEditingController();
  final sobrenome = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool inVisible = false;

  final DatabaseHelper dbHelper = DatabaseHelper();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Olá,",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Text(
                  "Criar uma Conta",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  controller: nome,
                  hitText: "Nome",
                  icon: Icons.person,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: sobrenome,
                  hitText: "Sobrenome",
                  icon: Icons.person,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: email,
                  hitText: "E-mail",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: password,
                  hitText: "Senha",
                  icon: Icons.lock,
                  obscureText: !inVisible,
                  rigtIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        inVisible = !inVisible;
                      });
                    },
                    icon: Icon(
                      inVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isCheck,
                      onChanged: (value) {
                        setState(() {
                          isCheck = value!;
                        });
                      },
                    ),
                    const Flexible(
                      child: Text(
                        "Ao continuar, você aceita nossa Política de Privacidade e\nTermos de Uso",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                RoundButton(
                  title: "Registrar",
                  onPressed: () async {
                    // Adicione validações aqui
                    if (nome.text.isEmpty ||
                        sobrenome.text.isEmpty ||
                        email.text.isEmpty ||
                        password.text.isEmpty) {
                      // Exibe um SnackBar com a mensagem de erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Por favor, preencha todos os campos.'),
                        ),
                      );
                      return;
                    }

                    try {
                      final Map<String, dynamic> user = {
                        'nome': nome.text,
                        'sobrenome': sobrenome.text,
                        'email': email.text,
                        'password': password.text,
                      };

                      // Verificar se o usuário já está registrado
                      if (await dbHelper.isUserRegistered(email.text)) {
                        print(
                            'Usuário já registrado. Redirecionando para o login.');
                        // Redirecionar para a tela de login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                        return;
                      }

                      // Insert user data into the database
                      await dbHelper.insertUser(user);

                      // Exibe um SnackBar com a mensagem de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Usuário cadastrado com sucesso!'),
                        ),
                      );

                      // Navega para a tela de perfil completo
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompleteProfileView(),
                        ),
                      );

                      print("Registro do usuário concluído com sucesso!");
                    } catch (e) {
                      print("Erro durante o registro do usuário: $e");
                      // Captura qualquer exceção e define a mensagem de erro
                      setState(() {
                        errorMessage = 'Erro durante o registro do usuário: $e';
                      });
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
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    const Text(
                      "  Ou  ",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.5),
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
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.4),
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
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.4),
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
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Registrar",
                        style: TextStyle(
                            color: Colors.black,
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
            ),
          ),
        ),
      ),
    );
  }
}
