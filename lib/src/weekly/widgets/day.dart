import 'package:flutter/material.dart';

class Day extends StatelessWidget {
  const Day({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        24,
        (hr) => Container(
          height: 60.0,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[200]!)),
        ),
      ),
    );
  }
}
