import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class IntroButton extends StatelessWidget {
  IntroButton({super.key, required this.BText, required this.BColor,required this.Bheight, required this.Bwidth, required this.onTap, required this.borderRadius});
  final String BText;
  final Color BColor;
  final double Bwidth;
  final double Bheight;
  final double borderRadius;
  Function () onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Bwidth,
      height: Bheight,
      child: OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              return BColor;
            },),
            shape: WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)));
            },),
        ),
        child: Text(BText, style: GoogleFonts.outfit(color: Colors.white, fontSize: 17),),
      ),
    );
  }
}
