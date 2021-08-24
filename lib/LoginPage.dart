import 'package:flutter/material.dart';
import 'package:test_myapp/controller/AuthController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = AuthController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _loinInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final result = await authController.loginWithEmail(
      username: _usernameController.text, 
      password: _passwordController.text
    );
    if (!result.status) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset("assets/logo.png", 
                  width: 180,
                  fit: BoxFit.cover,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username"
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "กรุณากรอกชื่อผู้ใช้งาน";
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password"
                        ),
                        obscureText: true,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "กรุณากรอกพาสเวิร์ด";
                          }
                        },
                      )
                    ]
                  )
                ),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                    ),
                    onPressed: _loinInWithEmail,
                    child: Text("Login"),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.centerRight
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      }, 
                      child: Text("Register")
                    ),
                  ],
                ),
              ]
            )
          ),
        )
      )
    );
  }
}