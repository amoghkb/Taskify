import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/Code_Folders/Pages/Landing_Pages/SignupPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final Gloginkey = GlobalKey<FormState>();
  final _LoginEmailController = TextEditingController();
  final _LoginPassController = TextEditingController();

  Future<void> loginDetails() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _LoginEmailController.text.trim(),
        password: _LoginPassController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found for that email.")),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect password. Try again.")),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email format.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Log In ",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              Form(
                  key: Gloginkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
                        child: TextFormField(
                          decoration: InputDecoration(label: Text("Email")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Email";
                            } else {
                              return null;
                            }
                          },
                          controller: _LoginEmailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
                        child: TextFormField(
                          decoration: InputDecoration(label: Text("Password")),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          controller: _LoginPassController,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 350,
                        height: 45,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blueGrey),
                                elevation: WidgetStatePropertyAll(11)),
                            onPressed: () {
                              if (Gloginkey.currentState!.validate()) {
                                loginDetails();
                              }
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  )),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont Have an accoun? "),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signuppage(),
                            ));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
