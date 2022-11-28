import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  PlusButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 81, 66, 230),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 35),
          ),
        ),
      ),
    );
  }
}
