@Timeout(Duration(days: 1))
import 'package:flutter_test/flutter_test.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

main() {
  String tryUrl = "https://postman-echo.com/get";
  HttpConnection httpConnection = HttpConnection();
  group('Test Stuff', () {
    test('httpConnection Operation', () async {
      ResponseHttp respHttp =
          await httpConnection.connect(tryUrl, method: Method.post);
      print("Status Code 1 : ${respHttp.statusCode}");
      print("Status Headers 1 : ${respHttp.headers.toString()}");
      print("Content 1 : ${respHttp.content.toString()}");
      httpConnection.close();

      httpConnection.initConnection();

      ///After close, you have to init the connection
      respHttp = await httpConnection.connect(tryUrl, method: Method.post);
      print("Status Code 2 : ${respHttp.statusCode}");
      print("Status Headers 2 : ${respHttp.headers.toString()}");
      print("Content 2 : ${respHttp.content.toString()}");
      httpConnection.close();
    });

    test('Get Response from tryUrl', () async {
      ResponseHttp respHttp = await HttpConnection.doConnection(tryUrl);
      print("Status Code : ${respHttp.statusCode}");
      print("Status Headers : ${respHttp.headers.toString()}");
      print("Content : ${respHttp.content.toString()}");
    });

    test('tryUrl Response as JSON', () async {
      ResponseHttp respHttp = await HttpConnection.doConnection(tryUrl);
      print("Status Code : ${respHttp.statusCode}");
      print("Status Headers : ${respHttp.headers.toString()}");
      print("Content : ${respHttp.content.asJson()}");
      expect(respHttp.content.asJson() == null, false);
    });

    test('GET Request', () async {
      Map<String, String> params = Map();
      params["foo1"] = "bar1";
      params["foo2"] = "bar2";

      ResponseHttp respHttp = await HttpConnection.doConnection(tryUrl,
          method: Method.get, body: params);
      print("Status Code : ${respHttp.statusCode}");
      print("Status Headers : ${respHttp.headers.toString()}");
      print("Content : ${respHttp.content.asJson()}");
    });

    test("Download Data", () async {
      SimpleDownload simpleDownload = SimpleDownload();
      print(await simpleDownload.start(
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          path: "D:", downloadProgress: (progress, count, max) {
        print("Lagi Download : " + progress.toString() + "%");
      }));
    });
  });
}
