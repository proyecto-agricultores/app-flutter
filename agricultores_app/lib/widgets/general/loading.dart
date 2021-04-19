import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CosechaLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withAlpha(80),
      highlightColor: Colors.grey.withAlpha(50),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          );
        },
      )
    );
  }

}
