import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/navigation_page.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class Login extends StatefulWidget {
  final PageController pageController;

  const Login({super.key, required this.pageController});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with AppStorage, Api {
  final _formKey = GlobalKey<FormState>();
  final _dialogFormKey = GlobalKey<FormState>();
  LoginFormData data = LoginFormData();
  bool isObscure = true;
  bool loading = false;
  bool dLoading = false;

  @override
  void initState() {
    getLastEmail();
    super.initState();
  }

  getLastEmail() async {
    data.email.text = await getStorageItem("lastEmail") ?? "";
  }

  void performLogin() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var response = await context.read<AuthProvider>().loginUser(
              data.payLoad,
            );
        if (response['message'] != 'success') {
          await storeItems("lastEmail", data.email.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response["message"]),
              backgroundColor: Colors.red,
            ),
          );
          widget.pageController.jumpToPage(2);
          return;
        }
        await storeItems("token", response["token"]);
        await storeItems("lastEmail", data.email.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"]),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed(
          NavigationPage.path,
        );
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

  forgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, StateSetter setStates) {
          return AlertDialog(
            title: const Text("Enter Email"),
            content: Form(
              key: _dialogFormKey,
              child: TextFormField(
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_),
                child: const Text("cancel",
                style: TextStyle(
                  color: Colors.red,
                ),),
              ),
              TextButton(
                onPressed: dLoading ? null : () async{

                  try {
                    setStates(() {
                      dLoading = true;
                    });
                    await sendOtp();
                    Navigator.pop(_);
                  } finally {
                    setStates(() {
                      dLoading = false;
                    });
                  }
                },
                child:dLoading ? const CircularProgressIndicator() : const Text("Send"),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> sendOtp() async {
    try {
      var response = await context.read<AuthProvider>().sendResetOtp(
        {"email": data.email.text},
      );
      await storeItems("forgetPasswordEmail", data.email.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ),
      );
      widget.pageController.jumpToPage(3);
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
    }
  }

  @override
  void dispose() {
    data.password.dispose();
    data.email.dispose();
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
              "WELCOME!!",
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        prefixIcon: const Icon(Icons.key_outlined),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: forgotPasswordDialog,
                          child: const Text("forgot password?"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: loading ? null : performLogin,
                      child:
                          loading ? const CircularProgressIndicator() : const Text("Login"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        text: "Don't have an Account? ",
                        children: [
                          TextSpan(
                            text: "Register",
                            style: const TextStyle(color: Colors.red),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.pageController.nextPage(
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
      ],
    );
  }
}

class LoginFormData {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  get payLoad => {
        "email": email.text.toLowerCase(),
        "password": password.text,
      };
}
