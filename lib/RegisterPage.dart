import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_myapp/controller/RegisterController.dart';
import 'package:test_myapp/model/auth_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final RegisterController registerController = RegisterController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _nicknameController = TextEditingController();

  XFile? _fileAvatar;

  @override
  void dispose() {
    _fullnameController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  changeAvatar() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        this._fileAvatar = file;
      });
    }
  }

  _onRegister() async {
    if (this._fileAvatar == null || !_formKey.currentState!.validate()) return;

    final result = await this.registerController.onRegister(
      username: this._usernameController.text, 
      password: this._passwordController.text, 
      fullname: this._fullnameController.text,
      nickname: this._nicknameController.text,
      profile: File(this._fileAvatar!.path)
    );
    if (result.status) {
      log((result.data as AuthModel).toJson());
    } else {
      log("", error: result.message ?? "ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register")
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: ClipOval(
                    child: InkWell(
                      onTap: changeAvatar,
                      child: _fileAvatar == null 
                      ? Container(
                        color: Colors.grey[400],
                        width: 220,
                        height: 220,
                      )
                      : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(_fileAvatar!.path)),
                            fit: BoxFit.cover
                          )
                        ),
                        width: 220,
                        height: 220,
                      ),
                    ),
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Column(children: [
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
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password"
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "กรุณากรอกชื่อผู้ใช้งาน";
                        }
                      },
                    ),
                    TextFormField(
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        labelText: "Fullname"
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "กรุณากรอกชื่อ-นามสกุล";
                        }
                      },
                    ),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        labelText: "Nickname",
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "กรุณากรอกชื่อเล่น";
                        }
                      },
                    ),
                  ])
                ),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _onRegister, 
                    child: Text("Register")
                  ),
                )
              ]
            ),
          )
        )
      )
    );
  }
}