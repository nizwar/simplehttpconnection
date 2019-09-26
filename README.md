
# Simple HTTP Connection

Simple HTTP Connection, a library that i made to help me request data from internet while i develop flutter app, so i think i wanted to share it here ☺
This library using [Http](https://pub.dev/packages/http), Made with love by [Moch. Nizwar Syafuan](https://fb.com/nizwar.richardo) ❤

## Let's Code!

``` dart
var url = "https://postman-echo.com/get"
ResponseHttp respHttp = await  HttpConnection.doConnection(url);
print("Status Code : ${respHttp.statusCode}");
print("Status Headers : ${respHttp.headers}");
print("Content : ${respHttp.content}");
```

You can convert it to JSON easily, just put asJson() after content and you are ready to go :)

``` dart
...
//it will return null if content isn't valid to convert to json
print("Content : ${respHttp.content.asJson()}");
...
```

Now, you can also making multiple requests to the same server, just keep open a presisten connection like this

``` dart
...
ResponseHttp respHttp = await httpConnection.connect(tryUrl, method: Method.post); 
httpConnection.close(); //Close, if you do not want to use it
...
httpConnection.initConnection();   ///You have to init the connection if you want to use it again
respHttp = await httpConnection.connect(tryUrl, method: Method.post); 
...
httpConnection.close();
```

## Request Stuff

### Get
Psst....i made GET request look fun!

``` dart
...
///Get Request
Map<String, String> params = Map();
params["foo1"] = "bar1";
params["foo2"] = "bar2";
ResponseHttp respHttp =await  HttpConnection.doConnection(url, method: Method.get, body: params);
...
```

### Post

``` dart
...
HttpConnection.doConnection(url, method: HttpConnection.post, body: params);
...
```

### Put

``` dart
...
HttpConnection.doConnection(url, method: HttpConnection.put, body: params);
...
```

### Patch

``` dart
...
HttpConnection.doConnection(url, method: HttpConnection.patch, body: params);
...
```

### Delete

``` dart
...
HttpConnection.doConnection(url, method: HttpConnection.delete);
...
```

## Encoding

Default encoding is UTF8, you can change it of course

``` dart
...
HttpConnection.doConnection(url, encoding: utf8);
...
``` 

## Download

Now you can download file from SimpleHttpConnection in simpliest way :D
Thanks to Eka Setiawan Saputra from Flutter Indonesia for inspiring me...
```dart
... 
await HttpConnection.download(
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",    //Download URL
    path: "YOUR PATH HERE",
    filename: "YOUR FILENAME HERE", //Do not declare if you want origin name 
    downloadProgress: (progress, byteCount, totalBytes) {
        "<Do your magic here>"
    },);
...
```

