import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Reusable%20components/intro_button.dart';
import 'package:todo_app/Reusable%20components/route.dart';
import 'package:todo_app/Screens/sign_in_page.dart';
import 'package:todo_app/Screens/sign_up_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // Useful Functions for the Intro Page
  RouteFunction introRoute = RouteFunction();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Todo App",
            style: GoogleFonts.josefinSans(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 243, 243),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: screenHeight * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: SvgPicture.asset(
                      'lib/animation_assets/intro2.svg',
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.8,
                    ),
                  ),
                  Text(
                    "Dive into Productivity",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.06,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Manage your tasks effortlessly with TaskMaster. Simplify your productivity today.",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.035,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntroButton(
                  BText: "SignUp",
                  BColor: Colors.black87,
                  Bwidth: screenWidth * 0.35,
                  Bheight: screenHeight * 0.07,
                  borderRadius: 10,
                  onTap: () {
                    Navigator.push(
                        context, introRoute.createRoute(const SignUpPage()));
                  },
                ),
                const SizedBox(width: 20),
                IntroButton(
                  BText: "SignIn",
                  BColor: const Color.fromRGBO(78, 52, 241, 50),
                  Bwidth: screenWidth * 0.35,
                  Bheight: screenHeight * 0.07,
                  borderRadius: 10,
                  onTap: () {
                    Navigator.push(
                        context, introRoute.createRoute(const SignInPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
