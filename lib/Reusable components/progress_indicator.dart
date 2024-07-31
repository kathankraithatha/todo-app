import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomProgressIndicator extends StatelessWidget {
   CustomProgressIndicator({super.key, required this.progressVal, required this.maxVal, required this.completionColor, required this.incompleteColor, required this.progressIndicatorText});
  double progressVal;
  final double maxVal;
  final Color completionColor;
  final Color incompleteColor;
  final String progressIndicatorText;
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation:true,
      animationDuration: 2000,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: maxVal,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.15,
            cornerStyle: CornerStyle.bothCurve,
            color: incompleteColor,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: progressVal,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
              color: completionColor,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Text(
                progressIndicatorText, // Display progressVal here
                style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center,
              ),
              verticalAlignment: GaugeAlignment.center,
            ),
          ],
        ),
      ],
    );
  }
}
