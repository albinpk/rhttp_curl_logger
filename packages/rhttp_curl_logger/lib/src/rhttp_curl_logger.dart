import 'dart:convert';
import 'dart:developer';

import 'package:rhttp/rhttp.dart';

/// Prints the request as a single line cURL command
class RhttpCurlLogger extends Interceptor {
  /// Creates a new [RhttpCurlLogger].
  RhttpCurlLogger({
    this.useDoubleQuotes = true,
    this.escapeQuotesInBody = true,
    this.multiline = false,
    this.logName,
    this.logger,
  });

  /// Whether to use double quotes or not. Defaults to `true`.
  final bool useDoubleQuotes;

  /// Whether to escape quotes in the body or not. Defaults to `true`.
  final bool escapeQuotesInBody;

  /// Whether to log curl command in multiline or not. Defaults to `false`.
  final bool multiline;

  /// The name of the logger. Defaults to `curl_log`.
  /// This will be ignored if [logger] is not null.
  final String? logName;

  /// A function to handle the curl command.
  ///
  /// If not provided, the curl command will be printed
  /// to the console using the [log] function.
  final void Function(String curl)? logger;

  @override
  Future<InterceptorResult<HttpRequest>> beforeRequest(
    HttpRequest request,
  ) async {
    _handleCurl(request);
    return Interceptor.next(request);
  }

  void _handleCurl(HttpRequest request) {
    final String curl;
    try {
      curl = _buildCurl(request);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log('Error building curl command', error: e);
      return;
    }
    if (logger != null) {
      logger!(curl);
    } else {
      log(curl, name: logName ?? 'curl_log');
    }
  }

  String _buildCurl(HttpRequest request) {
    final q = useDoubleQuotes ? '"' : "'"; // quote
    final s = multiline ? '\n' : ' '; // separator

    final buffer = StringBuffer(
      'curl -X ${request.method.value.toUpperCase()}',
    );

    // Append headers
    request.headers?.toMapList().forEach((name, values) {
      for (final value in values) {
        buffer
          ..write(s)
          ..write('-H $q$name: $value$q');
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
      final data = escapeQuotesInBody
          ? bodyString.replaceAll(q, '\\$q')
          : bodyString;
      buffer
        ..write(s)
        ..write('-d $q$data$q');
    }

    // Append query parameters to the URL
    final queryParams = request.query?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    final url =
        '${request.settings?.baseUrl ?? ""}${request.url}'
        '${queryParams != null ? '?$queryParams' : ''}';

    buffer
      ..write(s)
      ..write('$q$url$q');

    return buffer.toString();
  }
}
