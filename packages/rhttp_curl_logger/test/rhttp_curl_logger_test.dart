import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rhttp/rhttp.dart';
import 'package:rhttp_curl_logger/rhttp_curl_logger.dart';

void main() {
  group('RhttpCurlLogger', () {
    final methods = [
      HttpMethod.get,
      HttpMethod.post,
      HttpMethod.put,
      HttpMethod.patch,
      HttpMethod.delete,
    ];

    test('normal request', () async {
      String? curl;
      final logger = RhttpCurlLogger(logger: (c) => curl = c);
      for (final method in methods) {
        await logger.beforeRequest(
          HttpRequest(url: 'https://example.com', method: method),
        );
        expect(curl, 'curl -X ${method.value} "https://example.com"');
      }
    });

    test('request with headers', () async {
      String? curl;
      final logger = RhttpCurlLogger(logger: (c) => curl = c);
      for (final method in methods) {
        await logger.beforeRequest(
          HttpRequest(
            url: 'https://example.com',
            headers: const HttpHeaders.rawMap({
              'Content-Type': 'application/json',
              'foo': 'bar',
            }),
            method: method,
          ),
        );
        expect(
          curl,
          'curl -X ${method.value} -H "Content-Type: application/json" -H "foo: bar" "https://example.com"',
        );
      }
    });

    test('request with query parameters', () async {
      String? curl;
      final logger = RhttpCurlLogger(logger: (c) => curl = c);
      for (final method in methods) {
        await logger.beforeRequest(
          HttpRequest(
            url: 'https://example.com',
            query: {'foo': 'bar', 'baz': '1'},
            method: method,
          ),
        );
        expect(
          curl,
          'curl -X ${method.value} "https://example.com?foo=bar&baz=1"',
        );
      }
    });

    group('request body', () {
      test('json body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: const HttpBody.json({'foo': 'bar', 'baz': 1}),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -d ${r'"{\"foo\":\"bar\",\"baz\":1}"'} "https://example.com"',
          );
        }
      });

      test('form body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: const HttpBody.form({'foo': 'bar', 'baz': '1'}),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -F "foo=bar" -F "baz=1" "https://example.com"',
          );
        }
      });

      test('multipart body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: HttpBody.multipart({
                'foo': const MultipartItem.text(text: 'bar'),
                'baz': const MultipartItem.file(file: '/file/path.jpg'),
                'tez': MultipartItem.bytes(bytes: Uint8List(3)),
              }),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -F "foo=bar" -F "baz=@/file/path.jpg" -F "tez=[bytes]" "https://example.com"',
          );
        }
      });

      test('bytes body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: HttpBody.bytes(Uint8List(3)),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -d [bytes] "https://example.com"',
          );
        }
      });

      test('stream body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        // stream body
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: HttpBody.stream(Stream.value([1, 2, 3])),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -d [stream] "https://example.com"',
          );
        }

        // stream body with length
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: HttpBody.stream(Stream.value([1, 2, 3]), length: 3),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -d [stream(3)] "https://example.com"',
          );
        }
      });

      test('text body', () async {
        String? curl;
        final logger = RhttpCurlLogger(logger: (c) => curl = c);
        for (final method in methods) {
          await logger.beforeRequest(
            HttpRequest(
              url: 'https://example.com',
              body: const HttpBody.text('DATA'),
              method: method,
            ),
          );
          expect(
            curl,
            'curl -X ${method.value} -d "DATA" "https://example.com"',
          );
        }
      });
    });

    group('options', () {
      test('useDoubleQuotes = false', () async {
        String? curl;
        final logger = RhttpCurlLogger(
          logger: (c) => curl = c,
          useDoubleQuotes: false,
        );
        await logger.beforeRequest(
          HttpRequest(
            url: 'https://example.com',
            body: const HttpBody.json({'foo': 'bar', 'baz': 1}),
          ),
        );
        expect(
          curl,
          """curl -X GET -d '{"foo":"bar","baz":1}' 'https://example.com'""",
        );
      });

      test('escapeQuotesInBody = false', () async {
        String? curl;
        final logger = RhttpCurlLogger(
          logger: (c) => curl = c,
          escapeQuotesInBody: false,
        );
        await logger.beforeRequest(
          HttpRequest(
            url: 'https://example.com',
            body: const HttpBody.json({'foo': 'bar', 'baz': 1}),
          ),
        );
        expect(
          curl,
          '''curl -X GET -d "{"foo":"bar","baz":1}" "https://example.com"''',
        );
      });

      test('multiline = true', () async {
        String? curl;
        final logger = RhttpCurlLogger(
          logger: (c) => curl = c,
          multiline: true,
        );
        await logger.beforeRequest(
          HttpRequest(
            url: 'https://example.com',
            body: const HttpBody.json({'foo': 'bar', 'baz': 1}),
          ),
        );
        expect(
          curl,
          r'''
curl -X GET
-d "{\"foo\":\"bar\",\"baz\":1}"
"https://example.com"''',
        );
      });
    });
  });
}
