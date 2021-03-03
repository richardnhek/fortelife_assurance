import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double boxSize = 80;
    final loadingSize = boxSize * 0.4;
    return Center(
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF6ABFBC),
        ),
        child: Center(
          child: SizedBox(
            width: loadingSize,
            height: loadingSize,
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Color(0xFF8AB84B),
              ),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
