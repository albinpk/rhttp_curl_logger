# rhttp_curl_logger

[![deploy](https://github.com/albinpk/rhttp_curl_logger/actions/workflows/deploy.yml/badge.svg)](https://github.com/albinpk/rhttp_curl_logger/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/albinpk/rhttp_curl_logger/graph/badge.svg?token=4387HYG1UE)](https://codecov.io/gh/albinpk/rhttp_curl_logger)
[![Pub Version](https://img.shields.io/pub/v/rhttp_curl_logger)](https://pub.dev/packages/rhttp_curl_logger)
[![GitHub License](https://img.shields.io/github/license/albinpk/rhttp_curl_logger)](https://github.com/albinpk/rhttp_curl_logger/blob/main/LICENSE)
![GitHub last commit](https://img.shields.io/github/last-commit/albinpk/rhttp_curl_logger)
[![Pub Points](https://img.shields.io/pub/points/rhttp_curl_logger)](https://pub.dev/packages/rhttp_curl_logger/score)

A lightweight logger for the [`rhttp`](https://pub.dev/packages/rhttp) package that prints requests as `cURL` commands to your console for easy debugging and sharing.

<!-- ---

## ✨ Features

- Logs `HTTP` requests as formatted `cURL` commands.
- Plug-and-play support with `rhttp` client.
- Useful for debugging or replicating API calls outside your app. -->

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dev_dependencies:
  rhttp_curl_logger: ^0.2.1
```

## 🚀 Usage

Use the `RhttpCurlLogger` interceptor in your `rhttp` client:

```dart
import 'package:rhttp_curl_logger/rhttp_curl_logger.dart';

final client = await RhttpClient.create(
  interceptors: [
    RhttpCurlLogger(
      useDoubleQuotes: true,    // default
      escapeQuotesInBody: true, // default
      multiline: false,         // default
      logName: 'curl_log',      // default
      logger: null,             // default
    ),
  ],
);
```

## 🧪 Example

- Configuration:

```dart
final client = RHttpClient(
  interceptors: [
    RhttpCurlLogger(
      multiline: true,
      logName: 'rhttp',
      useDoubleQuotes: false,
    ),
  ],
);
```

- Output sample:

```bash
[rhttp] curl -X POST
        -H 'content-type: application/json'
        -d '{"title":"foo","body":"bar","userId":1}'
        'https://jsonplaceholder.typicode.com/posts?foo=bar&baz=1'
```

---

If you find this package helpful, consider giving it a 👍 on [pub.dev](https://pub.dev/packages/rhttp_curl_logger) or sharing it with others.

For bugs, or feature requests, feel free to [open an issue](https://github.com/albinpk/rhttp_curl_logger/issues)
