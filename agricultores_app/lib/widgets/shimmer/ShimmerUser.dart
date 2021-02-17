import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShimmerUserState();
}

class _ShimmerUserState extends State<ShimmerUser> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withAlpha(10),
      highlightColor: Colors.grey.withAlpha(60),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < 5; i += 1)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      margin: EdgeInsets.only(right: 40),
                      child: CircleAvatar(),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
        ],
      ),
    );
  }
}
