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
  static const int _largeStringThreshold = 200 * 1024;
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
    return switch (input) {
      String s => s.length < _largeStringThreshold,
      List list => _shouldParseCollection(list),
      Map map => _shouldParseCollection(map.values),
      _ => false,
    };
  }

  bool _shouldParseCollection(Iterable collection) {
    if (collection.length >= _largeCollectionThreshold) {
      return true;
    }

    return collection.any(_shouldParseInIsolate);
  }

  static dynamic _parseInIsolate(Map<String, dynamic> args) {
    final parser = args[_parserKey] as PayloadParserCallback;
    return parser(args[_inputKey]);
  }
}
