import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/service_provider.dart';
import '../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isError = false;
  String loginErrorString = "";

  final textStyle = const TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );

  final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _createHintField("Email"),
                          _createTextFormField("Email", emailController),
                          _createHintField("Password"),
                          _createTextFormField("Password", passwordController),
                          _createSubmitButton(),
                          _createForgotPasswordButton(),
                          _createErrorHint()
                        ])))));
  }

  Widget _createHintField(String hint) {
    return Column(children: const [Text('Email'), SizedBox(height: 8.0)]);
  }

  Widget _createTextFormField(String field, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          obscureText: field == "Password",
          decoration: inputDecoration.copyWith(hintText: field),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Wrong $field';
            }
            return null;
          },
        ));
  }

  Future<bool> _signInWithEmailAndPassword(String email, String password) {
    final authService = ServiceProvider.getAuthService(context);
    return authService.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }

  Widget _createSubmitButton() {
    return !isLoading
        ? Center(
            child: Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 83, 80, 80))),
                onPressed: (() {
                  if (_formKey.currentState!.validate()) {
                    setState(() { isLoading = true; });
                    _signInWithEmailAndPassword(
                        emailController.text,
                        passwordController.text)
                        .then((value) => {
                              setState(() {
                                isLoading = false;
                              })
                            })
                        .onError((error, stackTrace) => {
                           handleError(error as FirebaseAuthException)
                    });
                  }
                }),
                child: const Text("Submit", style: TextStyle(fontSize: 20))),
          ))
        : const Center(child: CircularProgressIndicator());
  }

  void handleError(FirebaseAuthException e) {
    setState(() {
      loginErrorString = e.message ?? "Error logging in";
      isError = true;
      isLoading = false;
    });

  }

  Widget _createErrorHint() {
    return Center(child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Text(isError ? loginErrorString : "")));
  }

  Widget _createForgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.forgotPassword);
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
