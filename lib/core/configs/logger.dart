import 'package:logger/logger.dart';

final logger = Logger();
List<LogModel> apiLogs = []; // Lưu danh sách API đã gọi

void logApi(String url, String method, dynamic body, dynamic response) {
  final log = LogModel(
    url: url,
    response: response,
    body: body,
    method: method,
  );
  apiLogs.add(log);
  logger.i(log); // Log ra console
}

class LogModel {
  final String url;
  final String method;
  final dynamic response;
  final dynamic body;

  LogModel({
    required this.url,
    required this.response,
    required this.body,
    required this.method,
  });
}
