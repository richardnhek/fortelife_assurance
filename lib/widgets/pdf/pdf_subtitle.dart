import 'package:pdf/widgets.dart';

class PDFSubtitle extends StatelessWidget {
  PDFSubtitle({this.title, this.font, this.isKhmer});

  final String title;
  final Font font;
  final bool isKhmer;
  @override
  Widget build(Context context) {
    return Container(
        width: 90,
        child: Center(
            child: Text(title,
                style: TextStyle(
                    fontSize: isKhmer == false ? 8.25 : 17, font: font))));
  }
}
