import 'package:dio/dio.dart';
import 'package:forte_life/constants/constants.dart';

class RiderService {
  static dynamic getRider() async {
    Dio dio = Dio();
    Response response = await dio.get(
      "$END_POINT/rider",
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );
    return response.data;
  }
}
