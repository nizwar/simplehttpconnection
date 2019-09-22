library httpconnection;

import 'dart:convert';

import 'package:http/http.dart';

class HttpConnection {
  static String post = "POST";
  static String get = "GET";
  static String put = "PUT";
  static String delete = "DELETE";
  static String patch = "PATCH";

  static Future<ResponseHttp> doConnection(String url,
      {String method,
      Map<String, String> body,
      Map<String, String> headers,
      Encoding encoding}) async {
    Client client = Client();
    Response response;

    if (method == null) method = "get";
    switch (method.toLowerCase()) {
      case "post":
        response = await client.post(url,
            body: body ?? {},
            headers: headers ?? {},
            encoding: encoding ?? utf8);
        break;
      case "put":
        response = await client.put(url,
            body: body ?? {},
            headers: headers ?? {},
            encoding: encoding ?? utf8);
        break;
      case "delete":
        response = await client.delete(url, headers: headers ?? {});
        break;
      case "patch":
        response = await client.patch(url,
            body: body ?? {},
            headers: headers ?? {},
            encoding: encoding ?? utf8);
        break;
      case "get":
        response = await client.get(url + _paramToString(body),
            headers: headers ?? {});
        break;
      default:
        return null;
        break;
    }

    if (response == null) return null;
    ResponseHttp responseHttp = ResponseHttp(response.statusCode,
        response.headers, RespContent(utf8.decode(response.bodyBytes)));
    client.close(); 
    return responseHttp;
  }

  static Map<String, dynamic> parseJson(String json) {
    Map<String, dynamic> output;
    try {
      output = jsonDecode(json);
    } on FormatException catch (e) {
      output = null;
    }
    return output;
  }

  static String _paramToString(Map<String, String> params) {
    String output = "?";
    if (params != null) {
      for (String str in params.keys) {
        output += str + "=" + params[str] + "&";
      }
    } else {
      output = "";
    }
    return output;
  }
}

class ResponseHttp {
  final int statusCode;
  final Map<String, String> headers;
  final RespContent content;

  ResponseHttp(this.statusCode, this.headers, this.content);
}

class RespContent {
  final String content;

  RespContent(this.content);

  String toString() {
    return content;
  }

  dynamic asJson() {
    dynamic output;
    try {
      output = jsonDecode(content);
    } on FormatException catch (e) {
      output = null;
    }
    return output;
  }
}
