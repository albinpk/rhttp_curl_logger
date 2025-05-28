import 'dart:convert';
import 'dart:developer';

import 'package:rhttp/rhttp.dart';

/// Prints the request as a single line cURL command
class RhttpCurlLogger extends Interceptor {
  @override
  Future<InterceptorResult<HttpRequest>> beforeRequest(
    HttpRequest request,
  ) async {
    _printCurlCommand(request);
    return Interceptor.next(request);
  }

  void _printCurlCommand(HttpRequest request) {
    log(_buildSingleLineCurlCommand(request), name: 'RHTTP CURL');
  }

  String _buildSingleLineCurlCommand(HttpRequest request) {
    final buffer = StringBuffer(
      'curl -X ${request.method.value.toUpperCase()}',
    );

    // Append headers
    request.headers?.toMapList().forEach((name, values) {
      for (final value in values) {
        buffer.write(' -H "$name: $value"');
      }
    });

    // Append body
    String? bodyString;
    if (request.body case HttpBodyJson(:final json)) {
      bodyString = jsonEncode(json);
    } else if (request.body != null) {
      bodyString = request.body.toString();
    }
    if (bodyString != null) {
      // Escape for shell command - use different strategies based on shell
      // For most shells, escape double quotes
      final escapedBody = bodyString.replaceAll('"', r'\"');
      buffer.write(' -d "$escapedBody"');
    }

    // Append query parameters to the URL
    final queryParams = request.query?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final url =
        '${request.settings?.baseUrl ?? ""}${request.url}'
        '${queryParams != null ? '?$queryParams' : ''}';

    buffer.write(' "$url"');
    return buffer.toString();
  }
}
