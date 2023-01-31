import 'package:applying_pressure/login/auth.dart';
import 'package:flutter/material.dart';

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
                          const Text('Email'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Email", emailController),
                          const Text('Password'),
                          const SizedBox(height: 8.0),
                          _createTextFormField("Password", passwordController),
                          !isLoading
                              ? _createSubmitButton()
                              : const Center(
                              child: CircularProgressIndicator()),
                        ])))));
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

  Widget _createSubmitButton() {
    return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 83, 80, 80))),
              onPressed: (() async {
                if (_formKey.currentState!.validate()) {

                  setState(() {
                    isLoading = true;
                  });

                  await Auth().signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);

                  setState(() {
                    isLoading = false;
                  });
                }

              }),
              child: const Text("Submit", style: TextStyle(fontSize: 20))),
        ));
  }
}
