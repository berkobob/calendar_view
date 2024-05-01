import 'package:flutter/material.dart';

class Hour extends StatelessWidget {
  const Hour({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          24,
          (hr) => SizedBox(
                height: 60.0,
                child: Transform.translate(
                    offset: const Offset(15.0, -10.0), child: Text('$hr:00')),
              )),
    );
  }
}
