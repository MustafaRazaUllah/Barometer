import 'package:http/http.dart' as http;

class HttpClinet {
  static postApi(String path, Map data) async {
    print("API Path is => $path");
    print("Data is => $data");
    http.Response res = await http.post(Uri.parse(path), body: data);
    print(res.body);
    // return res.body;
  }
}
