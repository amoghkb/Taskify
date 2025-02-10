import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final GSignUpkey = GlobalKey<FormState>();
  final _SignUpEmailController = TextEditingController();
  final _SignUpPassController = TextEditingController();

  Future signUpDetails(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _SignUpEmailController.text.trim(),
        password: _SignUpPassController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful! Please log in.")),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This email is already in use.")),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Password is too weak. Choose a stronger one.")),
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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 70,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Sign Up ",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              Form(
                  key: GSignUpkey,
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
                          controller: _SignUpEmailController,
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
                          controller: _SignUpPassController,
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
                              if (GSignUpkey.currentState!.validate()) {
                                signUpDetails(context);
                              }
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
