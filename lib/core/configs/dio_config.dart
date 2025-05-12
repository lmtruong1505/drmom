// import 'package:alice/alice.dart';
// import 'package:alice/model/alice_configuration.dart';
// import 'package:alice/model/alice_http_call.dart';
// import 'package:alice/model/alice_http_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/core/configs/logger.dart';
import 'package:BGP_Retail/core/constants/api_constants.dart';
import 'package:BGP_Retail/core/env/env.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'dio_logger.dart';

@injectable
class BaseDio {
  Dio? _instance;

  Dio _dio() {
    _instance = _createDioInstance();
    return _instance!;
  }

  // final alice = Alice(
  //   configuration: AliceConfiguration(
  //     showNotification: true,
  //     // navigatorKey: alice.getNavigatorKey(),
  //     showInspectorOnShake: true,
  //   ),
  // );

  final isLog = kReleaseMode ? false : true;

  final preferences = getIt.get<Preferences>();
  final navigator = getIt.get<AppNavigator>();
  final appCubit = getIt.get<AppCubit>();

  Dio _createDioInstance() {
    late Dio dio;
    final accessToken = preferences.accessToken;
    if (accessToken == null) {
      dio = Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            "X-App-Code": "PATIENT",
          },
        ),
      );
    } else {
      if (kDebugMode) print(accessToken);

      dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': "Bearer $accessToken",
            'accept': 'application/json',
            "X-DEVICE-TYPE": "mobile",
            "X-App-Code": "PATIENT",
          },
        ),
      );
    }

    dio.interceptors.clear();

    dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.next(options);
          },
          onResponse: (response, handler) {
            // logApi(
            //   response.requestOptions.uri.toString(),
            //   response.requestOptions.method,
            //   response.requestOptions.data,
            //   response.data,
            // );
            // alice.addLog(
            //   AliceLog(
            //     level: DiagnosticLevel.info,
            //     timestamp: DateTime.now(),
            //     message: 'Error log',
            //     error: response,
            //     // stackTrace: stacktrace,
            //   ),
            // );

            return handler.next(response);
          },
          onError: (error, handler) async {
            // logApi(
            //   error.requestOptions.uri.toString(),
            //   error.requestOptions.method,
            //   error.requestOptions.data,
            //   "Error: ${error.message}",
            // );
            final statusCode = error.response?.statusCode;
            // final totenNotValid= error.response?["detail"].contains("token not valid") ;
            if (statusCode == 401 || statusCode == 403) {
              await appCubit.onForceLogout(isMessage: false);
              // navigator.replaceAll(
              //   [
              //     const ProfilePage(),
              //     LoginPage(),
              //   ],
              // );
              // Tạo và add call vào Alice

              handler.next(error);
            } else {
              handler.next(error);
            }
          },
        ),
        PrettyDioLogger(
          requestBody: isLog,
          responseBody: isLog,
          requestHeader: isLog,
        ),
        CurlLoggerDioInterceptor(
          printOnSuccess: isLog,
        ),
      ],
    );
    return dio;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    return _dio().get(
      path,
      queryParameters: data,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().post(
      path,
      data: data,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().put(
      path,
      data: data,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    Object? data,
    Options? options,
  }) async {
    return _dio().delete(
      path,
      data: data,
      options: options,
    );
  }

  Future<String?> download(String path) async {
    final status = await Permission.storage.request();
    print(status);
    if (status == PermissionStatus.denied) {
      return null;
    }

    try {
      // Get the directory to store the image
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          "${directory.path}/qr-${DateTime.now().millisecondsSinceEpoch}.png";

      // Use Dio to download the image
      final Dio dio = Dio();
      await dio.download(path, filePath);

      return filePath; // Return the file path where the image is saved
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String baseURL = EnvironmentConfig.ENV;

  Future<List<String>> checkVersion() async {
    final List<String> notes = [];
    try {
      final be = await _dio().get('$baseURL/${Api.checkversion}');

      if (be.data['details']?['notes'] is List) {
        for (final note in be.data['details']['notes']) {
          notes.add(note);
        }
        notes.removeWhere(
          (element) => element.nullOrEmpty,
        );
      }
    } catch (e) {}
    return notes;
  }
}
