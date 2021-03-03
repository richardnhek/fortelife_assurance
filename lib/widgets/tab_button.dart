import 'package:flutter/material.dart';

class TabButton extends StatefulWidget {
  TabButton(
      {this.icon,
      this.isActive,
      this.onPressed,
      this.tabTitle,
      this.height,
      this.width});

  final bool isActive;
  final IconData icon;
  final String tabTitle;
  final Function onPressed;
  final double height;
  final double width;

  @override
  _TabButtonState createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              widget.icon,
              size: 28,
              color: widget.isActive
                  ? Color(0xFF8AB84B)
                  : Colors.black.withOpacity(0.5),
            ),
            Text(
              widget.tabTitle,
              style: TextStyle(
                  fontFamily: "Kano",
                  fontSize: 18,
                  color: widget.isActive
                      ? Color(0xFF8AB84B)
                      : Colors.black.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
