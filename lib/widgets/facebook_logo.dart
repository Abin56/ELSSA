import 'package:flutter/material.dart';

import '../app/constants.dart';

class FacebookLogo extends StatelessWidget {
  const FacebookLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.facebookLogo,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
