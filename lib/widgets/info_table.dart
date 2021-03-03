import 'package:flutter/material.dart';
import 'package:forte_life/widgets/info_tablerow.dart';

class InfoTable extends StatelessWidget {
  InfoTable({this.tableChildren});
  final List<InfoTableRow> tableChildren;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.black),
      children: tableChildren,
    );
  }
}
