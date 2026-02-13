import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../utils/log.dart';

typedef PayloadParserCallback = dynamic Function(dynamic input);

abstract class PayloadParser {
  Future<T> parse<T>({
    required dynamic input,
    required PayloadParserCallback parser,
    bool forceIsolate = false,
  });
}

@LazySingleton(as: PayloadParser)
class IsolatePayloadParser implements PayloadParser {
  static const int _largeCollectionThreshold = 500;
  static const String _parserKey = 'parser';
  static const String _inputKey = 'input';

  @override
  Future<T> parse<T>({
    required dynamic input,
    required PayloadParserCallback parser,
    bool forceIsolate = false,
  }) async {
    if (!forceIsolate && !_shouldParseInIsolate(input)) {
      return parser(input) as T;
    }

    try {
      final result = await compute(
        IsolatePayloadParser._parseInIsolate,
        <String, dynamic>{
          _parserKey: parser,
          _inputKey: input,
        },
      );
      return result as T;
    } catch (error, stackTrace) {
      Log.warning('Payload isolate parsing failed, falling back to main isolate.');
      Log.error('[Payload Parse Fallback]', error: error, stackTrace: stackTrace);
      return parser(input) as T;
    }
  }

  bool _shouldParseInIsolate(Object? input) {
    if (input is List) {
      if (input.length >= _largeCollectionThreshold) {
        return true;
      }

      for (final item in input) {
        if (_shouldParseInIsolate(item)) {
          return true;
        }
      }
    }

    if (input is Map) {
      if (input.length >= _largeCollectionThreshold) {
        return true;
      }

      for (final value in input.values) {
        if (_shouldParseInIsolate(value)) {
          return true;
        }
      }
    }

    return false;
  }

  static dynamic _parseInIsolate(Map<String, dynamic> args) {
    final parser = args[_parserKey] as PayloadParserCallback;
    return parser(args[_inputKey]);
  }
}
