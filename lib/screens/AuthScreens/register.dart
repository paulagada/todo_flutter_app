import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class Register extends StatefulWidget {
  final PageController pageController;

  const Register({super.key, required this.pageController});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with AppStorage, Api {
  TextEditingController cPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegistrationFormData data = RegistrationFormData();
  bool isObscure = true;
  bool cPIsObscure = true;
  bool loading = false;

  void performRegistration() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var response = await context.read<AuthProvider>().registerUser(
          data.payLoad,
        );
        await storeItems("lastEmail", data.email.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"]),
            backgroundColor: Colors.green,
          ),
        );
        widget.pageController.jumpToPage(2);
      }
    } on DioException catch (e) {
      var apiError = handleDioError(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(apiError.message ?? "an error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    data.password.dispose();
    data.email.dispose();
    data.username.dispose();
    cPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Text(
              "Register",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 30,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: loading,
                        controller: data.username,
                        validator: (v) {
                          if (v!.length < 4) {
                            return "username too short";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Username",
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: loading,
                        controller: data.email,
                        validator: (val) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        decoration: const InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: isObscure,
                        readOnly: loading,
                        controller: data.password,
                        validator: (v) {
                          if (v!.length < 6) {
                            return "password too short";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          ),
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.key_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: cPIsObscure,
                        readOnly: loading,
                        controller: cPassword,
                        validator: (v) {
                          if (v! != data.password.text) {
                            return "password not the same";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                cPIsObscure = !cPIsObscure;
                              });
                            },
                            icon: Icon(cPIsObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          ),
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(Icons.key_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed:loading ? null : performRegistration,
                        child: loading ? const CircularProgressIndicator() : const Text("Register"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          text: "Already have an Account? ",
                          children: [
                            TextSpan(
                              text: "Login",
                              style: const TextStyle(color: Colors.red),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                widget.pageController.previousPage(
                                  duration: Durations.short1,
                                  curve: Curves.easeIn,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegistrationFormData {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  get payLoad => {
    "email": email.text.toLowerCase(),
    "password": password.text,
    "username": username.text,
  };
}