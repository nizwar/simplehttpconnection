///
/// Coded by Happy man who love chocolates
/// Moch Nizwar Syafuan, nizwar@merahputih.id
///
/// Fun plugin to doing some httpconnection stuff with simpliest way
/// psst... you can also download file now!
///

library simplehttpconnection;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef void DownloadProgress(int progress, int byteCount, int totalBytes);

///Simple HTTP Connection start here
class HttpConnection {
  Client client;
  bool closed = false;

  ///Constructor of HttpConnection
  HttpConnection() {
    client = Client();
  }

  ///do Connection, call as object, do not forget to close it
  //////
  /// `url` : Where you want to request data
  /// `method` : As String, you can use class Method to use supported method
  /// `headers` : Set request headers
  /// `body` : You can also use this to get Method (Method.get)
  /// url will automaticly parsed to String
  /// `encoding` : Encoding request
  ///
  Future<ResponseHttp> connect(String url,
      {String method,
      Map<String, String> body,
      Map<String, String> headers,
      Encoding encoding}) async {
    Response response;

    if (closed)
      throw Exception(
          "You can't request on closed connection, use initConnection to initialize it or use doConnection");

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
        throw Exception("Invalid request, use class Method to make it clear");
        break;
    }

    if (response == null) return null;
    ResponseHttp responseHttp = ResponseHttp(response.statusCode,
        response.headers, RespContent(utf8.decode(response.bodyBytes)));
    return responseHttp;
  }

  ///Close the connection, call initConnection() if you want new request
  void close() {
    client.close();
    closed = true;
  }

  ///Renew the connection, call it after you call close();
  void initConnection() {
    client = Client();
    closed = false;
  }

  ///
  ///You can simply download data from this function
  /// `path` : Path to save the file
  /// (default for android ExternalStorageDirectory or /0/download)
  /// `filename` : Change filaname (default as the url)
  /// `downloadProgress` : Callback(int progress, int byteCount, int totalBytes)
  /// Progress between 0 - 100
  ///
  static Future<String> download(String url,
      {String path, String filename, DownloadProgress downloadProgress}) async {
    //Initialize all thing

    //Check the path
    String currPath = path;
    if (Platform.isAndroid) {
      currPath = path ??
              await getExternalStorageDirectory() ??
              Directory("/storage/emulated/0/Download").exists()
          ? Directory("/storage/emulated/0/Download").toString()
          : null;

      if (currPath == null) assert(path != null);
    } else {
      assert(path != null);
    }

    //Prepare the connection
    HttpClient httpClient = HttpClient();
    httpClient.connectionTimeout = Duration(seconds: 10);
    httpClient.badCertificateCallback = ((cert, host, port) => true);

    Uri uri = Uri.tryParse(url);
    if (uri == null) throw Exception("URL not valid");

    final tempRes = await httpClient.getUrl(Uri.parse(url));
    tempRes.headers
        .add(HttpHeaders.contentTypeHeader, "application/octet-stream");
    final response = await tempRes.close();

    //Lets begin
    int byteCount = 0; //Define byteCount
    int totalBytes = response.contentLength; //Define totalBytes

    File fileStuff = File(currPath +
        "/" +
        (filename ?? response.headers["filename"] ?? basename(url)));

    RandomAccessFile raf = fileStuff.openSync(mode: FileMode.write);
    Completer output = Completer<String>();
    response.listen((data) {
      //OnProgress
      byteCount += data.length;
      raf.writeFromSync(data);
      if (downloadProgress != null)
        downloadProgress(
            (100 / totalBytes * byteCount).floor(), byteCount, totalBytes);
    }, onDone: () {
      //Everything is done
      raf.closeSync();
      if (downloadProgress != null)
        downloadProgress(100, byteCount, totalBytes);
      output.complete(fileStuff.path);
    }, onError: (e) {
      //Hmm.. something wrong here
      raf.closeSync();
      fileStuff.deleteSync();
      output.completeError(e);
    }, cancelOnError: true);
    return output.future;
  }

  ///Get filename from url
  static String filenameFromUrl(String url) {
    return basename(url);
  }

  ///
  ///The magic start here!, you can request directly using this function to request data from Internet
  ///
  /// `url` : Where you want to request data
  /// `method` : As String, you can use class Method to use supported method
  /// `headers` : Set request headers
  /// `body` : You can also use this to get Method (Method.get)
  /// url will automaticly parsed to String
  /// `encoding` : Encoding request
  ///
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
        throw Exception("Invalid request, use class Method to make it clear");
        break;
    }

    if (response == null) return null;
    ResponseHttp responseHttp = ResponseHttp(response.statusCode,
        response.headers, RespContent(utf8.decode(response.bodyBytes)));
    client.close();
    return responseHttp;
  }

  ///This the secret, GET using MAP as params xoxo
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

class Method {
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
    } on FormatException {
      output = null;
    }
    return output;
  }
}
