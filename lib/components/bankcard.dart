import 'package:flutter/material.dart';

class BankCard extends StatelessWidget {
  final Widget child;
  const BankCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: child,
    );
  }
}
