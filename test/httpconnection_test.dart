import 'package:flutter_test/flutter_test.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart'; 

main() {
  String tryUrl = "https://postman-echo.com/get";
  group('Test Stuff', () {
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
          method: HttpConnection.get, body: params);
      print("Status Code : ${respHttp.statusCode}");
      print("Status Headers : ${respHttp.headers.toString()}");
      print("Content : ${respHttp.content.asJson()}");
    });
  });
}
