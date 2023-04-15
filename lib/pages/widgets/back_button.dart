import 'package:flutter/material.dart';

import '../../core/values/dimens.dart';

class MyBackButton extends StatelessWidget {
  final Function() onPressed;
  const MyBackButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Dimens.medium,
      left: Dimens.medium,
      child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(2, 3)),
            ],
          ),
          child: const Icon(Icons.arrow_back)),
    );
  }
}
