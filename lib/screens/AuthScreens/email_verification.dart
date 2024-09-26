import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/navigation_page.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/util/api.dart';
import 'package:todo_app/util/storage.dart';

class EmailVerification extends StatefulWidget {
  final PageController pageController;

  const EmailVerification({super.key, required this.pageController});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> with AppStorage, Api {
  final _formKey = GlobalKey<FormState>();
  VerificationFormData data = VerificationFormData();
  bool loading = false;
  bool sLoading = false;

  @override
  void initState() {
    sendOtp();
    super.initState();
  }

  void sendOtp() async {
    setState(() {
      sLoading = true;
    });
    try {
      data.email.text = (await getStorageItem("lastEmail"))!;
        var response = await context.read<AuthProvider>().sendOtp(
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

  void verifyEmail() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var response = await context.read<AuthProvider>().verifyEmail(
          data.payLoad,
        );
        await storeItems("token", response["token"]);
        await storeItems("lastEmail", response["user"]["email"]);
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
              "Verify Email",
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
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed:loading ? null : verifyEmail,
                        child: loading ? const CircularProgressIndicator() : const Text("Verify"),
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
                                sendOtp();
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
  TextEditingController email = TextEditingController();

  get payLoad => {
    "otp": otp.text,
    "email": email.text,
  };
}