import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  final String overview;
  const Overview({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      overview,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}
