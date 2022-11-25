import 'package:ehh/constants/spacing.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.screenPadding,
        horizontal: Spacing.screenPadding,
      ),
      child: child,
    );
  }
}
