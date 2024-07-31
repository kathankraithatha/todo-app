import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Reusable%20components/route.dart';
import 'package:todo_app/Screens/home_page.dart';

import '../Reusable components/form_field.dart';
import '../Reusable components/intro_button.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  RouteFunction signInRoute=RouteFunction();

  //SignIn function
  signIn(String email, String password) async {
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
    }
    // If The Credentials are correctly entered
    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error Occurred: ${e.message}"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              showCloseIcon: true,
            )
        );
      }
      //If the credentials are invalid
      catch(e){
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
    //Media Query responsiveness handling
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("SignIn Page",
            style: GoogleFonts.josefinSans(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      backgroundColor: const Color.fromARGB(255, 250, 243, 243),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.1,vertical: screenHeight * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Let's Get Started !!!",
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
                  "Welcome Back to your personalized Todo App ✍️",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * 0.044,
                  ),
                  textAlign: TextAlign.center,
                ),

                //Text field Starts
                SizedBox(
                  height: screenHeight * 0.061 ,
                ),
                CustomTextField(textHint: "Enter Your Email Address",
                    textController: emailController),
                Padding(padding: EdgeInsets.symmetric(vertical:screenHeight * 0.01)),
                CustomTextField(textHint: "Enter Your Password",
                    textController: passwordController),
                Padding(padding: EdgeInsets.symmetric(vertical:screenHeight * 0.02)),

                //Sign In Button
                IntroButton(BText: "SignIn",
                    BColor: const Color.fromRGBO(78, 52, 241, 50),
                    Bheight: screenHeight * 0.05,
                    Bwidth: double.infinity,
                    borderRadius: 5,
                    onTap: () {
                        setState(() {
                          // Calling Sign In Function
                          signIn(emailController.text, passwordController.text);
                          Navigator.push(context,signInRoute.createRoute(const HomePage()));

                          //Resetting fields to empty again
                          emailController.text="";
                          passwordController.text="";
                          //Message if the login is successful
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:Text("Log In Successful"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.blue,
                                showCloseIcon: true,
                              )
                          );
                         }
                        );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
