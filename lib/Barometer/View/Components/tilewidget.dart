import 'package:flutter/material.dart';

Widget tileWidget({
  required BuildContext context,
  String title = 'Sensors Name',
  dynamic value = 123.456,
  required bool isNotExistBaeometer,
}) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff1692d0),
                Color(0xff132e72),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          width: width,
          height: width / 12,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff1692d0),
                Color(0xff132e72),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
          width: width,
          height: width / 12,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(11.5),
                bottomRight: Radius.circular(11.5),
              ),
            ),
            width: width,
            height: double.infinity,
            child: Center(
              child: GradientText(
                value.toString(),
                style: TextStyle(
                  fontSize: isNotExistBaeometer ? width * 0.032 : width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
                gradient: const LinearGradient(colors: [
                  Color(0xff1692d0),
                  Color(0xff132e72),
                ]),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
