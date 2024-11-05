import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget {
  const BarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey
      ),
    );
  }
}
