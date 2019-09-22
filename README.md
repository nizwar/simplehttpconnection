
# Simple HTTP Connection
Simple HTTP Connection, a library that i made to help me request data from internet while i develop flutter app, so i think i wanted to share it here ☺
This library using [Http](https://pub.dev/packages/http)

## Let's Code!
```dart
var url = "https://postman-echo.com/get"
ResponseHttp respHttp = await  HttpConnection.doConnection(url);
print("Status Code : ${respHttp.statusCode}");
print("Status Headers : ${respHttp.headers}");
print("Content : ${respHttp.content}");
```
You can convert it to JSON easily, just put asJson() after content and you are ready to go :)
```dart
...
//it will return null if content isn't valid to convert to json
print("Content : ${respHttp.content.asJson()}");
...
```
## Request Stuff
### Get
Psst.... i made GET request look fun!
```dart
...
///Get Request
Map<String, String> params = Map();
params["foo1"] = "bar1";
params["foo2"] = "bar2";
ResponseHttp respHttp =await  HttpConnection.doConnection(url, method: HttpConnection.get, body: params);
...
```
### Post
```dart
...
HttpConnection.doConnection(url, method: HttpConnection.post, body: params);
...
```
### Put
```dart
HttpConnection.doConnection(url, method: HttpConnection.put, body: params);
```
### Patch
```dart
...
HttpConnection.doConnection(url, method: HttpConnection.patch, body: params);
...
```
### Delete
```dart
...
HttpConnection.doConnection(url, method: HttpConnection.delete);
...
```
## Encoding
Default encoding is UTF8, you can change it of course
```dart
HttpConnection.doConnection(url, encoding: utf8);
```
