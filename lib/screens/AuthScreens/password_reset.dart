import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class PasswordReset extends StatefulWidget {
  final PageController pageController;

  const PasswordReset({super.key, required this.pageController});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> with AppStorage, Api {
  final _formKey = GlobalKey<FormState>();
  VerificationFormData data = VerificationFormData();
  bool isObscure = true;
  bool cPIsObscure = true;
  bool loading = false;
  bool sLoading = false;

  @override
  void initState() {
    getPasswordEmail();
    super.initState();
  }

  getPasswordEmail() async {
    data.email.text = await getStorageItem("forgetPasswordEmail") ?? "";
  }

  void resendOtp() async {
    setState(() {
      sLoading = true;
    });
    try {
      var response = await context.read<AuthProvider>().sendResetOtp(
        {"email": data.email.text},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ),
      );
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
        sLoading = false;
      });
    }
  }

  void verifyOtp() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var response = await context.read<AuthProvider>().resetPassword(
          data.payLoad,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"]),
            backgroundColor: Colors.green,
          ),
        );
        widget.pageController.jumpToPage(0);
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
    data.otp.dispose();
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
              "Reset Password",
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
                        controller: data.otp,
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Invalid OTP";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "OTP",
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
                        controller: data.confirmPassword,
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
                            icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          ),
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(Icons.key_outlined),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:loading ? null : () => widget.pageController.jumpToPage(0),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed:loading ? null : verifyOtp,
                            child: loading ? const CircularProgressIndicator() : const Text("Verify"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          text: "Didn't see the code? ",
                          children: [
                            TextSpan(
                              text: sLoading ? "..." : "Resend",
                              style: const TextStyle(color: Colors.red),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                resendOtp();
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

class VerificationFormData {
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();

  get payLoad => {
    "otp": otp.text,
    "email": email.text,
    "password":password.text,
    "password_confirmation": confirmPassword.text
  };
}