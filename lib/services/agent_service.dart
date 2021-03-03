import 'package:dio/dio.dart';
import 'package:forte_life/constants/constants.dart';

class AgentService {
  static dynamic changePassword({String agentId, String newPassword}) async {
    Dio dio = Dio();
    Response response = await dio.put(
      "$END_POINT/agents/$agentId",
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
      data: {"password": newPassword},
    );
    return response.data;
  }
}
