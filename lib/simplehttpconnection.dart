library simplehttpconnection;

import 'dart:convert';

import 'package:http/http.dart';

///Simple HTTP Connection start here
class HttpConnection {
  ///Post request
  static String post = "POST";
  ///Get request
  static String get = "GET";
  ///Put request
  static String put = "PUT";
  ///Delete request
  static String delete = "DELETE";
  ///Patch request
  static String patch = "PATCH";

  ///The magic start here!
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

  ///This the secret, GET using MAP as params
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

///Response http, as a result after doing some request
class ResponseHttp {
  final int statusCode;
  final Map<String, String> headers;
  final RespContent content;
  ///Construct for Response HTTP that called by doConnection(...)
  ResponseHttp(this.statusCode, this.headers, this.content);
}

///Response content
class RespContent {
  final String content;

  ///Construct for Response Content that called by Response Http
  RespContent(this.content);

  ///Return string (content already string)
  String toString() {
    return content;
  }

  ///Decode json string and get the result, return Null if content isn't valid as JSON
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
