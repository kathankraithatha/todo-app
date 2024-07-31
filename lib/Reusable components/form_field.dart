import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.textHint, required this.textController});
  final String textHint;
  final TextEditingController textController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)),
          hintText: textHint,
          hintStyle: GoogleFonts.outfit()
      ),
    );
  }
}
