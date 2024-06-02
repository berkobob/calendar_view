import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HourLabels extends StatelessWidget {
  const HourLabels({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(
          24,
          (hr) => SizedBox(
                height: 60.0,
                child: Transform.translate(
                    offset: const Offset(1.0, -10.0),
                    child: AutoSizeText(
                      width < 500 ? '$hr' : '$hr:00',
                      maxLines: 1,
                    )),
              )),
    );
  }
}
