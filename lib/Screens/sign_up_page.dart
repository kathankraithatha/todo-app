import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Reusable%20components/form_field.dart';
import 'package:todo_app/Reusable%20components/intro_button.dart';
import 'package:todo_app/Reusable%20components/route.dart';
import 'package:todo_app/Screens/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  RouteFunction signUpRoute = RouteFunction();

  signUp(String email, String password) async {
    //If email or password is empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enter Credentials"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.blue,
            showCloseIcon: true,
          )
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error Occurred: ${e.message}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              showCloseIcon: true,
            )
        );
      } catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An unexpected error occurred"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              showCloseIcon: true,
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("SignUp Page",
            style: GoogleFonts.josefinSans(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 243, 243),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.1,vertical: screenHeight * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's Register \nAccount",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.07,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: screenHeight * 0.013,
              ),
              Text(
                "Wishing you a \nproductive journey 🚀",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.044,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: screenHeight * 0.061 ,
              ),
              CustomTextField(textHint: "Enter Your Email Address",
                  textController: emailController),
              Padding(padding: EdgeInsets.symmetric(vertical:screenHeight * 0.01)),
              CustomTextField(textHint: "Enter Your Password",
                  textController: passwordController),
              Padding(padding: EdgeInsets.symmetric(vertical:screenHeight * 0.01)),

              CustomTextField(textHint: "Confirm Your Password",
                  textController: confirmPasswordController),
              Padding(padding: EdgeInsets.symmetric(vertical:screenHeight * 0.02)),

              IntroButton(BText: "SignUp",
                  BColor: const Color.fromRGBO(78, 52, 241, 50),
                  Bheight: screenHeight * 0.05,
                  Bwidth: double.infinity,
                  borderRadius: 5,
                  onTap: () {
                    if(passwordController.text!=confirmPasswordController.text){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:Text("Confirm Your Password Again!"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                        )
                      );
                    } else{
                      setState(() {
                        signUp(emailController.text, passwordController.text);
                        emailController.text="";
                        passwordController.text="";
                        confirmPasswordController.text="";
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:Text("Email Registered Successfully"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.blue,
                            showCloseIcon: true,
                          )
                        );
                      });
                    }

                  }
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an Account?",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 5)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, signUpRoute.createRoute(const SignInPage()));
                    },
                    child: Text(
                      "LogIn",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: const Color.fromRGBO(78, 52, 241, 50)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
