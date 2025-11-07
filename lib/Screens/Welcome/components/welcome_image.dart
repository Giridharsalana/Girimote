import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "GIRIMOTE",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Smart Home Control",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: defaultPadding * 3),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/chat.svg",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
