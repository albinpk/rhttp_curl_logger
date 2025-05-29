import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rhttp/rhttp.dart';
import 'package:rhttp_curl_logger/rhttp_curl_logger.dart';

Future<void> main() async {
  await Rhttp.init();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _initRhttp();
  }

  late final RhttpClient _client;

  Future<void> _initRhttp() async {
    _client = await RhttpClient.create(
      interceptors: [
        SimpleInterceptor(
          beforeRequest: (request) async {
            return Interceptor.next(
              request.addHeader(
                name: HttpHeaderName.contentType,
                value: 'application/json',
              ),
            );
          },
        ),

        // Add RhttpCurlLogger
        if (kDebugMode)
          RhttpCurlLogger(
            useDoubleQuotes: true, // default
            escapeQuotesInBody: true, // default
            multiline: false, // default
            logName: 'curl_log', // default
            logger: null, // default
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FilledButton(onPressed: _request, child: Text('Get')),
        ),
      ),
    );
  }

  Future<void> _request() async {
    await _client.post(
      'https://jsonplaceholder.typicode.com/posts',
      query: {'foo': 'bar', 'baz': '1'},
      body: HttpBody.json({'title': 'foo', 'body': 'bar', 'userId': 1}),
    );
  }
}
